import QtQuick 2.15

MouseArea{
    property string source: ""
    property bool isHovered: false
    property string color:"" //图标外颜色
    property string isHoveredcolor:""//悬停时的color
    property string iconcolor: ""//图标颜色
    width: 30
    height: width
    hoverEnabled: true
    Rectangle{
        radius: 100
        anchors.fill: parent
        color: if(parent.isHovered) return parent.isHoveredcolor
        else return parent.color
    }
    QCImage {
        width: parent.width*0.55
        height: width
        source: parent.source
        anchors.centerIn: parent
        sourceSize: Qt.size(32,32)
        color: parent.iconcolor
    }
    onEntered: {
        isHovered=true
    }
    onExited: {
        isHovered=false
    }
}
