import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

Item {
    default property alias data: inner_space.data
    property alias visibility: popupTooltip.visible
    property alias xPopup: popupTooltip.x
    property alias yPopup: popupTooltip.y

    implicitWidth: popupTooltip.implicitWidth
    implicitHeight: popupTooltip.implicitWidth

    Popup {
        id: popupTooltip
        contentItem: Item {
            id: inner_space
        }

        background: Item {
            Rectangle {
                id: tooltipRect
                anchors.fill: parent
                color: "#232323"
                radius: 4
            }

            DropShadow {
                anchors.fill: tooltipRect
                source: tooltipRect
                radius: 4
                horizontalOffset: 0
                verticalOffset: 0
            }
        }

        enter: Transition {
            ParallelAnimation {
                NumberAnimation {
                    property: "opacity";
                    from: 0.0;
                    to: 1.0;
                    //easing.type: Easing.InElastic;
                    duration: 200
                }
                NumberAnimation {
                    property: "scale";
                    from: 0.4;
                    to: 1.0;
                    easing.type: Easing.OutBack
                    duration: 200
                }
            }
        }
        exit: Transition {
            ParallelAnimation {
                NumberAnimation {
                    property: "opacity";
                    from: 1.0
                    to: 0.0;
                    duration: 200
                }
                NumberAnimation {
                    property: "scale";
                    from: 1.0
                    to: 0.8;
                    duration: 200
                }
            }
        }
    }
}
