#ifndef SETTINGSMANAGER_H
#define SETTINGSMANAGER_H

#include <QObject>
#include <QSettings>

class SettingsManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString angleUnit READ angleUnit WRITE setAngleUnit NOTIFY angleUnitChanged)
    Q_PROPERTY(int reprFloatPrecision READ reprFloatPrecision WRITE setReprFloatPrecision NOTIFY reprFloatPrecisionChanged())
    Q_PROPERTY(bool autoSimplify READ autoSimplify WRITE setAutoSimplify NOTIFY autoSimplifyChanged)
    Q_PROPERTY(bool symbolicMode READ symbolicMode WRITE setSymbolicMode NOTIFY symbolicModeChanged)
    Q_PROPERTY(bool rationalMode READ rationalMode WRITE setRationalMode NOTIFY rationalModeChanged)
    Q_PROPERTY(QString recentVars READ recentVars WRITE setRecentVars NOTIFY recentVarsChanged)
    Q_PROPERTY(QString lastFormula READ lastFormula WRITE setLastFormula NOTIFY lastFormulaChanged)


public:
    explicit SettingsManager(QObject *parent = 0);
    Q_INVOKABLE void setVibration(int on);
    Q_INVOKABLE int vibration();

    void setAngleUnit(QString unit);
    QString angleUnit();

    int reprFloatPrecision() { return settings->value("reprFloatPrecision").toInt(); }
    void setReprFloatPrecision(int prec);

    bool autoSimplify() { return settings->value("autoSimplify").toBool(); }
    void setAutoSimplify(bool enabled);

    bool symbolicMode() { return settings->value("symbolicMode").toBool(); }
    void setSymbolicMode(bool enabled);

    bool rationalMode() { return settings->value("rationalMode").toBool(); }
    void setRationalMode(bool enabled);

    void setRecentVars(QString vars);
    QString recentVars();

    void setLastFormula(QString formula);
    QString lastFormula();


private:
    QSettings * settings;

signals:
    void angleUnitChanged();
    void reprFloatPrecisionChanged();
    void autoSimplifyChanged();
    void symbolicModeChanged();
    void rationalModeChanged();
    void recentVarsChanged();
    void lastFormulaChanged();

public slots:

};

#endif // SETTINGSMANAGER_H
