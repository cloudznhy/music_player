import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.5
import FlWindow 1.0
import QtQuick.Layouts 1.0
FramelessWindow{
    id:window
    width:850
    height: 550
    //visible: flase
    color: "white"
    property bool lyricPageVisible: false

    Connections{
        target:rightcontent
        function onThisqmlChanged(){
            leftbar.thisqml=rightcontent.thisqml
        }
    }
    MusicResource{
        id:musicres
    }

    QCMusicPlayer{
        id:musicPlayer
        source: musicres.thisMusicInfo.url
    }

    Column{
        id:mainContent
        visible:!lyricPageVisible
        anchors.fill: parent
        //顶部
        Titlebar{
            id:titlebar
            width: window.width
            height: 60
        }

        //中间部分
        Rectangle{
            width: parent.width
            height:parent.height-bottombar.height-titlebar.height
            Row{
                width: parent.width
                height: parent.height
                Leftbar{
                    id:leftbar
                    width: 150
                    height: parent.height
                    // Binding on thisqml {
                    //     when: rightcontent.thisqml!= ""
                    //     value: rightcontent.thisqml
                    // }
                }
                Rightcontent{
                    id:rightcontent
                    width: parent.width-leftbar.width
                    height: parent.height
                    thisqml: leftbar.thisqml
                    Binding on thisqml {
                        when: leftbar.thisqml!=""
                        value: leftbar.thisqml
                    }
                    //记录初次页面，来回退
                   Component.onCompleted: {
                       let qml=leftbar.thisqml
                       let btnText=leftbar.thisbtntext
                       let func=()=>{
                           leftbar.thisqml=qml
                           leftbar.thisbtntext=btnText
                       }
                       rightcontent.pushStep({name:btnText,callBack:func})
                   }
                }
            }
        }

        //底部
        Bottombar{
            id:bottombar
            height: 60
            width: parent.width
        }

        opacity: 1
        y:0
        Behavior on opacity {
            NumberAnimation {
                duration: 400
            }
        }
        Behavior on y {
            NumberAnimation {
                duration: 400
                easing.type: Easing.OutCubic
            }
        }
    }
    PageMusicLyricDetail{
        id:musicLyricPage
        visible:lyricPageVisible
        opacity: 0
        y:parent.height
        Behavior on opacity {
            NumberAnimation {
                duration: 400
                easing.type: Easing.InOutQuad
            }
        }
        Behavior on y {
            NumberAnimation {
                duration: 400
                easing.type: Easing.OutCubic
            }
        }
        states: [
               State {
                   name: "showLyric"
                   when: lyricPageVisible
                   PropertyChanges {
                       target: mainContent
                       opacity: 0.5
                       y: -50
                   }
                   PropertyChanges {
                       target: musicLyricPage
                       opacity: 1
                       y: 0
                   }
               }
           ]
        transitions: [
                Transition {
                    to: "showLyric"
                    reversible: true
                    ParallelAnimation {
                        NumberAnimation {
                            properties: "opacity,y"
                            duration: 400
                            easing.type: Easing.OutCubic
                        }
                    }
                }
            ]
    }
}
