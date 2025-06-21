#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <Resources/system2.h>
#include <Resources/hvachandler.h>
#include <QQmlContext>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    system2 m_systemHandler;
    HVAChandler m_driverHVACHandler;
    HVAChandler m_passengerHVACHandler;

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("teslaDashboard", "Main");

    QQmlContext * context(engine.rootContext());
    context->setContextProperty("systemHandler", &m_systemHandler);
    context->setContextProperty("driverHVAC", &m_driverHVACHandler);
    context->setContextProperty("passengerHVAC", &m_passengerHVACHandler);


    return app.exec();
}
