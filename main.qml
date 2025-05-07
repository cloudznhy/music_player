import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.5
import FlWindow 1.0
import QtQuick.Layouts 1.0
import ThreadManager 1.0
Item{
    id:main
    width:300
    height: 300
    visible: true
    property int id: 0
    property bool loginPageVisible: true
    property bool registerPageVisible: false
    property bool mainPageVisible: false
    Component.onCompleted: {
        ThreadManager.initialize()
    }

    PageLogin{
        id:loginpage
        visible: loginPageVisible
        onLoginSuccess: {
            loginPageVisible=false
            mainPageVisible=true
            id=u_id
            console.log(id)
            //console.log("Stack depth after replace:", stackview.depth)
        }
        onGoRegister: {
            loginPageVisible=false
            registerPageVisible=true
        }
    }
    PageRegister{
        visible: registerPageVisible
              onRegisterSuccess: {
                  loginPageVisible=true
                  registerPageVisible=false
              }
              onGoLogin: {
                  loginPageVisible=true
                  registerPageVisible=false
              }
          }
    PageMain{
        visible:mainPageVisible
    }
}
