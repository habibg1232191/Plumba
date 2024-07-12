import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import QtQuick.Controls
import "components"
import "pages"

import com.kdab.cxx_qt.demo

Window {
    id: rootWindow

    width: 940
    height: 580
    visible: true
    color: "transparent"
    title: qsTr("Hello World")

    minimumWidth: 400
    minimumHeight: 300

    flags: Qt.FramelessWindowHint | Qt.Window

    PluginSystem {
        id: pluginSystem
        onTitleLoaded: (title) => {
            console.log(title)
            let title1 = JSON.parse(title)
            if (title.error === undefined) {
                txt.text = "Counter " + title1.eng_name
            }
        }
    }

    Item {
        property int lenghtResize: 7
        MouseArea {
            width: parent.lenghtResize
            height: rootWindow.height
            cursorShape: Qt.SizeHorCursor
            onPressed: {
                rootWindow.startSystemResize(Qt.LeftEdge)
            }
        }

        MouseArea {
            width: rootWindow.width
            height: parent.lenghtResize
            cursorShape: Qt.SizeVerCursor
            onPressed: {
                rootWindow.startSystemResize(Qt.TopEdge)
            }
        }

        MouseArea {
            x: rootWindow.width - parent.lenghtResize
            width: parent.lenghtResize
            height: rootWindow.height
            cursorShape: Qt.SizeHorCursor
            onPressed: {
                rootWindow.startSystemResize(Qt.RightEdge)
            }
        }

        MouseArea {
            y: rootWindow.height - parent.lenghtResize
            width: rootWindow.width
            height: parent.lenghtResize
            cursorShape: Qt.SizeVerCursor
            onPressed: {
                rootWindow.startSystemResize(Qt.BottomEdge)
            }
        }
    }

    DropShadow {
        anchors.fill: rootShadowRect
        source: rootShadowRect
        radius: 8
        color: "black"
        horizontalOffset: 0
        verticalOffset: 0
    }

    Rectangle {
        id: rootShadowRect
        anchors.fill: parent
        anchors.margins: rootWindow.visibility !== Qt.WindowMaximized ? 0 : 10
        color: "transparent"
        radius: 10

        Rectangle {
            id: rootRect
            anchors.fill: parent
            color: "#232323"
            radius: 10

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: rootRect.width; height: rootRect.height
                    radius: 10
                }
            }

            ColumnLayout {
                anchors.fill: parent

                TitleBar {
                    id: tb
                    onHomeButtonClicked: {
                        console.log("home btn clicked")
                    }
                    onSearchButtonClicked: {
                        console.log("search btn clicked")
                    }
                    onUserButtonClicked: {
                        console.log("user btn clicked")
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    StackView {
                        id: rootStackView
                        anchors.fill: parent
                        initialItem: HomePage {}

                        pushEnter: Transition {
                            PropertyAnimation {
                                property: "opacity"
                                from: 0
                                to:1
                                duration: 200
                            }
                        }
                        pushExit: Transition {
                            PropertyAnimation {
                                property: "opacity"
                                from: 1
                                to:0
                                duration: 200
                            }
                        }
                        popEnter: Transition {
                            PropertyAnimation {
                                property: "opacity"
                                from: 0
                                to:1
                                duration: 200
                            }
                        }
                        popExit: Transition {
                            PropertyAnimation {
                                property: "opacity"
                                from: 1
                                to:0
                                duration: 200
                            }
                        }
                    }
                }
            }
        }
    }
}
