#ifndef SYSTEM2_H
#define SYSTEM2_H

#include <QObject>
#include <QTimer>
#include <QDateTime>

class system2 : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool carLocked READ carLocked WRITE setCarLocked NOTIFY carLockedChanged)
    Q_PROPERTY(int outdoorTemp READ outdoorTemp WRITE setOutdoorTemp NOTIFY outdoorTempChanged)
    Q_PROPERTY(QString userName READ userName WRITE setUserName NOTIFY userNameChanged)
    Q_PROPERTY(QString currentTime READ currentTime WRITE setCurrentTime NOTIFY currentTimeChanged )

public:
    explicit system2(QObject *parent = nullptr);

    bool carLocked() const;
    void setCarLocked(bool newCarLocked);

    int outdoorTemp() const;
    void setOutdoorTemp(int newOutdoorTemp);

    QString userName() const;
    void setUserName(const QString &newUserName);

    QString currentTime() const;
    void setCurrentTime(const QString &newCurrentTime);

signals:
    void carLockedChanged();
    void outdoorTempChanged();
    void userNameChanged();
    void currentTimeChanged();

private slots:           // <-- add this
    void updateTime();

private:
    bool m_carLocked;
    int m_outdoorTemp;
    QString m_userName;
    QString m_currentTime;
    QTimer *m_timer;
};

#endif // SYSTEM2_H
