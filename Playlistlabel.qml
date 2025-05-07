import QtQuick 2.15

Rectangle{
    id:labelcontent
    width: 180
    height:200
    radius: 10
    property alias button: btn
    property alias imgSourceSize: coverimg.sourceSize
    property string normalcolor: ""
    property string hoveredcolor: ""
    property string imgsource: ""
    property double fontsize: 10
    property string text: ""
    signal clicked()
    signal btnclicked()
    state: "normal"
    states: [
        State {
            name: "normal"
            PropertyChanges {
                target: labelcontent
                color:normalcolor
            }
            PropertyChanges {
                target: btn
                y:btn.parent.height
            }
            PropertyChanges {
                target: btn
                opacity:0
            }
        },
        State {
            name: "hovered"
            PropertyChanges {
                target: labelcontent
                color:hoveredcolor
            }
            PropertyChanges {
                target: btn
                y:btn.parent.height-btn.height-20
            }
            PropertyChanges {
                target: btn
                opacity:1
            }
        }
    ]
    transitions: [
        Transition {
            from: "normal"
            to: "hovered"

            ColorAnimation {
                easing.type: Easing.InOutQuart
                duration: 300
            }
            PropertyAnimation{
                easing.type:Easing.InOutQuart
                duration: 300
                target: btn
                property: "y"
            }
            PropertyAnimation{
                easing.type:Easing.InOutQuart
                duration: 300
                target: btn
                property: "opacity"
            }
        },
        Transition {
            from: "hovered"
            to: "normal"

            ColorAnimation {
                easing.type: Easing.InOutQuart
                duration: 300
            }
            PropertyAnimation{
                easing.type:Easing.InOutQuart
                duration: 300
                target: btn
                property: "y"
            }
            PropertyAnimation{
                easing.type:Easing.InOutQuart
                duration: 300
                target: btn
                property: "opacity"
            }
        }
    ]

    MouseArea{
        hoverEnabled: true
        anchors.fill: parent
        onClicked: {
            labelcontent.clicked()
        }
        onEntered: {
            parent.state="hovered"
        }
        onExited: {
            parent.state="normal"
        }
        Column{
            width: parent.width-30
            height:parent.height-30
            anchors.centerIn: parent
            spacing: 20
            RoundImage{
                id:coverimg
                width: parent.width
                height: width
                radius: 10
                source:imgsource
                QCTooTipButton{
                    id:btn
                    width: 40
                    height: width
                    x:parent.width-btn.width-20
                    y:parent.height
                    clip: true
                    onClicked: {
                        labelcontent.btnclicked()
                    }
                }
            }
            Text {
                 width: parent.width
                 // height: parent.height-coverimg.height-parent.spacing
                 text:labelcontent.text
                elide: Text.ElideRight
                wrapMode: Text.Wrap
                color:"#263339"
                font.pointSize: labelcontent.fontsize
            }
        }
    }
}
