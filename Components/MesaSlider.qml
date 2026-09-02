import QtQuick
import QtQuick.Controls

import qs.Services

Slider {
  id: root

  property int handleSize: Math.round(ConfigService.font.size * 1.0)

  from: 0
  to: 1

  background: Item {
    implicitWidth: 140
    implicitHeight: root.handleSize

    Rectangle {
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.verticalCenter: parent.verticalCenter

      implicitHeight: 2

      color: ConfigService.colors.base02

      Rectangle {
        width: root.visualPosition * parent.width
        height: parent.height

        color: ConfigService.colors.base0D
      }
    }
  }

  handle: Rectangle {
    x: root.leftPadding + root.visualPosition * (root.availableWidth - width)
    anchors.verticalCenter: parent.verticalCenter

    implicitWidth: root.handleSize
    implicitHeight: root.handleSize

    radius: width / 2

    color: ConfigService.colors.base05
  }

  HoverHandler {
    cursorShape: Qt.PointingHandCursor
  }
}
