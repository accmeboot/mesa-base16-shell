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

  Item {
    Layout.fillHeight: true
  }
}
