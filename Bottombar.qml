import QtQuick 2.15
import QtQuick.Controls 2.5
import QtMultimedia 5.15
Rectangle{
    id:bottombar
    height: 70
    width: parent.width
    color: /*"#FAFAFA"*/"#E0F2F1"
    property double fontsize:10

    Slider{
        id:bottombarslider
        width: parent.width
        height: 5
        property bool movepressed: false
        from: 0
        to:musicPlayer.duration
        anchors.bottom: parent.top
        background: Rectangle{
            color: "#E0F2F1"
            Rectangle{
                color: "#C7E5E2"
                width: bottombarslider.visualPosition*parent.width
                height:parent.height
            }
        }
        handle:Rectangle {
            implicitWidth:20
            implicitHeight:20
            radius:100
            x:(bottombarslider.availableWidth-7)*bottombarslider.visualPosition
            y:-((height-bottombarslider.height)/2)
            border.width: 1.5
            border.color: "#C7E5E2"
            color: bottombarslider.pressed?"#C7E5E2":"white"
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

    Item {
        width: parent.width-15
        height: parent.height-20
        anchors.centerIn: parent
        Row{
            spacing: 5
            width: parent.width*.3
            height: parent.height

            Image{
                id:musicCoverIcon
                width: parent.height
                height:width
                source: musicres.thisMusicInfo.coverImg
                asynchronous: true
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        window.lyricPageVisible=true
                    }
                }
            }


            Column{
                anchors.verticalCenter: parent.verticalCenter
                spacing: 7
                Text {
                    text:musicres.thisMusicInfo.name
                    font.pointSize: bottombar.fontsize
                    color:/* "#696969"*/"#263339"
                }
                Text {
                    text:musicres.thisMusicInfo.artist
                    font.pointSize: bottombar.fontsize
                    color: "#52616B"//"#B5B5B5"
                }
            }
        }
        Row{
            width: parent.width*0.3
            height: parent.height
            anchors.centerIn: parent
            spacing: 5
            QCTooTipButton{
                id:playModeIcon
                width: 25
                height: width
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/images/repeatSinglePlay.svg"
                isHoveredcolor: "#C7E5E2"
                color: "#00000000"
                iconcolor: "#26A69A"
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
                isHoveredcolor: "#C7E5E2"
                color: "#00000000"
                iconcolor: "#26A69A"
                onClicked: {
                   musicPlayer.preMusic()
                }
            }
            QCTooTipButton{
                width: 25
                height: width
                anchors.verticalCenter: parent.verticalCenter
                source:  musicPlayer.playbackState === MediaPlayer.PlayingState ? "qrc:/images/stop.svg" : "qrc:/images/player.svg"

                isHoveredcolor: "#43CD80"
                //color: "#00000000"
                color:"#43CD80"
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
                isHoveredcolor: "#C7E5E2"
                color: "#00000000"
                iconcolor: "#26A69A"
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
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: 5
            Text {
                text:setTime(musicPlayer.position)+"/" //"00:00/"
                font.pointSize: bottombar.fontsize
                anchors.verticalCenter: parent.verticalCenter
                color:"#263339"
            }
            Text {
                text:musicres.thisMusicInfo.allTime===""?"00:00":musicres.thisMusicInfo.allTime
                font.pointSize: bottombar.fontsize
                anchors.verticalCenter: parent.verticalCenter
                color:"#263339"
            }
            QCBottomVolumeButton{
                id:volumeButton
            }

            QCTooTipButton{
                width: 25
                height: width
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/images/playList.svg"
                isHoveredcolor: "#C7E5E2"
                color: "#00000000"
                iconcolor: "#26A69A"
            }
        }
    }
    function setTime(time){
        var m=parseInt(time/1000/60)
        var s=parseInt(time/1000)%60

        m=m<10?"0"+m:m
        s=s<10?"0"+s:s
        return m+":"+s
    }
}

