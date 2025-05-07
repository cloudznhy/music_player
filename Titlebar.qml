import QtQuick 2.15
import QtQuick.Layouts 1.0
import FlWindow 1.0
import QtQuick.Controls 2.0

Rectangle{
    id:titlebar
    width: parent.width
    height: 70
    color:"#E0F2F1"
    property string keywords: ""
    property var selectRes:[]
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
        RowLayout{
            width: parent.width-20
            height: parent.height
            anchors.centerIn: parent
            Row{
                id:leftrow
                width: 160
                height: parent.height
                spacing: 10
                //图标
                QCTooTipButton{
                    width: 30
                    height: 25
                    id: mainicon
                    anchors.verticalCenter: parent.verticalCenter
                    source: "qrc:/images/player.svg"
                    iconcolor:"#C7E5E2"
                    color:"#F0FAFA"
                    isHoveredcolor: "#F0FAFA"
                }
                //网文字
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 25
                    text: "music player"
                    color:"#263339"
                }

                // Component.onCompleted: {
                //     width = children[0].width+chiledren[1].contenWidth+spacing
                // }
            }
            Row{
                width: 100
                height: parent.height
                QCTooTipButton{
                    property bool isActive: rightcontent.stepCurrent<=0?false:true
                    width: 23
                    height: width
                    rotation: 90
                    transformOrigin: Item.Center
                    anchors.verticalCenter: parent.verticalCenter
                    source: "qrc:/images/dropDown.svg"
                    isHoveredcolor: "#C7E5E2"
                    color: "#00000000"
                    iconcolor: isActive? "#26A69A":"#F0FAFA"
                    onClicked: {
                        rightcontent.preStep()
                    }
                }
                QCTooTipButton{
                    property bool isActive: rightcontent.stepCurrent>=rightcontent.stepPageCount?false:true
                    width: 23
                    height: width
                    rotation: -90
                    transformOrigin: Item.Center
                    anchors.verticalCenter: parent.verticalCenter
                    source: "qrc:/images/dropDown.svg"
                    isHoveredcolor: "#C7E5E2"
                    color: "#00000000"
                    iconcolor: isActive? "#26A69A":"#F0FAFA"
                    onClicked: {
                        rightcontent.nextStep()
                    }
                }

                TextField{
                    id:selectField
                    width: 130
                    height: 25
                    anchors.verticalCenter: parent.verticalCenter
                    wrapMode: TextEdit.Wrap
                    font.pixelSize: 12
                    placeholderText: "搜索"
                    background: Rectangle {
                               radius: 10
                               color: "#F0FAFA"
                               border.color: "#c0c0c0"
                               border.width: 1
                               implicitWidth: 200
                               implicitHeight: 200
                    }
                    QCTooTipButton{
                        width: 25
                        height: width
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        source: "qrc:/images/select.svg"
                        isHoveredcolor: "#C7E5E2"
                        color: "#00000000"
                        iconcolor: "#26A69A"
                        onClicked: {
                            titlebar.keywords=selectField.text
                            console.log(keywords)

                            var callBack= res =>{
                                //console.log(JSON.stringify(res.data[0]))
                                //console.log(JSON.stringify(res))
                                selectRes=res
                            }
                            musicres.selectMusic({keywords:titlebar.keywords,callBack:callBack})

                            rightcontent.thisqml="pageSelectMusic.qml"
                        }
                    }
                    onAccepted: {
                        titlebar.keywords=selectField.text
                        console.log(keywords)

                        var callBack= res =>{
                            //console.log(JSON.stringify(res.data[0]))
                            //console.log(JSON.stringify(res))
                            selectRes=res
                        }
                        musicres.selectMusic({keywords:titlebar.keywords,callBack:callBack})

                        rightcontent.thisqml="pageSelectMusic.qml"
                    }
                }
            }

            Item{Layout.fillWidth:true}
            Row{
                width: 30
                height: 10
                spacing: 5
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
        }
    }

}
