#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QDebug>

#include "cxx-qt-gen/qobject.cxxqt.h"

int main(int argc, char *argv[])
{
    QQuickWindow::setGraphicsApi(QSGRendererInterface::VulkanRhi);
    qputenv("QT_ASSUME_STDERR_HAS_CONSOLE", "1");
    QGuiApplication app(argc, argv);
    qDebug() << "Debug";

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/Main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    qmlRegisterType<PluginSystem>("com.kdab.cxx_qt.demo", 1, 0, "PluginSystem");

    engine.load(url);

    return app.exec();
}
