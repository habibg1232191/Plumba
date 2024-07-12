use cxx_qt_build::{CxxQtBuilder, QmlModule};

fn main() {
    CxxQtBuilder::new()
        .qml_module(QmlModule {
            uri: "com.kdab.cxx_qt.demo",
            rust_files: &["src/cxxqt_object.rs"],
            qml_files: &["../qml/Main.qml"],
            ..Default::default()
        })
        .build();
}