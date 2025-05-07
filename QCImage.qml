import QtQuick 2.15
import QtGraphicalEffects 1.0
Image {
   id:img
   property string color: ""
   ColorOverlay{
       anchors.fill: parent
       source: img
       color: parent.color
   }
}
