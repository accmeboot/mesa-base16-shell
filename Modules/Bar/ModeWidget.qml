import QtQuick
import Quickshell

import qs.Services
import qs.Components

Rectangle {
  visible: SwayService.mode === 'resize'

  color: SettingsService.colors.base0A

  implicitWidth: label.implicitWidth + 10
  implicitHeight: label.implicitHeight + 5

  MesaText {
    id: label
    anchors.centerIn: parent
    text: SwayService.mode
    color: SettingsService.colors.base00
  }
}

