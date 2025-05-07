#include "dbmanager.h"

DBManager::DBManager(QObject *parent): QObject{parent}
{
}

// DBManager &DBManager::instance()
// {
//     static DBManager instance;
//     return instance;
// }

DBManager::~DBManager()
{
    if(db.isOpen()){
        db.close();
    }
    QTimer::singleShot(0, []() {
        QSqlDatabase::removeDatabase("musicplayer_connection");
    });
}

void DBManager::initialaze()
{
    db=QSqlDatabase::addDatabase("QMYSQL","musicplayer_connection");
    db.setHostName("localhost");
    db.setUserName("root");
    db.setPassword("qwertyuiop957");
    db.setDatabaseName("musicplayer");
    openDataBase();
}

QVariantList DBManager::selectQuery(const QString &sql)
{
    QVariantList results;
    QSqlQuery query(db);
    if(!query.exec(sql)){
        emit errorOccurred(db.lastError().text());
    }
    while (query.next()) {
        QVariantMap row;
        QSqlRecord record=query.record();
        for (int i = 0; i < record.count(); ++i) {
            row.insert(record.fieldName(i),query.value(i));
        }
        results.append(row);
    }
    return results;
    //emit queryResult(results);
}

bool DBManager::executeQuery(const QString &sql)
{
    QSqlQuery query(db);
    bool success= query.exec(sql);
    if(!success){
        emit errorOccurred(db.lastError().text());
    }
    return success;
    //emit operationResult(success);
}

bool DBManager::openDataBase()
{
    if (!db.open()) {
        emit errorOccurred(db.lastError().text());
        qDebug() << "Failed to open database:" << db.lastError().text();
        return false;
    }
    emit opensuccess();
    qDebug() << "Database opened successfully";
    return true;

}
