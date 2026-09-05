import QtQuick

import qs.Services

MesaIcon {
  id: root

  property bool checked: false
  property bool radio: false

  signal toggled

  name: {
    if (root.radio) return root.checked ? "radio-button" : "radio-button-off";
    return root.checked ? "checkbox-on" : "checkbox-off";
  }
  size: Math.round(ConfigService.font.size * 1.5)
  color: {
    if (!root.enabled) return ConfigService.colors.on_surface;
    return root.checked ? ConfigService.colors.ok : ConfigService.colors.foreground;
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    onClicked: root.toggled()
  }
}
