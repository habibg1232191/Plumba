import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import QtQuick.Controls

Rectangle {
    Layout.fillWidth: true
    height: 44
    color: "#1c1c1c"

    signal userButtonClicked
    signal homeButtonClicked
    signal searchButtonClicked

    function toogleMaximized() {
        if(rootWindow.visibility === Qt.WindowMaximized) {
            rootWindow.showMaximized()
        } else {
            rootWindow.showNormal()
        }
    }

    MouseArea {
        anchors.fill: parent

        onPressed: {
            rootWindow.startSystemMove()
        }

        onDoubleClicked: {
            toogleMaximized()
        }
    }

    Row {
        id: tabRow
        anchors.fill: parent
        anchors.left: parent.left
        anchors.leftMargin: 8
        spacing: 6

        component TabButton: Item {
            id: tabButton
            width: tabButtonLayout.width + 20
            height: tabButtonRect.height

            property alias text: tabButtonText.text
            property alias visibleText: tabButtonText.state
            property alias iconSize: tabIcon.width
            property alias iconColor: tabIconOverlay.color
            property string iconSource

            Item {
                id: timerItemTooltip

                property bool isRunning: false

                Timer {
                    id: timerTooltip
                    interval: 400
                    running: tabBtnArea.containsMouse
                    onTriggered: {
                        timerItemTooltip.isRunning = true
                    }
                }
            }

            MouseArea {
                id: tabBtnArea
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    timerTooltip.start()
                }
                onExited: {
                    timerTooltip.stop()
                    timerItemTooltip.isRunning = false
                }
            }

            Tooltip {
                visibility: visibleText === "Visible" ? false : (timerItemTooltip.isRunning ? tabBtnArea.containsMouse : false)
                yPopup: parent.height + 8
                xPopup: parent.width / 2 - implicitWidth / 2

                Text {
                    anchors.centerIn: parent
                    text: tabButton.text
                    color: "white"
                    font.pixelSize: 15
                }
            }

            Rectangle {
                id: tabButtonRect
                width: parent.width
                height: 32
                color: tabBtnArea.containsMouse ? "#2E2E2E" : "#222222"
                radius: 10

                Behavior on color {
                    ColorAnimation {
                        duration: 100
                    }
                }

                Row {
                    id: tabButtonLayout
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 12
                    height: 18

                    width: itemTabIcon.width + (tabButtonText.state === "Visible" ? tabButtonText.implicitWidth + 12 : 0)

                    Behavior on width {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.InOutQuad
                        }
                    }

                    Item {
                        id: itemTabIcon
                        anchors.verticalCenter: parent.verticalCenter
                        width: 13
                        height: parent.height

                        Image {
                            id: tabIcon
                            width: 13
                            anchors.centerIn: parent
                            source: tabButton.iconSource
                            fillMode: Image.PreserveAspectFit
                            antialiasing: false
                            smooth: true
                        }

                        ColorOverlay {
                            id: tabIconOverlay
                            anchors.fill: tabIcon
                            source: tabIcon
                            color: "#D5ABFF"
                        }
                    }

                    Text {
                        id: tabButtonText
                        height: itemTabIcon.height
                        font.pixelSize: 16
                        font.weight: 600
                        color: "white"
                        x: 0

                        state: "Visible"

                        states: [
                            State{
                                name: "Visible"
                                PropertyChanges{ target: tabButtonText; opacity: 1.0; scale: 1.0 }
                                PropertyChanges{ target: tabButtonText; visible: true }
                            },
                            State{
                                name:"Invisible"
                                PropertyChanges{ target: tabButtonText; opacity: 0.0; scale: 0.8 }
                                PropertyChanges{ target: tabButtonText; visible: false }
                            }
                        ]

                        transitions: [
                            Transition {
                                from: "Visible"
                                to: "Invisible"

                                SequentialAnimation{
                                    NumberAnimation {
                                        target: tabButtonText
                                        properties: "opacity,scale,x"
                                        duration: 200
                                        easing.type: Easing.InOutQuad
                                    }
                                    NumberAnimation {
                                        target: tabButtonText
                                        property: "visible"
                                        duration: 0
                                    }
                                }
                            },
                            Transition {
                                from: "Invisible"
                                to: "Visible"
                                SequentialAnimation {
                                    NumberAnimation {
                                        target: tabButtonText
                                        property: "visible"
                                        duration: 0
                                    }
                                    NumberAnimation {
                                        target: tabButtonText
                                        properties: "opacity,scale,x"
                                        duration: 200
                                        easing.type: Easing.InOutQuad
                                    }
                                }
                            }
                        ]
                    }
                }
            }

            DropShadow {
                anchors.fill: tabButtonRect
                source: tabButtonRect
                radius: 2
                horizontalOffset: 0
                verticalOffset: 0
            }
        }

        TabButton {
            id: userTab
            text: "User"
            visibleText: "Invisible"
            iconSize: 17
            iconColor: "#DB7093"
            iconSource: "qrc:/icons/User.svg"
            anchors.verticalCenter: parent.verticalCenter

            MouseArea {
                anchors.fill: parent
                onClicked: userButtonClicked()
            }
        }

        TabButton {
            id: homeTab
            text: "Главная"
            iconSize: 12
            clip: true
            visibleText: rootWindow.width < 410 ? "Invisible" : "Visible"
            iconSource: "qrc:/icons/Home.svg"
            anchors.verticalCenter: parent.verticalCenter

            MouseArea {
                anchors.fill: parent
                onClicked: homeButtonClicked()
            }
        }

        TabButton {
            id: searchTab
            text: "Искать"
            iconSize: 14
            clip: true
            visibleText: rootWindow.width < 490 ? "Invisible" : "Visible"
            iconSource: "qrc:/icons/Search.svg"
            anchors.verticalCenter: parent.verticalCenter

            MouseArea {
                anchors.fill: parent
                onClicked: searchButtonClicked()
            }
        }

        TabButton {
            id: searchTab3
            text: "Искать 3"
            iconSize: 14
            clip: true
            visibleText: rootWindow.width < 550 ? "Invisible" : "Visible"
            iconSource: "qrc:/icons/Search.svg"
            anchors.verticalCenter: parent.verticalCenter

            MouseArea {
                anchors.fill: parent
                onClicked: searchButtonClicked()
            }
        }

        TabButton {
            id: searchTab4
            text: "Искать 4"
            iconSize: 14
            clip: true
            visibleText: rootWindow.width < 620 ? "Invisible" : "Visible"
            iconSource: "qrc:/icons/User.svg"
            anchors.verticalCenter: parent.verticalCenter

            MouseArea {
                id: searchTabArea
                anchors.fill: parent
                onClicked: searchButtonClicked()
            }
        }
    }

    RowLayout {
        id: wndRowLayout
        anchors.right: parent.right
        anchors.rightMargin: 15
        anchors.verticalCenter: parent.verticalCenter
        spacing: 8

        Item {
            width: 23; height: 23
            MouseArea {
                id: wndBtnArea3
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    rootWindow.showMinimized()
                }
            }
            Rectangle {
                id: wndBtn3
                radius: 50
                color: wndBtnArea3.containsMouse ? "#4EBF53" : "#3F9C43"
                width: 23; height: 23

                Behavior on color {
                    ColorAnimation {
                        duration: 100
                    }
                }

                Rectangle {
                    anchors.centerIn: parent
                    color: "white"
                    width: 9; height: 2
                }
            }

            DropShadow {
                anchors.fill: wndBtn3
                source: wndBtn3
                radius: 5
                color: "black"
            }
        }

        Item {
            width: 23; height: 23

            MouseArea {
                id: wndBtnArea2
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    toogleMaximized()
                }
            }

            Rectangle {
                id: wndBtn2
                radius: 50
                color: wndBtnArea2.containsMouse ? "#AC6AFF" : "#934AF0"
                width: 23; height: 23

                Behavior on color {
                    ColorAnimation {
                        duration: 100
                    }
                }

                Rectangle {
                    anchors.centerIn: parent
                    color: "transparent"
                    width: 9; height: 9
                    border.color: "white"
                    border.width: 1
                }
            }

            DropShadow {
                anchors.fill: wndBtn2
                source: wndBtn2
                radius: 5
                color: "black"
            }
        }

        Item {
            width: 23; height: 23
            Rectangle {
                id: wndBtn
                radius: 50
                color: wndBtnArea.containsMouse ? "#FD1717" : "#E40000"
                width: 23; height: 23

                MouseArea {
                    id: wndBtnArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        rootWindow.close()
                    }
                }

                Behavior on color {
                    ColorAnimation {
                        duration: 100
                    }
                }

                Image {
                    id: wndBtnIcon1
                    width: 11
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/icons/Close.svg"
                }
            }

            DropShadow {
                anchors.fill: wndBtn
                source: wndBtn
                radius: 5
                color: "black"
            }
        }
    }
}
