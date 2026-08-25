import QtQuick
import Quickshell

import "./services"

Rectangle {
  visible: SwayService.mode === 'resize'

  color: Settings.colors.base0A

  implicitWidth: label.implicitWidth + 11
  implicitHeight: label.implicitHeight + 6

  MesaText {
    id: label
    anchors.centerIn: parent
    text: SwayService.mode
    color: Settings.colors.base00
  }
}

