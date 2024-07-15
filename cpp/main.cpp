#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QDebug>

#include "cxx-qt-gen/qobject.cxxqt.h"

int main(int argc, char *argv[])
{
    QQuickWindow::setGraphicsApi(QSGRendererInterface::VulkanRhi);
    qputenv("QT_ASSUME_STDERR_HAS_CONSOLE", "1");
    
    QGuiApplication application(argc, argv);
    
    QQmlApplicationEngine engine;
    
    const QUrl qmlUrl(QStringLiteral("qrc:/Main.qml"));
    
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &application,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection
    );
    
    qmlRegisterType<PluginSystem>("com.kdab.cxx_qt.demo", 1, 0, "PluginSystem");
    
    engine.load(qmlUrl);
    
    return application.exec();
}
