import QtQuick 2.15
import FlWindow 1.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.15

Item {
    id:musicLyricPage
    anchors.fill: parent
    width: parent.width
    height: parent.height
    BackGroundManager{

    }

    Item {
        id: header
        width: parent.width
        height: 40
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
                width: 30
                height: 10
                spacing: 5
                anchors.left: parent.left
                anchors.leftMargin: 3
                Rectangle{
                    id:foldbtn
                    property bool isHovered: false
                    width: 25
                    height: width
                    radius: 100
                    color: if(isHovered)return "2FFFFFFF"
                           else "#00000000"
                    QCImage {
                        width: 20
                        height: width
                        anchors.centerIn: parent
                        source: "qrc:/images/fold.svg"
                        color: "white"
                    }
                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            //window.showMinimized()
                           window.lyricPageVisible=false
                            hoverEnabled: true
                        }
                        onEntered: {
                            foldbtn.isHovered=true
                        }
                        onExited: {
                            foldbtn.isHovered=false
                        }
                    }
                }
                Rectangle{
                    id:minimizedbtn
                    property bool isHovered: false
                    width: 25
                    height: width
                    radius: 100
                    color: if(isHovered)return "2FFFFFFF"
                           else "#00000000"
                    QCImage {
                        width: 20
                        height: width
                        anchors.centerIn: parent
                        source: "/images/minimize.svg"
                        color: "white"
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
                    width: 25
                    height: width
                    radius: 100
                    color: if(isHovered)return "2FFFFFFF"
                           else "#00000000"
                    QCImage {
                        width: 20
                        height: width
                        anchors.centerIn: parent
                        source: "/images/fangda.svg"
                        color: "white"
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
                    width: 25
                    height: width
                    radius: 100
                    color: if(isHovered)return "2FFFFFFF"
                           else "#00000000"
                    QCImage {
                        width: 20
                        height: width
                        anchors.centerIn: parent
                        source: "/images/close.svg"
                        color: "white"
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
    Item {
        id: content
        width: parent.width
        height: parent.height-header.height-foolter.height
        anchors.top: header.bottom
            Column{
                id:infoColumn
                anchors.top: parent.top
                anchors.topMargin: 80
                anchors.left: parent.left
                anchors.leftMargin: 90
                spacing: 4
                Item {
                    id:cvoerItem
                    width: 200
                    height: width
                    RoundImage{
                        id:coverImg
                        width: 200
                        height: width
                        source: musicres.thisMusicInfo.coverImg
                    }
                    FastBlur{
                        z:-1
                        anchors.fill: parent
                        source: coverImg
                        radius: 60
                    }
                }
                Text {
                    id:nameText
                    width: 250
                    height: 27
                    wrapMode: Text.Wrap
                    text:musicres.thisMusicInfo.name
                    font.pointSize: 14
                    elide: Text.ElideRight//省略过长文本
                    layer.enabled: true
                    layer.effect: Glow {
                        anchors.fill: nameText
                        source:nameText
                        samples: radius*2
                        radius: 30
                        spread: .1
                        color:"#AFFFFFFF"
                    }
                    color:"#AFFFFFFF"
                }
                Text {
                    id:artistText
                    width: 250
                    height: 25
                    wrapMode: Text.Wrap
                    text:musicres.thisMusicInfo.artist
                    font.pointSize: 11
                    elide: Text.ElideRight
                    layer.enabled: true
                    layer.effect: Glow {
                        anchors.fill: artistText
                        source:artistText
                        samples: radius*2
                        radius: 25
                        spread: .1
                        color:"#AFFFFFFF"
                    }
                    color:"#AFFFFFFF"
                }
                Text {
                    id:albumText
                    width: 250
                    height: 15
                    wrapMode: Text.Wrap
                    text:musicres.thisMusicInfo.album
                    elide: Text.ElideRight
                    font.pointSize: 11
                    layer.enabled: true
                    layer.effect: Glow {
                        anchors.fill: albumText
                        source:albumText
                        samples: radius*2
                        radius: 25
                        spread: .1
                        color:"#AFFFFFFF"
                    }
                    color:"#AFFFFFFF"
                }
            }
            QCLyricListView{
                anchors.left: infoColumn.right
                anchors.leftMargin: parent.height-340
                // anchors.right: parent.right
                // anchors.rightMargin: 100
                // anchors.top: parent.top
                // anchors.topMargin: 10
                lyricData: musicres.thisPlayMusiclyric
            }
        }

    Item {
        id: foolter
        width: parent.width
        height: 60
        anchors.top: content.bottom
        Column{
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter
            Row{
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 5
                QCTooTipButton{
                    id:playModeIcon
                    width: 25
                    height: width
                    anchors.verticalCenter: parent.verticalCenter
                    source: "qrc:/images/repeatSinglePlay.svg"
                    isHoveredcolor: "2FFFFFFF"
                    color: "#00000000"
                    iconcolor: "#FFFFFF"
                    onClicked: {
                        musicPlayer.setPlayMode()
                    }

                    Connections{
                        target:musicPlayer
                        function onPlayModeStatesChanged(){
                            switch(musicPlayer.playModeStates){
                            case QCMusicPlayer.PlayMode.REPEATSINGLEPLAY:
                                playModeIcon.source="qrc:/images/repeatSinglePlay.svg"
                                break
                            case QCMusicPlayer.PlayMode.LOOPPLAY:
                                playModeIcon.source="qrc:/images/loopPlay.svg"
                                break
                            case QCMusicPlayer.PlayMode.RANDOMPLAY:
                                playModeIcon.source="qrc:/images/randomPlay.svg"
                                break
                            case QCMusicPlayer.PlayMode.PLAYLISTPLAY:
                                playModeIcon.source="qrc:/images/playList.svg"
                                break
                            }
                        }
                    }

                }
                QCTooTipButton{
                    width: 25
                    height: width
                    anchors.verticalCenter: parent.verticalCenter
                    source: "qrc:/images/prePlayer.svg"
                    isHoveredcolor: "2FFFFFFF"
                    color: "#00000000"
                    iconcolor: "#FFFFFF"
                    onClicked: {
                        musicPlayer.preMusic()
                    }
                }
                QCTooTipButton{
                    width: 25
                    height: width
                    anchors.verticalCenter: parent.verticalCenter
                    source:  "qrc:/images/stop.svg"//musicPlayer.playbackState === MediaPlayer.PlayingState ? "qrc:/images/stop.svg" : "qrc:/images/player.svg"

                    isHoveredcolor: "2F000000"
                    //color: "#00000000"
                    color:"#00000000"
                    iconcolor: "white"
                    onClicked: {
                        musicPlayer.playPauseMusic()
                    }

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
                    width: 25
                    height: width
                    anchors.verticalCenter: parent.verticalCenter
                    source: "qrc:/images/prePlayer.svg"
                    transformOrigin: Item.Center
                    rotation: -180
                    isHoveredcolor: "2FFFFFFF"
                    color: "#00000000"
                    iconcolor: "#FFFFFF"
                    onClicked: {
                        musicPlayer.nextMusic()
                    }
                }
                Component.onCompleted: {
                    var w=0
                    for(var i=0;i<children.length;i++)
                    {
                        w+=children[i].width
                    }
                    w=w+children.length*spacing-spacing
                    width=w
                }
            }
            Row{
                spacing: 10
                // anchors.bottom: parent.bottom
                // anchors.bottomMargin: 25
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    text:setTime(musicPlayer.position)
                    color: "white"
                    font.pointSize: 10
                    anchors.verticalCenter: parent.verticalCenter
                }
                Slider{
                    id:bottombarslider
                    width:300
                    height: 5
                    property bool movepressed: false
                    from: 0
                    to:musicPlayer.duration
                    anchors.verticalCenter: parent.verticalCenter
                    background: Rectangle{
                        color: "#2F000000"
                        Rectangle{
                            color: "#FF000000"
                            width: bottombarslider.visualPosition*parent.width
                            height:parent.height
                        }
                    }
                    handle:Rectangle {
                        implicitWidth:10
                        implicitHeight:10
                        radius:100
                        x:(bottombarslider.availableWidth+3)*bottombarslider.visualPosition
                        y:-((height-bottombarslider.height)/2)
                        border.width: 1.5
                        border.color: "#FFFFFF"
                        color: bottombarslider.pressed?"#FFFFFF":"white"
                    }

                    onMoved: {
                        movepressed=true
                    }
                    onPressedChanged: {
                        if(movepressed===true&&pressed===false){
                            movepressed=pressed
                            musicPlayer.seek(value)           //用seek函数改变position的值
                        }
                    }

                    Connections{
                        target: musicPlayer
                        enabled:bottombarslider.pressed===false
                        function onPositionChanged(){
                            bottombarslider.value=musicPlayer.position
                        }
                    }
                }
                Text {
                    text: musicres.thisMusicInfo.allTime
                    color: "white"
                    font.pointSize: 10
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
        QCBottomVolumeButton{
            id:volumebtn
            anchors.right: parent.right
            anchors.rightMargin: 55
            anchors.verticalCenter: parent.verticalCenter
            backgroundColor: "#2F000000"
            sliderBackgroundColor: "#4F000000"
            sliderStrikePaddingColor: "#FF000000"
            handleBorderColor: "white"
            handlePressedColor: "#FF000000"
            btnHoveredColor: "#2F000000"
            btnColor:"white"
            btnBackgroundColor: "#00000000"
        }
        QCTooTipButton{
            width: 25
            height: width
            anchors.left: volumebtn.right
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/playList.svg"
            isHoveredcolor:"#2F000000"
            color: "#00000000"
            iconcolor: "white"
        }
    }
    function setTime(time){
        var m=parseInt(time/1000/60)
        var s=parseInt(time/1000)%60

        m=m<10?"0"+m:m
        s=s<10?"0"+s:s
        return m+":"+s
    }
    function samplePixels(ctx, numSamples) {
        var colors = []
        for (var i = 0; i < numSamples; i++) {
            var x = Math.floor(Math.random() * width)
            var y = Math.floor(Math.random() * height)
            var pixel = ctx.getImageData(x, y, 1, 1).data
            var color = Qt.rgba(pixel[0]/255, pixel[1]/255, pixel[2]/255, 1)
            colors.push(color)
        }
        return colors
    }
    function mixColors(colors) {
        if (colors.length === 0) return "white"

        var totalRed = 0, totalGreen = 0, totalBlue = 0
        for (var i = 0; i < colors.length; i++) {
            totalRed += colors[i].r
            totalGreen += colors[i].g
            totalBlue += colors[i].b
        }
        var avgRed = totalRed / colors.length
        var avgGreen = totalGreen / colors.length
        var avgBlue = totalBlue / colors.length

        return Qt.rgba(avgRed, avgGreen, avgBlue, 1)
    }
}
