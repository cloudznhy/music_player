import QtQuick 2.15
import ThreadManager 1.0
Flickable{
    width: parent.width-5
    height: parent.height-5
    id:selectMusicFlick
    anchors.fill: parent
    property int fontSize: 10
    property var likedMusicIds: []
    contentHeight: selectmusiccontent.height
    contentWidth: parent.width
    clip: true
    Item{
        id:selectmusiccontent
        width:parent.width*0.9
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 30
        property int fontSize: 11
        property int current: -1  //当前选中的歌曲
        height:content.height

        // Component.onCompleted: {
        //    setContentModel()
        // }

        Connections{
            target: titlebar
            function onSelectResChanged(){
                if(ThreadManager.isDatabaseReady){
                    var favoriteResults= ThreadManager.query("select music_id from favorite where user_id = '"+main.id+"'")//查找当前用户喜欢的歌曲id
                    likedMusicIds=favoriteResults.map(result=>String(result.music_id))
                    //console.log(JSON.stringify(likedMusicIds))
                }
                selectmusiccontent.setContentModel()
            }
        }

        function setContentModel()
        {
            content.height=0
            contentModel.clear()
            for(var i=0;i<titlebar.selectRes.length;i++){
                var item=titlebar.selectRes[i]
                item.isliked=likedMusicIds.indexOf(String(item.id))!== -1
                contentModel.append(item)
            }
            content.height=titlebar.selectRes.length*80-100
        }
        Rectangle{
            anchors.horizontalCenter: parent.horizontalCenter
            id:content
            radius: 10
            property bool ishovered: false
            color: "white"
            width: parent.width
            Column{
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10
              Repeater{
                  model:ListModel{
                      id:contentModel
                  }
                  delegate: contentdelegate
              }
            }
            Component{
                id:contentdelegate
                Rectangle{
                    property bool ishovered: false
                    width: content.width-20
                    height: 65    //每首歌占的高度和宽度
                    color: if(selectmusiccontent.current===index) return "#C7E5E2"
                    else if(ishovered) return "#E0F2F1"
                    else return "white"
                    radius:10
                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            selectmusiccontent.current=index
                        }
                        onDoubleClicked: {
                            var musicInfo={id:id,name:name,artist:artist,album:album,coverImg:coverImg.replace("https://", "http://"),url:"",allTime:allTime}
                            var getMusicUrlCallBack=res=>{
                                musicInfo.url=res.url       //获取歌曲的url
                                musicres.thisMusicInfo=musicInfo
                                musicres.thisMusicInfoChanged()

                                var playList = [];
                                        for (var i = 0; i < contentModel.count; i++) {
                                            playList.push(contentModel.get(i));
                                        }
                                musicres.playList=playList
                                musicres.currentMusicIndex=index

                                musicPlayer.playPauseMusic()  //播放音乐
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
                            spacing: 10
                            width:parent.width
                            height: parent.height
                            anchors.verticalCenter: parent.verticalCenter
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
                                                    var index=selectMusicFlick.likedMusicIds.indexOf(id)
                                                    if(index!==-1) selectMusicFlick.likedMusicIds.splice(index,1)
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
                                                        selectMusicFlick.likedMusicIds.push(id)
                                                    }else{
                                                        console.log("添加失败")
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            RoundImage{
                                width: parent.height-5
                                height: width
                                anchors.verticalCenter: parent.verticalCenter
                                source: coverImg.replace("https://", "http://")
                                radius: 8
                            }
                            Text {
                                width: parent.width*0.3-55
                                anchors.verticalCenter: parent.verticalCenter
                                horizontalAlignment: Text.AlignLeft
                                elide: Text.ElideRight
                                text: name
                                color: "#263339"
                                font.pointSize: 10
                            }
                            Text {
                                width: parent.width*0.2
                                anchors.verticalCenter: parent.verticalCenter
                                horizontalAlignment: Text.AlignLeft
                                elide: Text.ElideRight
                                text: artist
                                color: "#263339"
                                font.pointSize: 10
                            }
                            Text {
                                width: parent.width*0.2
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
        }
    }
}
