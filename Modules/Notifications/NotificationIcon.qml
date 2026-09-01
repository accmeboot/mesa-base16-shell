import QtQuick
import Qt5Compat.GraphicalEffects

import qs.Services

Item {
    implicitWidth: 60
    implicitHeight: 60

    Image {
        id: img
        anchors.fill: parent
        source: './notification.svg'
        width: parent.implicitWidth
        height: parent.implicitHeight
        sourceSize: Qt.size(parent.implicitWidth, parent.implicitHeight)
    }

    ColorOverlay {
        anchors.fill: parent
        source: img
        color: ConfigService.colors.base05
    }
}
