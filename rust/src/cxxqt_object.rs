use core::pin::Pin;
use std::path::Path;
use async_std::task::spawn;

use cxx_qt::{CxxQtType, Threading};
use cxx_qt_lib::QString;
use futures::executor::block_on;
use once_cell::sync::Lazy;
use title_plugin_system::PlumbaPluginSystem;
use title_plugin_system::title_plugin::{Title, to_json};
use tokio::sync::Mutex;
use tokio::task::JoinSet;

#[cxx_qt::bridge]
pub mod qobject {
    unsafe extern "C++" {
        include!("cxx-qt-lib/qstring.h");
        /// An alias to the QString type
        type QString = cxx_qt_lib::QString;
    }

    unsafe extern "RustQt" {
        // The QObject definition
        // We tell CXX-Qt that we want a QObject class with the name MyObject
        // based on the Rust struct MyObjectRust.
        #[qobject]
        #[qml_element]
        type PluginSystem = super::PluginSystemRust;
    }

    impl cxx_qt::Threading for PluginSystem {}

    unsafe extern "RustQt" {
        /// A new sensor has been detected
        #[qsignal]
        fn title_loaded(self: Pin<&mut PluginSystem>, title: &QString);

        #[qsignal]
        fn search_loaded(self: Pin<&mut PluginSystem>, search_res: &QString);
        #[qsignal]
        fn season_title_loaded(self: Pin<&mut PluginSystem>, titles: &QString);
    }

    unsafe extern "RustQt" {
        // Declare the invokable methods we want to expose on the QObject
        #[qinvokable]
        fn load_directory(self: Pin<&mut PluginSystem>, path: &QString);

        #[qinvokable]
        fn get_title_with_id(self: Pin<&mut PluginSystem>, id: usize);

        #[qinvokable]
        fn search(self: Pin<&mut PluginSystem>, search: &QString);

        #[qinvokable]
        fn season_title_load(self: Pin<&mut PluginSystem>);
    }
}

#[derive(Default)]
pub struct PluginSystemRust {
    pub(crate) plugin_system: PlumbaPluginSystem
}

const PATH_PLUGINS: &str = "/home/lolkapm/RustroverProjects/title-plugin-system/plugins";

static PLUGIN_SYSTEM: Lazy<Mutex<PlumbaPluginSystem>> = Lazy::new(|| Mutex::new(PlumbaPluginSystem::default()));

impl qobject::PluginSystem {
    /// Increment the number Q_PROPERTY
    pub fn load_directory(self: Pin<&mut Self>, path: &QString) {
        block_on(async {
            PLUGIN_SYSTEM.lock().await.load_directory(&Path::new(&path.to_string())).expect("")
        })
    }

    pub fn search(self: Pin<&mut Self>, search: &QString) {
        let qt_thread = self.qt_thread();
        let search = search.to_string();

        spawn(async move {
            let mut plugin = PLUGIN_SYSTEM.lock().await;
            plugin.load_directory(&Path::new(PATH_PLUGINS)).expect("");
            let title = plugin.get_plugin(0).search(search).await;
            let json_title = match title {
                Ok(title) => QString::from(to_json(title).unwrap().clone().as_str()),
                Err(err) => {
                    let err_json = serde_json::json!({
                            "error": err
                        });
                    QString::from(err_json.to_string().as_str())
                }
            };

            qt_thread.queue(move |t| {
                t.search_loaded(&json_title);
            }).unwrap();
        });
    }

    pub fn season_title_load(self: Pin<&mut Self>) {
        let qt_thread = self.qt_thread();

        spawn(async move {
            let mut plugin = PLUGIN_SYSTEM.lock().await;
            plugin.load_directory(&Path::new(PATH_PLUGINS)).expect("");
            let title = plugin.get_plugin(0).get_season_titles().await;
            let json_title = match title {
                Ok(title) => QString::from(to_json(title).unwrap().clone().as_str()),
                Err(err) => {
                    let err_json = serde_json::json!({
                            "error": err
                        });
                    QString::from(err_json.to_string().as_str())
                }
            };

            qt_thread.queue(move |t| {
                t.season_title_loaded(&json_title);
            }).unwrap();
        });
    }

    /// Print a log message with the given string and number
    pub fn get_title_with_id(self: Pin<&mut Self>, id: usize) {
        let qt_thread = self.qt_thread();
        spawn(async move {
            let mut plugin = PLUGIN_SYSTEM.lock().await;
            plugin.load_directory(&Path::new(PATH_PLUGINS)).expect("");
            let title = plugin.get_plugin(0).get_title_with_id(id).await;
            let json_title = match title {
                Ok(title) => QString::from(title.as_json().unwrap().clone().as_str()),
                Err(err) => {
                    let err_json = serde_json::json!({
                            "error": err
                        });
                    QString::from(err_json.to_string().as_str())
                }
            };

            qt_thread.queue(move |t| {
                t.title_loaded(&json_title);
            }).unwrap();
        });
    }
}

#[cfg(test)]
mod test {
    use std::path::Path;
    use std::thread;
    use std::time::Duration;
    use async_std::task::{block_on, spawn};
    use tokio::task::JoinSet;
    use crate::cxxqt_object::{PATH_PLUGINS, PLUGIN_SYSTEM};

    #[test]
    fn first_test() {
        // block_on(async {
        //     spawn(async {
        //         let mut join = JoinSet::new();
        //
        //         join.spawn(async {
        //
        //
        //             //plugin.get_plugin(0).get_title_with_id(1).await
        //         });
        //
        //         println!("Title");
        //         while let Some(q) = join.join_next().await {
        //             let res = q.unwrap();
        //             println!("{res:?}");
        //         }
        //     });
        // });
        thread::spawn(|| {
            spawn(async {
                let mut plugin = PLUGIN_SYSTEM.lock().await;
                plugin.load_directory(&Path::new(PATH_PLUGINS)).expect("");
                let request = reqwest::get("https://google.com").await.unwrap();
                request.text().await.unwrap();
                println!("{:?}", plugin.get_plugin(0).get_title_with_id(1).await)
            })
        });
        thread::sleep(Duration::from_secs(5));
    }
}