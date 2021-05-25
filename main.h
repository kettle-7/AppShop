#ifndef MAIN_H
#include <QtCore>

#define MAIN_H

class Curler : public QObject {
    Q_OBJECT
public: Curler() {};
public: Q_INVOKABLE QString downloadFile(QString url);
};

#endif // MAIN_H
