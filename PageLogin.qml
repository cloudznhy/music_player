import QtQuick 2.15
import QtQuick.Controls 2.5
import FlWindow 1.0
import ThreadManager 1.0
FramelessWindow {
    id:window
    width:200
    height: 350
    visible: true
    property string account: ""
    property string password:""
    property int u_id: 0
    signal loginSuccess(string account)
    signal goRegister()
    color: "#F0FAFA"
    MouseArea {
        property var click_pos:Qt.point(0,0)
        anchors.fill:parent
        onPositionChanged: function(mouse){
            if(!pressed||window.mouse_pos!==FramelessWindow.NORMAL) return
            if(!window.startSystemMove())//使用系统自带的拖拽逻辑
            {
                var offset=Qt.point(mouseX-click_pos.x,mouseY-click_pos.y)
                window.x+=offset.x
                window.y+=offset.y
            }
        }
        onPressedChanged: function(mouse){
            click_pos=Qt.point(mouseX,mouseY)
        }
        onDoubleClicked: {

            if(window.visibility===FramelessWindow.Maximized)
                window.showNormal()
            else{
                window.showMaximized()
            }

        }
        Row{
            id:iconrow
            width:60
            height: 10
            spacing: 5
            anchors.right: parent.right
            anchors.rightMargin: 10
            Rectangle{
                id:minimizedbtn
                property bool isHovered: false
                width: 20
                height: width
                radius: 100
                color: if(isHovered)return "#C7E5E2"
                       else "#00000000"
                Image {
                    width: 20
                    height: width
                    source: "/images/minimize.svg"
                }
                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        window.showMinimized()
                    }
                    onEntered: {
                        minimizedbtn.isHovered=true
                    }
                    onExited: {
                        minimizedbtn.isHovered=false
                    }
                }
            }
            Rectangle{
                id:minmaxbtn
                property bool isHovered: false
                width: 20
                height: width
                radius: 100
                color: if(isHovered)return "#C7E5E2"
                       else "#00000000"
                Image {
                    width: 20
                    height: width
                    source: "/images/fangda.svg"
                }
                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        if(window.visibility===FramelessWindow.Maximized)
                            window.showNormal()
                        else
                            window.showMaximized()
                    }
                    onEntered: {
                        minmaxbtn.isHovered=true
                    }
                    onExited: {
                        minmaxbtn.isHovered=false
                    }
                }
            }
            Rectangle{
                id:quitbtn
                property bool isHovered: false
                width: 20
                height: width
                radius: 100
                color: if(isHovered)return "#C7E5E2"
                       else "#00000000"
                Image {
                    width: 20
                    height: width
                    source: "/images/close.svg"
                }
                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        Qt.quit()
                    }
                    onEntered: {
                        quitbtn.isHovered=true
                    }
                    onExited: {
                        quitbtn.isHovered=false
                    }
                }
            }
        }
        Column{
            id:column
            anchors.top: parent.top
            anchors.topMargin: 30
            anchors.left: parent.left
            anchors.leftMargin: 5
            width: parent.width
            height: 150
            spacing: 5
            Text {
                text: "账号"
                font.pointSize: 14
            }
            TextField{
                id:usernameTextField
                width: 160
                height: 40
                //anchors.verticalCenter: parent.verticalCenter
                wrapMode: TextEdit.Wrap
                font.pixelSize: 12
                placeholderText: "账号"
                background: Rectangle {
                    radius: 10
                    color: "#F0FAFA"
                    border.color: "#c0c0c0"
                    border.width: 1
                    implicitWidth: 200
                    implicitHeight: 200
                }
            }
            Text {
                text: "密码"
                font.pointSize: 14
            }
            TextField{
                id:passwordTextField
                width: 160
                height: 40
                //anchors.verticalCenter: parent.verticalCenter
                wrapMode: TextEdit.Wrap
                font.pixelSize: 12
                placeholderText: "密码"
                background: Rectangle {
                    radius: 10
                    color: "#F0FAFA"
                    border.color: "#c0c0c0"
                    border.width: 1
                    implicitWidth: 200
                    implicitHeight: 200
                }
            }
        }

        QCTooTipButton{
            anchors.top: column.bottom
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 5
            id:returnIcon
            width: 45
            height: width
            source: "qrc:/images/login.svg"
            isHoveredcolor: "#C7E5E2"
            color: "#00000000"
            iconcolor: "#26A69A"
            onClicked: {
                account=usernameTextField.text
                password=passwordTextField.text
                if(ThreadManager.isDatabaseReady()){
                    var results= ThreadManager.query("select*from user where account = '"+account+"'and password='"+password+"'")
                    if(results.length>0){
                        //console.log(results[0].id)
                        u_id=results[0].id
                        loginSuccess(u_id)
                    }else{
                        console.log("账号或密码错误")
                    }
                }
            }
        }
        QCTooTipButton{
            anchors.top: column.bottom
            anchors.topMargin: 20
            anchors.right: parent.right
            anchors.rightMargin: 5
            id:confirmIcon
            width: 45
            height: width
            //anchors.verticalCenter: parent.verticalCenter
            source:"qrc:/images/register.svg"
            isHoveredcolor: "#C7E5E2"
            color: "#00000000"
            iconcolor: "#26A69A"
            onClicked: {
                onClicked: {
                    goRegister()
                }
            }
        }

    }
}
