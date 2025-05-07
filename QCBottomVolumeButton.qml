import QtQuick 2.15
import QtQuick.Controls 2.15
MouseArea{
    width: 25
    height: 100
    hoverEnabled: true
    property string backgroundColor: "#F0FAFA"
    property string sliderBackgroundColor: "#E0F2F1"
    property string sliderStrikePaddingColor: "#C7E5E2"
    property string handleBorderColor: "#C7E5E2"
    property string handlePressedColor: "#C7E5E2"
    property string btnHoveredColor: "#C7E5E2"
    property string btnColor: "#26A69A"
    property string btnBackgroundColor: "#00000000"
    state: "normal"
    states: [
        State {
            name: "normal"
            PropertyChanges {
                target:volumeBackGround
                height:0
                opacity:0
            }
        },
        State {
            name: "hovered"
            PropertyChanges {
                target:volumeBackGround
                height:100
                opacity:1
            }
        }
    ]
    transitions: [
        Transition {
            from: "normal"
            to: "hovered"

            NumberAnimation {
                target: volumeBackGround
                property: "height"
                duration: 300
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: volumeBackGround
                property: "opacity"
                duration: 300
                easing.type: Easing.InOutQuad
            }
        },
        Transition {
            from: "hovered"
            to: "normal"

            NumberAnimation {
                target: volumeBackGround
                property: "height"
                duration: 300
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: volumeBackGround
                property: "opacity"
                duration: 300
                easing.type: Easing.InOutQuad
            }
        }
    ]

    onExited: {
        state="normal"
    }
    Rectangle {
        id:volumeBackGround
        width: parent.width
        height: 100
        anchors.bottom: volumeBtn.top
        anchors.bottomMargin: 5
        color: backgroundColor

        Slider{
            id:bottombarVolumeslider
            width: 15
            height:90
            property bool movepressed: false
            property double lastVolume: 0
            anchors.centerIn: parent
            value:0.5  //滑钮的初始位置：设为中间
            from: 0
            to:1
            orientation:Qt.Vertical//竖向布局
            background: Rectangle{
                color: sliderBackgroundColor
                radius: 12
                Rectangle{
                    color:sliderStrikePaddingColor
                    width:parent.width
                    radius: 20
                    height: (1-bottombarVolumeslider.visualPosition)*parent.height
                    anchors.bottom: parent.bottom
                }
            }
            handle:Rectangle {
                implicitWidth:17
                implicitHeight:17
                radius:100
                x:-((width-bottombarVolumeslider.width)/2)
                y:(bottombarVolumeslider.availableHeight-2)*bottombarVolumeslider.visualPosition
                border.width: 1.5
                border.color: handleBorderColor
                color: bottombarVolumeslider.pressed?handlePressedColor:"white"
            }

            onMoved: {
                musicPlayer.volume=value
                lastVolume=value

            }
            onPressedChanged: {
                if(movepressed===true&&pressed===false){
                    movepressed=pressed
                    musicPlayer.seek(value)           //用seek函数改变position的值
                }
            }
        }
    }
    QCTooTipButton{
        id:volumeBtn
        width: 25
        height: width
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/images/V.svg"
        isHoveredcolor: btnHoveredColor
        color: btnBackgroundColor
        iconcolor: btnColor
        onEntered: {
            parent.state="hovered"
        }
        onClicked: {
            if(musicPlayer.volume!==0){
                musicPlayer.volume===0
            }else{
                musicPlayer.volume===bottombarVolumeslider.lastVolume
            }
        }
    }

}


