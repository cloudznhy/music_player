#include "threadmanager.h"

ThreadManager::ThreadManager(QObject *parent):QObject(parent)
{
    // dbmanager=new DBManager;
    // dbmanager->moveToThread(&db_workThread);
    // //connect(this,&ThreadManager::doquery,dbmanager,&DBManager::selectQuery);
    // //connect(this,&ThreadManager::doexecute,dbmanager,&DBManager::executeQuery);
    // //connect(dbmanager,&DBManager::queryResult,this,&ThreadManager::queryResult);
    // //connect(dbmanager,&DBManager::operationResult,this,&ThreadManager::operationResult);
    // connect(&db_workThread,&QThread::started,dbmanager,&DBManager::initialaze);
    // connect(dbmanager,&DBManager::errorOccurred,this,&ThreadManager::errorMessage);
    // connect(&db_workThread,&QThread::finished,dbmanager,&QObject::deleteLater);
    // connect(dbmanager,&DBManager::opensuccess,this,[this](){
    //     m_databaseReady=true;
    //     emit isDatabaseReady();
    // });
    // db_workThread.start();

}

ThreadManager &ThreadManager::instance()
{
    static ThreadManager instance;
    return instance;
}

ThreadManager::~ThreadManager()
{
    db_workThread.quit();
    db_workThread.wait();
}

QVariantList ThreadManager::query(const QString &sql)
{
    //emit doquery(sql);
    return dbmanager->selectQuery(sql);
}

bool ThreadManager::execute(const QString &sql)
{
    return dbmanager->executeQuery(sql);
}

bool ThreadManager::isDatabaseReady()
{
    return m_databaseReady;
}

void ThreadManager::initialize()
{
    dbmanager=new DBManager;
    dbmanager->moveToThread(&db_workThread);
    //connect(this,&ThreadManager::doquery,dbmanager,&DBManager::selectQuery);
    //connect(this,&ThreadManager::doexecute,dbmanager,&DBManager::executeQuery);
    //connect(dbmanager,&DBManager::queryResult,this,&ThreadManager::queryResult);
    //connect(dbmanager,&DBManager::operationResult,this,&ThreadManager::operationResult);
    connect(&db_workThread,&QThread::started,dbmanager,&DBManager::initialaze);
    connect(dbmanager,&DBManager::errorOccurred,this,&ThreadManager::errorMessage);
    connect(&db_workThread,&QThread::finished,dbmanager,&QObject::deleteLater);
    connect(dbmanager,&DBManager::opensuccess,this,[this](){
        m_databaseReady=true;
        emit isDatabaseReady();
    });
    db_workThread.start();
}
