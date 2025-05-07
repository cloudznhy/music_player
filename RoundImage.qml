import QtQuick 2.15
import QtGraphicalEffects 1.0
Item {
    property string source:""
    property double radius: 8
    property alias fillmode :img.fillMode
    property alias sourceSize: img.sourceSize
    Image {
        id:img
        source: parent.source
        anchors.fill: parent
        visible: false
        fillMode: Image.PreserveAspectCrop // 图像填充模式，保持纵横比并裁剪以适应容器
    }
    OpacityMask{
        source: img
        maskSource: mask
        anchors.fill: parent
    }
    Rectangle{
        id:mask
        anchors.fill: parent
        radius:parent.radius
        visible: false
    }
}
