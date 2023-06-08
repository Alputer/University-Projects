#include <QtGui>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QWidget>
#include <QTableWidget>
#include <QLabel>
#include <QDialog>

class MyClass : public QDialog
{
    Q_OBJECT

    public:
      MyClass(QVector<QString> *currency_names_symbols, QWidget *parent = 0);

    public slots:
      void replyFinished(QNetworkReply *reply) ;
      void set_currency_ids(QNetworkReply *reply);
      void util_func();

    private:
      QVector<QString> *currency_names_symbols; //the name/symbol of needed currencies (given in input)
      QVector<QString> currency_ids;            //the ids of needed currencies
      QTableWidget *tableWidget;                //a table widget showing the whole thing
      QNetworkAccessManager *manager1 ;         //makes a request to get rates of needed currencies
      QNetworkAccessManager *manager2 ;         //makes a request to get id/symbol/name of all currencies
      int length;                               //number of needed currencies
} ;
