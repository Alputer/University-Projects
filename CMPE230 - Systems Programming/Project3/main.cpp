#include <iostream>
#include <QtCore>
#include <QtGlobal>
#include <QApplication>
#include "myclass.h"
#include <QDataStream>
#include <QString>
#include <QVector>


 int main(int argc,char *argv[]){
    QApplication a(argc, argv);

    QString path(qgetenv("MYCRYPTOCONVERT")); //get path of input file

    QFile file(path);
    file.open(QIODevice::ReadOnly); //open input file

    QVector<QString> currency_names_symbols;

    while(!file.atEnd()){
        QString tmp;
        tmp = file.readLine();

        //if there is '\n' at the end, delete it.
        if(tmp.endsWith('\n')){
            tmp.truncate(tmp.length()-1);
        }

        currency_names_symbols.append(tmp); //add the symbol/name to the vector
    }



    MyClass my(&currency_names_symbols);

    my.show();

    return a.exec();
 }
