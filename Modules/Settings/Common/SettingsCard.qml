import QtQuick
import QtQuick.Layouts

import qs.Services

Rectangle {
  id: root

  default property alias content: body.data

  Layout.fillWidth: true

  implicitHeight: body.implicitHeight + ConfigService.spacing.vertical * 2
  color: ConfigService.colors.base01

  ColumnLayout {
    id: body

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    anchors.leftMargin: ConfigService.spacing.horizontal / 2
    anchors.rightMargin: ConfigService.spacing.horizontal / 2

    spacing: ConfigService.spacing.vertical
  }
}
