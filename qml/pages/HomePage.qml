import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../components"

Item {
    id: root
    property var season_animes: []
    property var seasonAnimeModel

    Connections {
        target: pluginSystem

        onSeasonTitleLoaded:
            (search_res) => {
                let animes = JSON.parse(search_res);
                for(var i = 0; i < animes.length; ++i) {
                    season_animes.push(animes[i])
                }
                seasonAnimeModel = season_animes
        }
    }

    Component.onCompleted: {
        pluginSystem.seasonTitleLoad()
    }

    Column {
        anchors.fill: parent
        anchors.leftMargin: 20
        anchors.topMargin: 10
        spacing: 15

        Text {
            text: "Новое"
            font.pixelSize: 30
            color: "white"
        }

        ListView {
            height: 400
            width: parent.width
            snapMode: ListView.SnapToItem
            orientation: ListView.Horizontal
            model: root.seasonAnimeModel
            spacing: 12

            rebound: Transition {
                NumberAnimation {
                    properties: "x,y"
                    duration: 400
                    easing.type: Easing.OutElastic
                }
            }

            delegate: Item {
                id: delegateRoot
                width: 240;  height: lay.height

                DropShadow {
                    anchors.fill: delRect
                    source: delRect
                    radius: 4
                    spread: 0
                    horizontalOffset: 0
                    verticalOffset: 0
                }

                Rectangle {
                    id: delRect
                    anchors.fill: parent
                    color: "#272727"
                    radius: 10

                    ColumnLayout {
                        id: lay
                        anchors.margins: 5
                        anchors.left: parent.left
                        anchors.top: parent.top

                        Item {
                            id: imgRoot
                            Layout.preferredWidth: delRect.width - 10
                            Layout.minimumHeight: 340

                            Image {
                                id: imgAnime
                                anchors.fill: parent
                                source: modelData.image.original
                                asynchronous: true
                                cache: true
                                fillMode: Image.PreserveAspectCrop

                                states: [
                                    State {
                                        when: imgAnime.status === Image.Ready
                                        PropertyChanges { target: imgAnime; opacity: 1; scale: 1 }
                                    },
                                    State {
                                        when: imgAnime.status === Image.Loading
                                        PropertyChanges { target: imgAnime; opacity: 0; scale: 0.9 }
                                    }
                                ]
                                transitions: [
                                    Transition {
                                        to: "*"
                                        NumberAnimation {
                                            target: imgAnime
                                            duration: 200
                                            properties: "opacity,y,scale"
                                        }
                                    }


                                ]

                                layer.enabled: true
                                layer.effect: OpacityMask {
                                    maskSource: Rectangle {
                                        width: imgAnime.width; height: imgAnime.height;
                                        radius: 10;
                                    }
                                }
                            }
                        }

                        Text {
                            id: txt
                            function clamp(value, min, max) {
                                let t = value < min ? min : value
                                return t > max ? max : t
                            }
                            Layout.preferredWidth: clamp(implicitWidth, 0, imgAnime.width - 12*2)
                            //Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter
                            Layout.leftMargin: 12
                            Layout.rightMargin: 12
                            wrapMode: Text.WordWrap
                            text: modelData.russian_name
                            font.pixelSize: 18
                            maximumLineCount: 1
                            elide: Text.ElideRight
                            color: "white"

                            MouseArea {
                                id: txtArea
                                anchors.fill: parent
                                hoverEnabled: true
                            }

                            Tooltip {
                                visibility: txt.truncated ? txtArea.containsMouse : false
                                yPopup: parent.height + 8
                                xPopup: parent.width / 2 - implicitWidth / 2

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.russian_name
                                    color: "white"
                                    font.pixelSize: 15
                                }
                            }

                            Behavior on y {
                                NumberAnimation {}
                            }
                        }
                        Item {
                            height: 10
                        }
                    }
                }
            }
        }
    }
}
