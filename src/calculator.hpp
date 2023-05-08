#ifndef CALCULATOR_H

#define CALCULATOR_H

#include <QObject>
#include <QString>
#include <QStringList>
#include <QVariantMap>


class calculator : public QObject {
  Q_OBJECT
  void init_variables();
  static QString typeset(double x);
  static QString get_settings_path();

public:
  explicit calculator(QObject *parent = nullptr);
  virtual ~calculator();
  Q_INVOKABLE QVariantMap exprtk(QString formula);
  //Q_INVOKABLE QVariantMap calculate(QString formula);
  //Q_INVOKABLE void removeVariable(int);
  //Q_INVOKABLE void clear();
  //Q_INVOKABLE QVariantList getVariables() const;

signals:

public slots:
};

#endif  // CALCULATOR_H
