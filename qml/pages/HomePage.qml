import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../components"

Item {
    id: root
    anchors.fill: parent

    property var season_animes: []
    property var top_animes: []
    property var seasonAnimeModel
    property var topAnimesModel

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

        onTopTitleLoaded: (top_anime_res) => {
                let animes = JSON.parse(top_anime_res);
                for(var i = 0; i < animes.length; ++i) {
                    top_animes.push(animes[i])
                }
                topAnimesModel = top_animes
        }
    }

    Component.onCompleted: {
        pluginSystem.seasonTitleLoad()
        pluginSystem.getTopTitles()
    }

    ColumnLayout {
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
            Layout.preferredHeight: 400
            Layout.fillWidth: true
            snapMode: ListView.SnapToItem
            orientation: ListView.Horizontal
            model: root.seasonAnimeModel
            spacing: 12

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
                                        PropertyChanges { opacity: 1; scale: 1 }
                                    },
                                    State {
                                        when: imgAnime.status === Image.Loading
                                        PropertyChanges { opacity: 0; scale: 0.9 }
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
                        }

                        Item {
                            Layout.preferredHeight: 10
                        }
                    }
                }
            }
        }

        GridView {
            Layout.fillWidth: true
            Layout.preferredHeight: rootWindow.height
            clip: true
            cellWidth: 240
            cellHeight: 400
            model: root.topAnimesModel

            delegate: Item {
                id: delegateRootGrid
                width: 240;  height: layGrid.height

                DropShadow {
                    anchors.fill: delRectGrid
                    source: delRectGrid
                    radius: 4
                    spread: 0
                    horizontalOffset: 0
                    verticalOffset: 0
                }

                Rectangle {
                    id: delRectGrid
                    anchors.fill: parent
                    anchors.margins: 5
                    color: "#272727"
                    radius: 10

                    ColumnLayout {
                        id: layGrid
                        anchors.margins: 5
                        anchors.left: parent.left
                        anchors.top: parent.top

                        Item {
                            id: imgRootGrid
                            Layout.preferredWidth: delRectGrid.width - 10
                            Layout.minimumHeight: 340

                            Image {
                                id: imgAnimeGrid
                                anchors.fill: parent
                                source: modelData.image.original
                                asynchronous: true
                                cache: true
                                fillMode: Image.PreserveAspectCrop

                                states: [
                                    State {
                                        when: imgAnimeGrid.status === Image.Ready
                                        PropertyChanges { target: imgAnimeGrid; opacity: 1; scale: 1 }
                                    },
                                    State {
                                        when: imgAnimeGrid.status === Image.Loading
                                        PropertyChanges { target: imgAnimeGrid; opacity: 0; scale: 0.9 }
                                    }
                                ]
                                transitions: [
                                    Transition {
                                        to: "*"
                                        NumberAnimation {
                                            target: imgAnimeGrid
                                            duration: 200
                                            properties: "opacity,y,scale"
                                        }
                                    }
                                ]

                                layer.enabled: true
                                layer.effect: OpacityMask {
                                    maskSource: Rectangle {
                                        width: imgAnimeGrid.width; height: imgAnimeGrid.height;
                                        radius: 10;
                                    }
                                }
                            }
                        }

                        Text {
                            id: txtGrid
                            function clamp(value, min, max) {
                                let t = value < min ? min : value
                                return t > max ? max : t
                            }
                            Layout.preferredWidth: clamp(implicitWidth, 0, imgAnimeGrid.width - 12*2)
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
                                id: txtAreaGrid
                                anchors.fill: parent
                                hoverEnabled: true
                            }

                            Tooltip {
                                visibility: txtGrid.truncated ? txtAreaGrid.containsMouse : false
                                yPopup: parent.height + 8
                                xPopup: parent.width / 2 - implicitWidth / 2

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.russian_name
                                    color: "white"
                                    font.pixelSize: 15
                                }
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
