import QtQuick
import QtQuick.Controls

import qs.Services

TextField {
  id: root

  color: ConfigService.colors.base05
  font.family: ConfigService.font.name
  font.pointSize: ConfigService.font.size
  renderType: Text.NativeRendering

  placeholderTextColor: ConfigService.colors.base03
  selectionColor: ConfigService.colors.base0D
  selectedTextColor: ConfigService.colors.base00

  leftPadding: ConfigService.spacing.horizontal / 2
  rightPadding: ConfigService.spacing.horizontal / 2
  topPadding: ConfigService.spacing.vertical / 2
  bottomPadding: ConfigService.spacing.vertical / 2

  background: Rectangle {
    color: ConfigService.colors.base02
  }
}
