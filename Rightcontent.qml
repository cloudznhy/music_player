import QtQuick 2.15

Rectangle{
    id:rightcontent
    color: "#F0FAFA"
    property string thisqml: "pagefindmusic.qml"
    property alias loadItem: rightContentLoader.item
    property var pageStep: []
    property int stepCurrent: -1
    property int stepPageCount: 0
    function pushStep(obj){
        let info = {name: obj.name, callBack: obj.callBack}
            pageStep.push(info)
            stepPageCount = pageStep.length
            stepCurrent += 1
            obj.callBack()  // 确保回调执行
            rightContentLoader.source = rightcontent.thisqml
    }
    function preStep(){
        if(stepCurrent<=0)return
        stepCurrent-=1
        //rightcontent.thisqml = ""
        pageStep[stepCurrent].callBack()
        console.log("现在执行："+pageStep[stepCurrent].name)
    }
    function nextStep(){
        if(stepCurrent>=stepPageCount-1)return
        stepCurrent+=1
        //rightcontent.thisqml = ""
        pageStep[stepCurrent].callBack()
        console.log("现在执行："+pageStep[stepCurrent].name)
    }
    Connections {
            target: rightcontent
            function onThisqmlChanged() {
                rightContentLoader.source = rightcontent.thisqml
            }
        }
    Loader{
        id:rightContentLoader
        source: rightcontent.thisqml
        // onStatusChanged: {
        //     if(status===Loader.Ready){
        //         item.parent=parent
        //     }
        // }
        anchors.fill: parent
        onLoaded: {
                item.parent=parent
                // 强制触发尺寸更新
                if (item) {
                    item.width = Qt.binding(() => width)
                    item.height = Qt.binding(() => height)
                }

            }
    }
}
