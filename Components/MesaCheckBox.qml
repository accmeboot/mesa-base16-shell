import QtQuick

import qs.Services

Item {
  id: root

  property bool checked: false
  property bool radio: false
  property string text
  property int horizontalPadding: ConfigService.spacing
  property int verticalPadding: ConfigService.spacing
  property color contentColor: root.checked ? ConfigService.colors.ok : ConfigService.colors.foreground

  readonly property color effectiveContentColor: root.enabled ? root.contentColor : ConfigService.colors.on_surface

  signal toggled

  implicitWidth: content.implicitWidth + root.horizontalPadding
  implicitHeight: content.implicitHeight + root.verticalPadding

  Row {
    id: content

    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    spacing: ConfigService.spacing

    MesaIndicator {
      anchors.verticalCenter: parent.verticalCenter
      checked: root.checked
      radio: root.radio
      color: root.effectiveContentColor
    }

    MesaText {
      id: label

      visible: root.text !== ""
      text: root.text
      color: root.effectiveContentColor
    }
  }

  MouseArea {
    id: mouseArea

    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: root.toggled()
  }
}
