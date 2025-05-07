#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include"framelesswindow.h"
#include"imagecolor.h"
#include<threadmanager.h>
int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    qmlRegisterType<FramelessWindow>("FlWindow",1,0,"FramelessWindow");
    qmlRegisterType<ImageColor>("ImgColor",1,0,"ImageColor");
    //qmlRegisterType<ThreadManager>("ThreadManager",1,0,"ThreadManager");
    qmlRegisterSingletonType<ThreadManager>("ThreadManager", 1, 0, "ThreadManager", [](QQmlEngine *, QJSEngine *) -> QObject * {
        return &ThreadManager::instance();
    });
    qRegisterMetaType<QColor>("QColor");
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
