#include <iostream>
#include <QtGui>
#include <QLabel>
#include <QDialog>
#include <QHBoxLayout>
#include <QTableWidget>
#include <QHeaderView>
#include <QRegExp>
#include "myclass.h"

using namespace std;

/*
 * Constructor of this class. Connects needed SIGNAL and SLOTS to create the table according to the given input.
 * Input is a QVector of currency names/symbols
*/
MyClass::MyClass(QVector<QString> *currency_names_symbols_, QWidget *parent) : QDialog(parent)
{

    manager1 = new QNetworkAccessManager(this) ;
    manager2 = new QNetworkAccessManager(this) ;


    connect(manager1, SIGNAL(finished(QNetworkReply*)),this, SLOT(replyFinished(QNetworkReply *)));
    connect(manager2, SIGNAL(finished(QNetworkReply*)),this, SLOT(set_currency_ids(QNetworkReply*)));


    //set variables of this object
    this->currency_names_symbols = currency_names_symbols_;
    int rows = this->currency_names_symbols->length();
    this->length = this->currency_names_symbols->length();
    this->tableWidget = new QTableWidget(rows,3,this);
    this->tableWidget->setWindowTitle("curr");

    //set size of the table
    this->tableWidget->resize(800, 100+rows*50);


    manager2->get(QNetworkRequest(QUrl("https://api.coingecko.com/api/v3/coins/list"))); //set_currency_ids will be called
}


/*
 * It is a SLOT and called when manager1 requests. Fills the table cells with rates of currencies in currency_ids QVector.
*/
void MyClass::replyFinished(QNetworkReply *reply)  {

    // read the data fetched from the web site
    QString data = (QString) reply->readAll();


    QString str;
    int pos = 0;

    //fill the table cells with the received data
    for(int i = 0 ; i < this->length; i++){
        for(int j = 0 ; j < 3; j++){

            QString curr_str = currency_ids.at(i);
            QRegExp *rx;


            // use pattern matching to extract the rate
            if(j == 0){
            rx = new QRegExp("\"" + curr_str +"\":\\{\"usd\":(\\d+\\.?\\d*)");
            }
            else if(j == 1){
            rx = new QRegExp("\"" + curr_str + "\":\\{\"usd\":\\d+\\.?\\d*,\"eur\":(\\d+\\.?\\d*)");
            }
            else{
            rx = new QRegExp("\"" + curr_str + "\":\\{\"usd\":\\d+\\.?\\d*,\"eur\":\\d+\\.?\\d*,\"gbp\":(\\d+\\.?\\d*)");
            }



            if ( rx->indexIn(data, pos) != -1 ) {
            str = rx->cap(1);    // rate found
            }
            else {
            str = QString("Error") ;
            }

            tableWidget->setItem(i, j, new QTableWidgetItem(str)); //fill this cell of the table
        }
    }


}

/*
 * It is a SLOT and called when manager1 requests. Gets name/id/symbol of all coins and adds ids of
 * needed currencies(the currencies (name or symbol) given in input) to currency_ids QVector.
 * Then calls the method: util_func
*/
void MyClass::set_currency_ids(QNetworkReply *reply){

    QString data = (QString) reply->readAll(); //name/id/symbol of all coins in json format


    QVector<QString> currency_id_list;
    int pos = 0;
    // add all coins ids to currency_id_list
    for(int i = 0 ; i < this->currency_names_symbols->length(); i++){

        QString curr_name_symbol = this->currency_names_symbols->at(i);
        QString curr_id; //We will set it now.


        //  "id":"01coin","symbol":"zoc","name":"01coin"
        QRegExp *rx1 = new QRegExp("\"id\":\"([a-zA-Z0-9.\-]+)\",\"symbol\":\"([a-zA-Z0-9.\-]+)\",\"name\":\"" + curr_name_symbol + "\""); //For Names
        QRegExp *rx2 = new QRegExp("\"id\":\"([a-zA-Z0-9.\-]+)\",\"symbol\":\"" + curr_name_symbol + "\""); //For symbols


        if (rx1->indexIn(data, pos) != -1 ){
            curr_id = rx1->cap(1); }    // rate found
        else if(rx2->indexIn(data, pos) != -1){
            curr_id = rx2->cap(1);
            }
        else{
            std::cout << "Wrong regex or crypto name/id";
           }
            currency_id_list.append(curr_id);
    }

    this->currency_ids = currency_id_list;

    util_func(); //Now we should call the other procedures.
}

/*
 * Sets sizes of the table and make a request with manager1 which calls the method: replyFinished
 */
void MyClass::util_func(){

    if(this->currency_ids.empty())
       std::cout << "It's empty!" << std::flush;

    int rows = this->currency_names_symbols->length();

    //set width and height of the cells
    for(int i = 0 ; i < 3; i++){
       this->tableWidget->setColumnWidth(i, 200);
    }
    for(int i = 0 ; i < rows; i++){
       this->tableWidget->setRowHeight(i,50);
    }

    QStringList h_label_list = {"USD", "EURO", "GBP"};
    QStringList v_label_list;
    QString formatted;      // a string which will be used in url

    for(auto a: currency_ids){
        v_label_list << a; //add currency_ids to v_label_list (vertical labels of the table)
        formatted += a + ",";
      }

    formatted.truncate(formatted.length()-1); //delete at the end of the ','

    //set labels of the table
    this->tableWidget->setVerticalHeaderLabels(v_label_list);
    this->tableWidget->setHorizontalHeaderLabels(h_label_list);

    //request the data of needed coins (coins that are given in input file)
    this->manager1->get(QNetworkRequest(QUrl("https://api.coingecko.com/api/v3/simple/price?ids=" + formatted + "&vs_currencies=usd,eur,gbp")));
}
