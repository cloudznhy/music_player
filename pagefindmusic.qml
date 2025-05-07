import QtQuick 2.15
import QtQuick.Controls 2.5
import ThreadManager 1.0
Flickable{
    width: parent.width-5
    height: parent.height-5
    id:findmusicflick
    anchors.fill: parent
    property int fontSize: 10
    contentHeight: newmusicheader.height+newmusiccontent.height
    contentWidth: parent.width
    clip: true
    Rectangle{
        id:newmusicheader
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 10
        width: 70
        height: 30
        radius: 18
        color: "#C7E5E2"
        Text {
            anchors.centerIn: parent
            text: "最新音乐"
            color:"#263339"
            font.pointSize: 11
            font.bold: true
        }
    }
    Item{
        id:newmusiccontent
        width:parent.width*0.9
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: newmusicheader.bottom
        anchors.topMargin: 20
        property int fontSize: 11
        property int headercurrent: 0 //是否为当前头部选项
        property int current: -1  //当前选中的歌曲
        property var headerdata: [{name:"全部",type:"0"},
        {name:"华语",type:"7"},
        {name:"欧美",type:"96"},
        {name:"韩国",type:"16"},
        {name:"日本",type:"8"}
        ]
        height: header.height+content.height

        onHeadercurrentChanged: {
            setContentModel()
        }

        Component.onCompleted: {
           setContentModel()
        }

        function setContentModel()
        {
            content.height=0
            contentModel.clear()
            var callBack= res =>{
                console.log(JSON.stringify(res.data[0]))
                contentModel.append(res.data)
                content.height=res.data.length*80-460
            }

            musicres.getNewMusic({type:headerdata[headercurrent].type,callBack})
        }

        Row{
            id:header
            spacing: 10
            width: parent.width
            height: 20
            Repeater{
                model: ListModel{}
                delegate:headerdelegate
                Component.onCompleted: {
                    model.append(newmusiccontent.headerdata)
                }
            }
            Component{
                id:headerdelegate

                Text {
                    property bool ishovered: false
                    text: name
                    color: "#C3C3C3"
                    font.bold:newmusiccontent.current===index||ishovered
                    font.pointSize: 10
                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            newmusiccontent.headercurrent=index
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
        }
        Rectangle{
            anchors.top: header.bottom
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
                    color: if(newmusiccontent.current===index) return "#C7E5E2"
                    else if(ishovered) return "#E0F2F1"
                    else return "white"
                    radius:10
                    Row{
                        spacing: 10
                        width:parent.width
                        height: parent.height
                        anchors.verticalCenter: parent.verticalCenter
                        Text {
                            width: parent.width*0.1-45
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight//省略过长文本
                            text: index+1
                            color: "#263339"
                            font.pointSize: 10
                        }
                        RoundImage{
                            width: parent.height-5
                            height: width
                            anchors.verticalCenter: parent.verticalCenter
                            source: coverImg+"?param="+width+"y"+height
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

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            newmusiccontent.current=index
                        }
                        onDoubleClicked: {
                            var musicInfo={id:id,name:name,artist:artist,album:album,coverImg:coverImg,url:"",allTime:allTime}
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
                            try {
                                var isReady = (typeof ThreadManager.isDatabaseReady === "function") ? ThreadManager.isDatabaseReady() : ThreadManager.isDatabaseReady;
                                console.log("数据库准备状态:", isReady);
                                if (isReady) {
                                    // 数据清理
                                    userid = parseInt(userid) || 0;
                                    id = parseInt(id) || 0;
                                    name = (name || "未知歌曲").replace(/'/g, "''");
                                    artist = (artist || "未知艺术家").replace(/'/g, "''");
                                    album = (album || "未知专辑").replace(/'/g, "''");
                                    coverImg = (coverImg || "").replace(/'/g, "''").replace("https://", "http://");
                                    allTime = allTime || "00:00";
                                    var deleteSql = "DELETE FROM history WHERE user_id = " + userid + " AND music_id = " + id;
                                    var deleteSuccess = ThreadManager.execute(deleteSql);
                                    var sql = "INSERT INTO history VALUES (" + userid + "," + id + ", '" + name + "','" + artist + "','" + album + "','" + coverImg + "','" + allTime + "')";
                                    console.log("执行的 SQL:", sql);
                                    var success = ThreadManager.execute(sql);
                                    console.log("插入结果:", success);
                                    if (success) {
                                        console.log("添加成功");
                                    } else {
                                        console.log("添加失败");
                                        // 检查最后错误（如果 ThreadManager 提供）
                                        if (ThreadManager.lastError) {
                                            console.log("数据库错误:", ThreadManager.lastError());
                                        }
                                    }
                                } else {
                                    console.log("数据库未准备好");
                                }
                            } catch (error) {
                                console.error("数据库操作错误:", error.message);
                            }
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
        }
    }
}
