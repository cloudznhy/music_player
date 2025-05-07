#ifndef DBMANAGER_H
#define DBMANAGER_H
#include<QSqlDatabase>
#include<QSqlError>
#include<QSqlQuery>
#include<QDebug>
#include <QObject>
#include<QVariant>
#include<QSqlRecord>
#include<QTimer>
class DBManager : public QObject
{
    Q_OBJECT
public:
    explicit DBManager(QObject *parent = nullptr);
    //static DBManager &instance();
    ~DBManager();
public slots:
    void initialaze();
    QVariantList selectQuery(const QString &sql);  //有结果返回的查询
    bool executeQuery(const QString &sql); //只用返回成功与否的增删改查
signals:
    void errorOccurred(const QString &error);   //错误信号
    void opensuccess();
    // void queryResult(const QVariantList &result);  //查询到的结果
    // void operationResult(bool success);    //增删改查操作是否成功
private:
    bool openDataBase();
    QSqlDatabase db;
};

#endif // DBMANAGER_H
