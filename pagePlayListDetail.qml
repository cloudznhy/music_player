import QtQuick 2.15
import ThreadManager 1.0
ListView{
    id:musicPlayListDetail
    width: parent.width
    height:parent.height
    property var playListInfo: null
    property int currentIndex: -1 //现在选中的歌曲序号
    property var likedMusicIds: []
    clip: true  //超出部分截取
    //从加载项接收数据
    onPlayListInfoChanged: {
        headerItem.id = playListInfo.id
        headerItem.nameText = playListInfo.name
        headerItem.coverimg = playListInfo.coverImg
        headerItem.descriptionText = playListInfo.description

        var musicDetailCallBack =res =>{
            contentModel.clear()
            for(var i=0;i<res.length;i++){
                var item=res[i]
                item.isliked=likedMusicIds.indexOf(String(item.id))!== -1
                contentModel.append(item)
            }
            //console.log(JSON.stringify(res[0]))
        }
        //获取歌单信息并根据其中的trackIds获取歌曲信息
        var musicPlayListDetailCallBack =res=>{
            var ids=res.trackIds.join(',')
            //console.log(JSON.stringify(res))
            musicres.getMusicDetail({ids:ids,callBack:musicDetailCallBack})
        }

        musicres.getMusicPlayListDetail({id:playListInfo.id,callBack:musicPlayListDetailCallBack})
    }
    Component.onCompleted: {
        if(ThreadManager.isDatabaseReady){
            var favoriteResults= ThreadManager.query("select music_id from favorite where user_id = '"+main.id+"'")//查找当前用户喜欢的歌曲id
            likedMusicIds=favoriteResults.map(result=>String(result.music_id))
            console.log(JSON.stringify(likedMusicIds))
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
                        text: "歌单"
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
        color: if(musicPlayListDetail.currentIndex===index) return "#C7E5E2"
        else if(ishovered) return "#E0F2F1"
        else return "white"
        onParentChanged: {
            if(parent!=null){
                anchors.horizontalCenter=parent.horizontalCenter
            }
        }
        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                musicPlayListDetail.currentIndex=index
            }
            onDoubleClicked: {
                var musicInfo={id:id,name:name,artist:artist,album:album,coverImg:coverImg.replace("https://", "http://"),url:"",allTime:allTime}
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
                musicres.getMusicUrl({id:id,callBack:getMusicUrlCallBack})

                let userid=main.id
                try{
                    if(ThreadManager.isDatabaseReady()){
                        var deleteSql = "DELETE FROM history WHERE user_id = " + userid + " AND music_id = " + id;//删除旧的记录，并把播放记录变为最新
                        var deleteSuccess = ThreadManager.execute(deleteSql);
                        var success=ThreadManager.execute("insert into history values ('" + userid+ "','" + id + "', '" + name + "','" + artist + "','" + album + "','" + coverImg + "','" + allTime + "')")
                        if(success){
                            console.log("添加成功")
                        }else{
                            console.log("添加失败")
                        }
                    }
                }catch (error) {
                    console.error("数据库操作错误:", error);
                }
            }
            onEntered: {
                parent.ishovered=true
            }
            onExited: {
                parent.ishovered=false
            }
            Row{
                width: parent.width-50
                height: 70
                anchors.horizontalCenter: parent.horizontalCenter
                    Row{
                        width: 50
                        height: parent.height
                        anchors.verticalCenter: parent.verticalCenter
                        Text {
                            width: 10
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                            elide: Text.ElideRight
                            text: index+1
                            color: "#263339"
                            font.pointSize: 10
                        }
                        QCTooTipButton{
                            width: 30
                            height: width
                            //property bool isliked: false
                            anchors.verticalCenter: parent.verticalCenter
                            source:model.isliked ? "qrc:/images/myFavorite2.svg":"qrc:/images/myFavorite.svg"
                            isHoveredcolor: "#C7E5E2"
                            color: "#00000000"
                            iconcolor: "#26A69A"
                            onClicked: {
                                if(model.isliked){
                                    isliked=false
                                    var success=ThreadManager.execute("delete from favorite where user_id='"+main.id+"' and music_id='"+id+"'")
                                    if(success){
                                        console.log("取消喜欢成功")
                                        var index=musicPlayListDetail.likedMusicIds.indexOf(id)
                                        if(index!==-1) musicPlayListDetail.likedMusicIds.splice(index,1)
                                    }else{
                                        console.log("取消喜欢失败")
                                    }
                                }else{
                                    model.isliked=true
                                    let userid=main.id
                                    if(ThreadManager.isDatabaseReady){
                                        var success=ThreadManager.execute("insert into favorite values ('" + userid+ "','" + id + "', '" + name + "','" + artist + "','" + album + "','" + coverImg + "','" + allTime + "')")
                                        if(success){
                                            console.log("添加成功")
                                            musicPlayListDetail.likedMusicIds.push(id)
                                        }else{
                                            console.log("添加失败")
                                        }
                                    }
                                }
                            }
                        }
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

        }
    }

}
