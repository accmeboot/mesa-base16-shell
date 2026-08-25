import QtQuick

import qs.Services

Text {
  font.family: SettingsService.font.name
  font.pointSize: SettingsService.font.size
  color: SettingsService.colors.base05
  renderType: Text.NativeRendering
}
