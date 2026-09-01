import QtQuick
import Quickshell

import qs.Services
import qs.Components

Rectangle {
  visible: SwayService.mode === 'resize'

  color: ConfigService.colors.base0A

  implicitWidth: label.implicitWidth + 10
  implicitHeight: label.implicitHeight + 5

  MesaText {
    id: label
    anchors.centerIn: parent
    text: SwayService.mode
    color: ConfigService.colors.base00
  }
}

