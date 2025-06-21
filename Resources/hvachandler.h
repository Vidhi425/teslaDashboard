#ifndef HVAC_HANDLER_H
#define HVAC_HANDLER_H

#include <QObject>

class HVAChandler : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int targetTemperature READ targetTemperature WRITE setTargetTemperature NOTIFY targetTemperatureChanged)

public:
    explicit HVAChandler(QObject *parent = nullptr);

    int targetTemperature() const;
    void setTargetTemperature(int newTargetTemperature);

    Q_INVOKABLE void incrementTargetTemperature(const int &val);

signals:
    void targetTemperatureChanged();

private:
    int m_targetTemperature;
};

#endif // HVAC_HANDLER_H
