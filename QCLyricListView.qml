import QtQuick 2.15
//歌词
Item {
    width: parent.width
    height: parent.height
    property ListModel lyricData: ListModel{}
    property bool isfollow: true

    function offsetScale(index,currentindex){
        var offset=Math.abs(index-currentindex)
        var maxScale=1.2
        return maxScale-offset / 10
    }
    WheelHandler {
           onWheel: function(wheelEvent) {
               isfollow=false
               if (wheelEvent.angleDelta.y > 0 && lyricListView.currentIndex > 0) {
                   lyricListView.currentIndex -= 1;
               } else if (wheelEvent.angleDelta.y < 0 && lyricListView.currentIndex < lyricListView.count - 1) {
                   lyricListView.currentIndex += 1;
               }
               isfollowTim.restart()
            }
       }

    Timer{
        id:isfollowTim
        interval: 10000
        onTriggered: {
            isfollow=true
        }
    }

    ListView{
        id:lyricListView
        width: parent.width
        height: parent.height
        clip: true
        currentIndex: 0
        property int current: -1
        preferredHighlightBegin:parent.height/2-25
        preferredHighlightEnd:parent.height/2+25
        highlightMoveDuration: 100
        highlightRangeMode: ListView.StrictlyEnforceRange//NoHighlightRange
        //interactive: false//禁用自带的滚动
        model:musicres.thisPlayMusiclyric
        delegate: lyricDelegate
        onCurrentChanged: {
            if(isfollow){
                currentIndex=current
            }
        }
    }
    Component{
        id:lyricDelegate
        Rectangle{
            id:lyricItem
            property bool ishovered: false
            width: children[0].width+20
            height: children[0].height+20
            color: ishovered?"#2F000000":"#00000000"
            radius: 10
            transformOrigin: Item.Left
            scale:offsetScale(index,lyricListView.currentIndex)
            Behavior on color{
                ColorAnimation {
                    duration: 200
                    easing.type: Easing.InOutCubic
                }
            }
            Behavior on scale{

                NumberAnimation {
                    property: "scale"
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
            }

            Column{
                width: 230
                height: children[0].height+children[1].height
                anchors.centerIn: parent
                Text {
                    text:lyric
                    width: parent.width
                    height:text===""?0: contentHeight
                    font.pointSize: 14
                    font.bold: true
                    wrapMode: Text.Wrap
                    color:lyricListView.current===index?"#FFFFFF":"#7FFFFFFF"
                }
                Text {
                    text:tlrc
                    width: parent.width
                    height:text===""?0: contentHeight
                    font.pointSize: 12
                    font.bold: true
                    wrapMode: Text.Wrap
                    color:lyricListView.current===index?"#FFFFFF":"#7FFFFFFF"
                }
            }

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    lyricListView.currentIndex=index
                    lyricListView.current=index
                    musicPlayer.seek(tim)
                }
                onEntered: {
                    ishovered=true
                }
                onExited: {
                    ishovered=false
                }
            }}

    }
    Connections{
        target: musicPlayer
        function onPositionChanged(){
            for(let i=0;i<lyricListView.count;i++){
                if(musicPlayer.position >lyricData.get(i).tim){
                    if(i===lyricListView.count-1){
                        lyricListView.current=i
                        break
                    }else if(lyricData.get(i+1).tim>musicPlayer.position){
                        lyricListView.current=i
                        break
                    }
                }
            }
        }
    }
}
