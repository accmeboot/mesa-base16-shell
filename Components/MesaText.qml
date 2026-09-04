import QtQuick

import qs.Services

Text {
  font.family: ConfigService.font.name
  font.pointSize: ConfigService.font.size
  color: ConfigService.colors.foreground
  renderType: Text.NativeRendering
}
