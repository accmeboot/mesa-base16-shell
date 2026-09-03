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
      text: "System"
      font.bold: true
      color: ConfigService.colors.base04
    }

    SystemGroup {}
  }

  ColumnLayout {
    Layout.fillWidth: true
    spacing: ConfigService.spacing.vertical

    MesaText {
      text: "Battery"
      font.bold: true
      color: ConfigService.colors.base04
    }

    MesaText {
      visible: !battery.available
      text: "No battery"
      color: ConfigService.colors.base03
    }

    BatteryGroup {
      id: battery
    }
  }

  Item {
    Layout.fillHeight: true
  }
}
