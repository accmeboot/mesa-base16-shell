import QtQuick
import QtQuick.Layouts

import qs.Services

Rectangle {
  id: root

  default property alias content: body.data

  Layout.fillWidth: true

  implicitHeight: body.implicitHeight + ConfigService.spacing * 2
  color: ConfigService.colors.surface

  ColumnLayout {
    id: body

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    anchors.leftMargin: ConfigService.spacing
    anchors.rightMargin: ConfigService.spacing

    spacing: ConfigService.spacing
  }
}
