#ifndef THREADMANAGER_H
#define THREADMANAGER_H

#include <QObject>
#include<QThread>
#include"dbmanager.h"
class ThreadManager : public QObject
{
    Q_OBJECT
public:
    explicit ThreadManager(QObject *parent = nullptr);
    static ThreadManager&instance();
    ~ThreadManager();
    Q_INVOKABLE QVariantList query(const QString &sql);
    Q_INVOKABLE bool execute(const QString &sql);
    Q_INVOKABLE bool isDatabaseReady();
    Q_INVOKABLE void initialize();

signals:
    // void operationResult(bool success); //操作结果（是否成功）
    // void queryResult(const QVariantList&data);//查询到的数据
    void errorMessage(const QString &erroe);
    // QVariantList doquery(const QString &sql);
    // void doexecute(const QString &sql);
private:
    QThread db_workThread;
    DBManager*dbmanager;
    bool m_databaseReady=false;
};

#endif // THREADMANAGER_H
