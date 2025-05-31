#include "system2.h"

system2::system2(QObject *parent)
    : QObject{parent}, m_carLocked(false), m_outdoorTemp(64), m_userName("Vidhi")
{
    m_timer = new QTimer(this);
    connect(m_timer, &QTimer::timeout, this, &system2::updateTime);
    m_timer->start(1000);  // update every second

    // initialize current time immediately
    setCurrentTime(QDateTime::currentDateTime().toString("hh:mm:ss"));
}

bool system2::carLocked() const
{
    return m_carLocked;
}

void system2::setCarLocked(bool newCarLocked)
{
    if (m_carLocked == newCarLocked)
        return;
    m_carLocked = newCarLocked;
    emit carLockedChanged();
}

int system2::outdoorTemp() const
{
    return m_outdoorTemp;
}

void system2::setOutdoorTemp(int newOutdoorTemp)
{
    if (m_outdoorTemp == newOutdoorTemp)
        return;
    m_outdoorTemp = newOutdoorTemp;
    emit outdoorTempChanged();
}

QString system2::userName() const
{
    return m_userName;
}

void system2::setUserName(const QString &newUserName)
{
    if (m_userName == newUserName)
        return;
    m_userName = newUserName;
    emit userNameChanged();
}

QString system2::currentTime() const
{
    return m_currentTime;
}

void system2::setCurrentTime(const QString &newCurrentTime)
{
    if (m_currentTime == newCurrentTime)
        return;
    m_currentTime = newCurrentTime;
    emit currentTimeChanged();
}

void system2::updateTime()
{
    QString timeStr = QDateTime::currentDateTime().toString("hh:mm:ss");
    setCurrentTime(timeStr);
}
