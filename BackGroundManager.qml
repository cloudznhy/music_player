import QtQuick 2.15
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.15
import ImgColor 1.0

Item {
    id: root
    width: parent.width
    height: parent.height

    // 颜色分析组件
    ImageColor { id: imgColor }

    // 背景加载器
    Loader {
        id: backgroundLoader
        anchors.fill: parent
        sourceComponent: gradientBackground
    }

    // ========================================================================
    // 渐变背景组件
    // ========================================================================
    Component {
        id: gradientBackground
        Item {
            id: gradientBackgroundItem
            anchors.fill: parent

            // 自定义封面图片（仅用于颜色分析）
            Image {
                id: coverSource
                visible: false
                asynchronous: true
                source: musicres.thisMusicInfo.coverImg  // 默认封面
                sourceSize: Qt.size(200, 200)

                // 绑定音乐信息变化
                Connections {
                    target: musicres
                    function onThisMusicInfoChanged() {
                        coverSource.source = musicres.thisMusicInfo.coverImg
                    }
                }
            }

            // 渐变背景主体
            LinearGradient {
                id: gradient
                anchors.fill: parent
                start: Qt.point(0, 0)
                end: Qt.point(parent.width, parent.height)
                gradient: Gradient {
                    GradientStop { id: gradStart; position: 0.0; color: "#202125" }
                    GradientStop { id: gradEnd; position: 1.0; color: "#18191d" }
                }

                // 颜色提取处理
                Connections {
                    target: coverSource
                    function onStatusChanged() {
                        if (coverSource.status === Image.Ready) {
                            gradientBackgroundItem.extractColors()
                        }
                    }
                }

                Component.onCompleted: {
                    if (coverSource.status === Image.Ready) {
                        gradientBackgroundItem.extractColors()
                    }
                }
            }

            //暗色遮罩层
            RectangularGlow {
                anchors.fill: parent
                z: headerbackground_2.z + 1
                glowRadius: 16 // 光晕半径
                spread: 0.2 // 扩散范围
                color: "#2F000000" // 半透明黑色
            }

            // 颜色提取函数
            function extractColors() {
                coverSource.grabToImage(function(result) {
                    try {
                        const colors = imgColor.getMainColors(result.image)
                        gradStart.color = colors[0]
                        gradEnd.color = colors[1]
                    } catch (e) {
                        console.error("Color extraction failed:", e)
                    }
                }, Qt.size(200, 200))
            }
        }
    }

    // ========================================================================
    // 模糊背景组件
    // ========================================================================
    Component {
        id: imgBackground
        Item {
            property alias source: blurImage.source

            Image {
                id: blurImage
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                sourceSize: Qt.size(800, 800)
                onStatusChanged: {
                    if (status === Image.Error) {
                        source = musicres.thisMusicInfo.coverImg
                    }
                }
            }

            GaussianBlur {
                anchors.fill: blurImage
                source: blurImage
                radius: 32
                samples: 64
            }

            ColorOverlay {
                anchors.fill: parent
                color: "#80000000"
            }
        }
    }

    // ========================================================================
    // 背景切换控制
    // ========================================================================
    function setBackgroundType(type) {
        switch (type) {
            case "gradient":
                backgroundLoader.sourceComponent = gradientBackground
                break
            case "blur":
                backgroundLoader.sourceComponent = imgBackground
                if (backgroundLoader.item) {
                    backgroundLoader.item.source = musicres.thisMusicInfo.coverImg
                }
                break
        }
    }

    // 初始化默认背景
    Component.onCompleted: {
        setBackgroundType("gradient")
    }
}
