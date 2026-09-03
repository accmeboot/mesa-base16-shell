import QtQuick

import qs.Services

Rectangle {
  id: root
  property string text
  property string icon
  property int iconSize: Math.round(ConfigService.font.size * 1.5)
  property color contentColor: ConfigService.colors.base05
  property int maximumContentWidth: 0
  signal clicked
  implicitWidth: (root.icon ? iconLoader.implicitWidth : label.width) + ConfigService.spacing.horizontal
  implicitHeight: (root.icon ? iconLoader.implicitHeight : label.implicitHeight) + ConfigService.spacing.vertical
  color: ConfigService.colors.base02

  MesaText {
    id: label
    visible: !root.icon
    anchors.centerIn: parent
    width: root.maximumContentWidth > 0 ? Math.min(label.implicitWidth, root.maximumContentWidth) : label.implicitWidth
    text: root.text
    color: root.contentColor
    elide: Text.ElideRight
    textFormat: Text.StyledText
  }

  Loader {
    id: iconLoader
    anchors.centerIn: parent
    active: root.icon !== ""

    sourceComponent: MesaIcon {
      name: root.icon
      size: root.iconSize
      color: root.contentColor
    }
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: root.clicked()
  }
}
