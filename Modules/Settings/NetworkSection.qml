import QtQuick
import QtQuick.Layouts

import qs.Services
import qs.Components

ColumnLayout {
  id: root

  spacing: ConfigService.spacing.vertical * 3

  ColumnLayout {
    Layout.fillWidth: true
    spacing: ConfigService.spacing.vertical

    MesaText {
      text: "Ethernet"
      font.bold: true
      color: ConfigService.colors.base04
    }

    MesaText {
      visible: ethernet.devices.length === 0
      text: "No wired devices"
      color: ConfigService.colors.base03
    }

    EthernetGroup {
      id: ethernet
    }
  }

  ColumnLayout {
    Layout.fillWidth: true
    Layout.fillHeight: true
    spacing: ConfigService.spacing.vertical

    MesaText {
      text: "Wifi"
      font.bold: true
      color: ConfigService.colors.base04
    }

    MesaText {
      visible: wifi.count === 0
      text: "No networks"
      color: ConfigService.colors.base03
    }

    WifiGroup {
      id: wifi
    }
  }
}
