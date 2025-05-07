import QtQuick 2.15
import ThreadManager 1.0
ListView{
    id:historyPage
    width: parent.width
    height:parent.height
    anchors.top: parent.top
    anchors.topMargin: 10
    property var playListInfo: null
    property int currentIndex: -1 //现在选中的歌曲序号

    clip: true  //超出部分截取
    //从加载项接收数据
    Component.onCompleted: {
        let id=main.id
        contentModel.clear()
        var result=ThreadManager.query("select * from history where user_id='"+id+"'")
        if(result.length>0){
            for(var i=result.length;i>=0;i--){
                var item=result[i]
                contentModel.append(item)
            }

            //console.log(results[0].id)
            //contentModel.append(item)
        }else{
            console.log("获取历史记录失败")
        }
    }

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

    model: ListModel{
        id:contentModel
    }

    delegate: Rectangle{
        id:contentDelegate
        width: 620
        height: 60
        radius: 10
        property bool ishovered: false
        color: if(historyPage.currentIndex===index) return "#C7E5E2"
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
                historyPage.currentIndex=index
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

