import QtQuick 2.15
import ThreadManager 1.0
ListView{
    id:favoriteMusicPage
    width: parent.width
    height:parent.height
    property var playListInfo: null
    property int currentIndex: -1 //现在选中的歌曲序号

    clip: true  //超出部分截取
    //从加载项接收数据
    Component.onCompleted: {
        let id=main.id
        let result=ThreadManager.query("select * from favorite where user_id='"+id+"'")
        if(result.length>0){
            //console.log(results[0].id)
            contentModel.append(result)
            let coverImg =result[0].coverImg
            headerItem.coverimg=coverImg.replace("https://", "http://")
        }else{
            console.log("账号或密码错误")
        }
    }
    // Connections{
    //     target:ThreadManager
    //     function onQueryResult(result){
    //         if(result.length>0){
    //             //console.log(results[0].id)
    //             contentModel.append(result)
    //             let coverImg =result[0].coverImg
    //             headerItem.coverimg=coverImg.replace("https://", "http://")
    //         }else{
    //             console.log("账号或密码错误")
    //         }
    //     }
    // }

    function setHeight(children,spacing){
        var h=0
        for(var i=0;i<children.length;i++){
            if(children[i] instanceof Text ){
                h+=children[i].contentHeight
            }else{
                h+=children[i].height
            }
        }
        return h+(children.length-1)*spacing
    }

    header: Item {
        id: header
        width: parent.width-70
        height: children[0].height+30
        anchors.horizontalCenter: parent.horizontalCenter
        property string id: ""
        property string nameText: ""
        property string coverimg: ""
        property string descriptionText: ""
        Column{
            width: parent.width
            height:setHeight(children,spacing)
            anchors.top: parent.top
            anchors.topMargin: 20
            spacing: 10
            Row{
                width: parent.width
                height: 140
                spacing: 20
                //歌单封面
                RoundImage{
                    id:playListcoverImg
                    width: parent.height
                    height: width
                    source: coverimg
                }
                Column{
                    width: parent.width-playListcoverImg.width-parent.spacing
                    anchors.verticalCenter: playListcoverImg.verticalCenter
                    spacing: 10
                    height:setHeight(children,spacing)
                    Text {
                       width: parent.width
                        horizontalAlignment: Text.AlignLeft
                        elide: Text.ElideRight
                        text: "我喜欢的音乐"
                        color: "#458B74"
                        font.pointSize: 10
                    }
                    Text {
                       width: parent.width
                        horizontalAlignment: Text.AlignLeft
                        elide: Text.ElideRight
                        text:nameText
                        color: "#263339"
                        font.pointSize: 15
                    }
                    Text {
                        width: parent.width
                        horizontalAlignment: Text.AlignLeft//文本左对齐
                        elide: Text.ElideRight//省略右边显示不下的内容
                        text: descriptionText
                        color: "#263339"
                        font.pointSize: 10
                    }
                }
            }

            Row{
                width: parent.width
                height: 50
                spacing: 10
                QCTooTipButton{
                    width: parent.height
                    height: width
                    source: "qrc:/images/player.svg"
                    isHoveredcolor: "#43CD80"
                    //color: "#00000000"
                    color:"#43CD80"
                    iconcolor: "white"
                    onEntered: {
                        scale=1.1
                    }
                    onExited: {
                        scale=1
                    }
                    Behavior on scale {
                       ScaleAnimator{
                           duration: 200
                           easing.type: Easing.InOutQuad
                       }
                    }
                }
                QCTooTipButton{
                    width: 30
                    height: width
                    anchors.verticalCenter: parent.verticalCenter
                    source: "qrc:/images/playList.svg"
                    isHoveredcolor: "#C7E5E2"
                    color: "#00000000"
                    iconcolor: "#26A69A"
                }
            }

            Row{
                width: parent.width-50
                height: 30
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    width: parent.width*0.2-55
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignLeft
                    elide: Text.ElideRight
                    text: "序号"
                    color: "#263339"
                    font.pointSize: 10
                }
                Text {
                    width: parent.width*0.3
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignLeft
                    elide: Text.ElideRight
                    text: "歌名"
                    color: "#263339"
                    font.pointSize: 10
                }
                Text {
                    width: parent.width*0.3
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignLeft
                    elide: Text.ElideRight
                    text: "作者"
                    color: "#263339"
                    font.pointSize: 10
                }
                Text {
                    width: parent.width*0.2
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignLeft
                    elide: Text.ElideRight
                    text: "专辑"
                    color: "#263339"
                    font.pointSize: 10
                }
                Text {
                    width: parent.width*0.2
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignLeft
                    elide: Text.ElideRight
                    text: "时长"
                    color: "#263339"
                    font.pointSize: 10
                }
            }
        }
    }

    model: ListModel{
        id:contentModel
    }

    delegate: Rectangle{
        id:contentDelegate
        width: 620
        height: 60
        radius: 10
        property bool ishovered: false
        color: if(favoriteMusicPage.currentIndex===index) return "#C7E5E2"
        else if(ishovered) return "#E0F2F1"
        else return "white"
        onParentChanged: {
            if(parent!=null){
                anchors.horizontalCenter=parent.horizontalCenter
            }
        }
        Row{
            width: parent.width-50
            height: 70
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                width: parent.width*0.2-60
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignLeft
                elide: Text.ElideRight
                text: index+1
                color: "#263339"
                font.pointSize: 10
            }
            Text {
                width: parent.width*0.3
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignLeft
                elide: Text.ElideRight
                text: name
                color: "#263339"
                font.pointSize: 10
            }
            Text {
                width: parent.width*0.3
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignLeft
                elide: Text.ElideRight
                text: artist
                color: "#263339"
                font.pointSize: 10
            }
            Text {
                width: parent.width*0.2+10
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignLeft
                elide: Text.ElideRight
                text: album
                color: "#263339"
                font.pointSize: 10
            }
            Text {
                width: parent.width*0.2
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignLeft
                elide: Text.ElideRight
                text: allTime
                color: "#263339"
                font.pointSize: 10
            }
        }
        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                favoriteMusicPage.currentIndex=index
            }
            onDoubleClicked: {
                var musicInfo={id:music_id,name:name,artist:artist,album:album,coverImg:coverImg.replace("https://", "http://"),url:"",allTime:allTime}
                var getMusicUrlCallBack=res=>{
                    musicInfo.url=res.url          //获取歌曲的url
                    musicres.thisMusicInfo=musicInfo

                    var playList = [];
                    for (var i = 0; i < contentModel.count; i++) {
                            var item = contentModel.get(i);
                            item.coverImg = item.coverImg.replace("https://", "http://"); // 关键修改
                            playList.push(item);
                        }
                    musicres.playList=playList
                    musicres.currentMusicIndex=index

                    musicres.thisMusicInfoChanged()
                    musicPlayer.playPauseMusic()    //播放音乐
                }
                //根据id获取歌曲的res
                musicres.getMusicUrl({id:music_id,callBack:getMusicUrlCallBack})
            }
            onEntered: {
                parent.ishovered=true
            }
            onExited: {
                parent.ishovered=false
            }
        }
    }

}
