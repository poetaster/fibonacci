#include "settingsmanager.h"

SettingsManager::SettingsManager(QObject *parent) :
    QObject(parent)
{
    settings = new QSettings("de.poetaster/Fibonacci", "Fibonacci");

    if(settings->value("vibration") == QVariant())
        settings->setValue("vibration", 0);
    if(settings->value("angle_unit") == QVariant())
        settings->setValue("angle_unit", QString("Degree"));
    if(settings->value("reprFloatPrecision") ==
            QVariant()) settings->setValue("reprFloatPrecision", 9);

    if(settings->value("symbolicMode") == QVariant())
        settings->setValue("symbolicMode", true);
    if(settings->value("rationalMode") == QVariant())
        settings->setValue("rationalMode", true);
    if(settings->value("autoSimplify") == QVariant())
        settings->setValue("autoSimplify", true);

    if(settings->value("recentVars") == QVariant())
        settings->setValue("recentVars", QString("x:=0; y:=1; var t[2]:={0,1}; z:=12;"));
    if(settings->value("lastFormula") == QVariant())
        settings->setValue("lastFormula", QString("while((x+=1)<z)\n{y:=sum(r);r[0]:=r[1];r[1]:=y;a[x]:=y}\nreturn[a];"));
}

void SettingsManager::setVibration(int on)
{
    if(on) settings->setValue("vibration", 1);
    else settings->setValue("vibration", 0);
}

int SettingsManager::vibration()
{
    return settings->value("vibration").toInt();
}

void SettingsManager::setAngleUnit(QString unit)
{
    if(unit != settings->value("angle_unit").toString()){
        settings->setValue("angle_unit", unit);
        emit angleUnitChanged();
    }
}

QString SettingsManager::angleUnit()
{
    return settings->value("angle_unit").toString();
}

void SettingsManager::setRecentVars(QString vars)
{
    if(vars != settings->value("recentVars").toString()){
        settings->setValue("recentVars", vars);
        emit recentVarsChanged();
    }
}

QString SettingsManager::recentVars()
{

    return settings->value("recentVars").toString();
}

void SettingsManager::setLastFormula(QString formula)
{
    if(formula != settings->value("lastFormula").toString()){
        settings->setValue("lastFormula", formula);
        emit lastFormulaChanged();
    }
}

QString SettingsManager::lastFormula()
{

    return settings->value("lastFormula").toString();
}

void SettingsManager::setReprFloatPrecision(int prec)
{
    if(prec != reprFloatPrecision()){
        settings->setValue("reprFloatPrecision", prec);
        emit reprFloatPrecisionChanged();
    }
}

void SettingsManager::setAutoSimplify(bool enabled)
{
    if(enabled != autoSimplify()){
        settings->setValue("autoSimplify", enabled);
        emit autoSimplifyChanged();
    }
}

void SettingsManager::setSymbolicMode(bool enabled)
{
    if(enabled != symbolicMode()){
        settings->setValue("symbolicMode", enabled);
        emit symbolicModeChanged();
    }
}

void SettingsManager::setRationalMode(bool enabled)
{
    if(enabled != rationalMode()){
        settings->setValue("rationalMode", enabled);
        emit rationalModeChanged();
    }
}
