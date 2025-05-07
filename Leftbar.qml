import QtQuick 2.15
import QtQuick.Controls 2.5
Rectangle{
    id:leftbar
    width: 160
    height: parent.height
    color: "#E0F2F1"

    property var findMusicdata :{
        "headerText":"发现音乐",
        "btndata":[
                    {btnIcon:"qrc:/images/yinle.svg",btnText:"发现音乐",qml:"pagefindmusic.qml",isActive:true},
                    {btnIcon:"qrc:/images/gedan.svg",btnText:"歌单",qml:"Pageplaylist.qml",isActive:true}
                ],"isActive":true
    }

    property var myMusicData: { // 我的音乐数据
        "headerText": "我的音乐",
        "btndata": [
            {btnIcon:"qrc:/images/wodexihuan.svg",btnText:"我喜欢的音乐",isActive:true,qml:"PageFavoriteMusic.qml"},
            {btnIcon:"qrc:/images/wj-wjj.svg",btnText:"文件夹",isActive:true,qml:""},
            {btnIcon:"qrc:/images/lishijilu.svg",btnText:"最近播放",isActive:true,qml:"PageHistory.qml"},
            {btnIcon:"qrc:/images/xiazai.svg",btnText:"下载",isActive:true,qml:""},

            ],
        "isActive": true
    }
    property int btnHeight: 35
    property int fontSize: 10
    property string thisqml:"pagefindmusic.qml"
    property string thisbtntext:"发现音乐"
    Flickable{
        id:leftbarflick
        width: parent.width
        height: parent.height
        contentHeight: height
        anchors.fill: parent
        Column{
            id:leftbarcolumn
            spacing: 22
            ListView{
                width: leftbarflick.width
                height: contentHeight-20
                model:leftbar.findMusicdata.btndata
                spacing:3
                header: Text {
                    width: parent.width
                    height:text === "" ?0: contentHeight +5
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    text:leftbar.findMusicdata.headerText
                    font.pointSize:  leftbar.fontSize-2
                    color: "#696969"
                }
                delegate: findmusicdelegate
            }
            ListView{
                width: leftbarflick.width
                height: contentHeight-20
                model: leftbar.myMusicData.btndata
                spacing:3
                header: Text {
                    width: parent.width
                    height:text === "" ?0: contentHeight +5
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    text: leftbar.myMusicData.headerText
                    font.pointSize: leftbar.fontSize-2
                    color: "#696969"
                }
                delegate: mymusicdelegate
            }
        }
    }
    Component{
        id:findmusicdelegate
        Rectangle{
            id:out
            property bool ishovered:false
            property bool isthisbtn: leftbar.thisbtntext===leftbar.findMusicdata.btndata[index].btnText
            width: leftbarflick.width-15
            height: leftbar.btnHeight
            radius: 50
            color: if(ishovered) return"#C7E5E2"
            else return "#00000000"
            Rectangle{
                width:out.isthisbtn?parent.width:0
                height: parent.height
                color: if(out.isthisbtn)return"#76EEC6"
                else return "#76EEC6"
                radius: parent.radius
                Behavior on width {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.InOutQuad
                    }
                }
            }
            Row{
                width: parent.width
                height: parent.height-10
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: parent.radius/4
                spacing: 10
                Image {
                    id:icon
                    width: 20
                    height: 20
                    anchors.verticalCenter: parent.verticalCenter
                    source: leftbar.findMusicdata.btndata[index].btnIcon
                    sourceSize: Qt.size(32.32)
                }
                Text {
                    text:leftbar.findMusicdata.btndata[index].btnText
                    font.pointSize: leftbar.fontSize
                    font.bold: isthisbtn ? true : false
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#263339"
                }
            }
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    let func=()=>{
                        leftbar.thisqml=leftbar.findMusicdata.btndata[index].qml
                        leftbar.thisbtntext=leftbar.findMusicdata.btndata[index].btnText
                    }
                    func()
                    rightcontent.pushStep({name:leftbar.findMusicdata.btndata[index].btnText,callBack:func})
                }
                onEntered: {
                    out.ishovered=true
                }
                onExited: {
                    out.ishovered=false
                }
            }
        }
    }
    Component{
        id:mymusicdelegate
        Rectangle{
            id:out
            property bool ishovered:false
            property bool isthisbtn: leftbar.thisbtntext===leftbar.myMusicData.btndata[index].btnText
            width: leftbarflick.width-15
            height: leftbar.btnHeight
            radius: 50
            color: if(ishovered) return"#C7E5E2"
            else return "#00000000"
            onParentChanged: {
                if(parent!=null){
                    anchors.horizontalCenter=parent.hohorizontalCenter
                }
            }

            Rectangle{
                width: out.isthisbtn?parent.width:0
                height: parent.height
                color: if (out.isthisbtn)return "#76EEC6"
                else return "#76EEC6"
                radius: parent.radius
                Behavior on width {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.InOutQuad
                    }
                }
            }
            Row{
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: parent.radius/4
                width: parent.width
                spacing: 10
                height: parent.height-10
                Image {
                    width: 20
                    height:width
                    anchors.verticalCenter: parent.verticalCenter
                    source:leftbar.myMusicData.btndata[index].btnIcon
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    font.pointSize: leftbar.fontSize
                    font.bold: isthisbtn ? true : false
                    text: leftbar.myMusicData.btndata[index].btnText
                    color:"#263339"
                }
            }
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    let func=()=>{
                        leftbar.thisqml=leftbar.myMusicData.btndata[index].qml
                        leftbar.thisbtntext=leftbar.myMusicData.btndata[index].btnText
                        // rightcontent.thisqml=""
                    }
                    func()
                    rightcontent.pushStep({name:leftbar.myMusicData.btndata[index].btnText,callBack:func})
                }
                onEntered: {
                    out.ishovered=true
                }
                onExited: {
                    out.ishovered=false
                }
            }
        }
    }
}
