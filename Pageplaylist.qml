import QtQuick 2.15
import QtGraphicalEffects 1.0

Flickable {
    width: parent.width - 5
    height: parent.height
    id: playlistcontent
    clip: true
    anchors.fill: parent
    contentHeight: header.height + content.height + 90
    contentWidth: parent.width
    property int fontSize: 10
    property var headerdata: [
        {name:"ACG"},
        {name:"电子"},
        {name:"流行"},
        {name:"欧美"},
        {name:"古风"}
    ]
    property var headerInfoData: []
    property var contentItemSourceSize: Qt.size(minContentItemWidth, minContentItemHeight)
    property double minContentItemWidth: 185
    property double minContentItemHeight: contentItemWidth * 1.2
    property double contentItemWidth: minContentItemWidth
    property double contentItemHeight: contentItemWidth * 1.2
    //现在选择的标签的序号
    property int currentheader: 0

    Component.onCompleted: {
        setContentModel(headerdata[currentheader].name)
        // 初始化完成后立即调整内容项大小
        setContentItemSize()
    }

    onCurrentheaderChanged: {
        setContentModel(headerdata[currentheader].name)
    }

    function setContentModel(cat) {
        content.height = 0
        var musicPlayListCallBack = res => {
            var rows = Math.ceil(res.data.length / content.columns)
            contentModel.clear()
            contentModel.append(res.data)
            content.height = rows * contentItemHeight + rows * content.spacing
            //console.log("musicPlayListCallBack:" + JSON.stringify(res.data[0]))
        }
        var headerInfoCallBack = res => {
            headerInfoData = res.data.slice(0, res.data.length)
            headerbackground_1.source = headerInfoData[1].coverImg
            headerinfo.nameText = headerInfoData[1].name
            headerinfo.descripionText = headerInfoData[1].description
            //console.log("headerInfoCallBack:" + JSON.stringify(res.data[0]))
        }
        musicres.getMusicPlayList({cat: cat, callBack: musicPlayListCallBack})
        musicres.getHeaderInfo({cat: cat, callBack: headerInfoCallBack})
    }

    //根据页面大小调整展示内容
    function setContentItemSize() {
        var w=content.width
        var columns=content.columns

        while(true){
            if(w>=(columns+1)*minContentItemWidth+columns*content.spacing){
                columns+=1
            }else if(w<columns*minContentItemWidth+(columns-1)*content.spacing){
                columns-=1
            }else break
        }

        content.columns=columns
        content.rows=Math.ceil(contentModel.count / columns)
        contentItemWidth=w / columns-((columns-1)*content.spacing) / columns
        content.height=content.rows*contentItemHeight+content.rows*content.spacing

        // if (content.width <= 0) return;

        //     var availableWidth = content.width;
        //     var spacing = content.spacing;
        //     var minItemWidth = minContentItemWidth;

        //     // 计算最大可能的列数
        //     var maxColumns = Math.floor((availableWidth + spacing) / (minItemWidth + spacing));
        //     maxColumns = Math.max(1, maxColumns);

        //     content.columns = maxColumns;
        //     contentItemWidth = (availableWidth - (maxColumns - 1) * spacing) / maxColumns;
        //     contentItemHeight = contentItemWidth * 1.2;

        //     var rows = Math.ceil(contentModel.count / maxColumns);
        //     content.height = rows * (contentItemHeight + spacing) - spacing;

        //console.log("setContentItemSize called, new columns:", columns, "new item size:", contentItemWidth, contentItemHeight)
    }

    Column {
        id: header
        spacing: 20
        width: parent.width * 0.85
        height: headerbackground.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 20

        Item {
            id: headerbackground
            width: parent.width
            height: 130
            anchors.horizontalCenter: parent.horizontalCenter
            //模糊的图片
            RoundImage {
                id: headerbackground_1
                anchors.fill: parent
                source: ""
                smooth: true // 启用平滑处理
                antialiasing: true
            }
            //右边的主图片
            RoundImage {
                id: headerbackground_2
                anchors.fill: parent
                z: headerbackground_1.z + 1
                source: headerbackground_1.source
                smooth: true // 启用平滑处理
                antialiasing: true
            }
            FastBlur { //边缘淡发光
                source: headerbackground_1
                anchors.fill: parent
                transparentBorder: true
                radius: 30
            }
            FastBlur { //模糊
                source: headerbackground_1
                anchors.fill: parent
                radius: 100
                z: headerbackground_2.z + 1
                RectangularGlow {
                    anchors.fill: parent
                    z: headerbackground_2.z + 1
                    glowRadius: 16 // 光晕半径
                    spread: 0.2 // 扩散范围
                    color: "#2F000000" // 半透明黑色
                }
            }

            Item {
                id: headerinfo
                property string nameText: ""
                property string descripionText: ""
                width: parent.width - 30
                height: parent.height - 30
                z: headerbackground_2.z + 1
                anchors.centerIn: parent
                RoundImage {
                    id: headerinfocover
                    source: headerbackground_2.source
                    width: parent.height
                    height: width
                    radius: 10
                    anchors.verticalCenter: parent.verticalCenter
                }
                Column {
                    width: parent.width - headerinfocover.width - anchors.leftMargin
                    height: parent.height
                    anchors.left: headerinfocover.right
                    anchors.leftMargin: 20
                    anchors.verticalCenter: headerinfocover.verticalCenter
                    Text {
                        width: parent.width
                        height: contentHeight
                        text: headerinfo.nameText
                        elide: Text.ElideRight
                        wrapMode: Text.Wrap
                        color: "white"
                        font.pointSize: playlistcontent.fontSize
                    }
                    Text {
                        width: parent.width
                        height: 80 /*if(parent.height-parent.children[0].height-contentHeight>0)return contentHeight
                                    else return parent.height-parent.children[0].height*/
                        text: headerinfo.descripionText
                        elide: Text.ElideRight
                        wrapMode: Text.Wrap
                        color: "white"
                        font.pointSize: playlistcontent.fontSize - 2
                    }
                }
            }
        }

        Item {
            id: selectbar
            width: parent.width
            anchors.top: headerbackground.bottom
            anchors.topMargin: 25
            height: children[0].contentHeight
            Rectangle {
                id: leftbar
                width: children[0].contentWidth + 35
                height: children[0].contentHeight + 20
                radius: width / 2
                color: "#F0FAFA"
                border.color: "#263339"
                Text {
                    id: leftbartext
                    text: "ACG"
                    font.pointSize: playlistcontent.fontSize
                    color: "#263339"
                    anchors.centerIn: parent
                }
            }
            Row {
                anchors.right: selectbar.right
                Repeater {
                    model: playlistcontent.headerdata
                    delegate: Rectangle {
                        property bool ishovered: false
                        width: children[0].contentWidth + 30
                        height: children[0].contentHeight + 20
                        color: ishovered ? "#E0F2F1" : (selectbar.currentheader === index ? "#E0F2F1" : "#00000000")
                        radius: 20
                        Text {
                            text: playlistcontent.headerdata[index].name
                            font.pointSize: playlistcontent.fontSize - 1
                            color: "#263339"
                            font.bold: currentheader === index
                            anchors.centerIn: parent
                        }
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                currentheader = index
                                leftbartext.text = playlistcontent.headerdata[index].name
                            }
                            onEntered: {
                                parent.ishovered = true
                            }
                            onExited: {
                                parent.ishovered = false
                            }
                        }
                    }
                }
            }
        }
    }

    Grid {
        anchors.top: header.bottom
        anchors.topMargin: 60
        anchors.horizontalCenter: parent.horizontalCenter
        id: content
        width: parent.width * 0.85
        spacing: 20
        columns: 3
        onWidthChanged: {
            if (width > 0) {
                setContentItemSize()
            }
            //console.log("content width changed to", width)
        }
        Repeater {
            model: ListModel {
                id: contentModel
            }
            delegate: Playlistlabel {
                width: contentItemWidth
                height: contentItemHeight
                button.source: "qrc:/images/player.svg"
                button.iconcolor: "white"
                button.color: "#E0F2F1"
                button.isHoveredcolor: "#C7E5E2"
                normalcolor: "white"
                hoveredcolor: "#E0F2F1"
                imgSourceSize: contentItemSourceSize
                imgsource: coverImg+"?thumbnail="+240+"y"+240
                text: name
                onClicked: {
                    let rc=rightcontent
                    let lb=leftbar
                    let playlistinfo=({id:id,name:name,description:description,coverImg:coverImg})
                    let func=()=>{
                        rc.thisqml="pagePlayListDetail.qml"
                        rc.loadItem.playListInfo=playlistinfo
                    }
                    func()
                    rightcontent.pushStep({name:name,callBack:func})
                    //console.log(leftbar.thisbtntext+"标签点击了"+rightcontent.thisqml)
                }
                onBtnclicked: {
                    //console.log("按钮点击了")
                }
            }
        }

    }
}
