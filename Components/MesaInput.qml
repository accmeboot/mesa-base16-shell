import QtQuick
import QtQuick.Controls

import qs.Services

TextField {
  id: root

  color: ConfigService.colors.foreground
  font.family: ConfigService.font.name
  font.pointSize: ConfigService.font.size
  renderType: Text.NativeRendering

  placeholderTextColor: ConfigService.colors.on_surface
  selectionColor: ConfigService.colors.highlight
  selectedTextColor: ConfigService.colors.background

  leftPadding: ConfigService.spacing
  rightPadding: ConfigService.spacing

  background: Rectangle {
    color: "transparent"
    border.color: ConfigService.colors.on_surface
    border.width: ConfigService.border
  }
}
