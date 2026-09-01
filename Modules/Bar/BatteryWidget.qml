import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower

import qs.Components
import qs.Services

Rectangle {
  color: ConfigService.colors.base00

  implicitWidth: batteryRow.implicitWidth + ConfigService.spacing.horizontal
  implicitHeight: batteryRow.implicitHeight + ConfigService.spacing.vertical

  property UPowerDevice device: UPower.displayDevice
  property int percentage: device ? device.percentage * 100 : null

  visible: device.isLaptopBattery

  RowLayout {
    id: batteryRow
    anchors.centerIn: parent

    MesaText {
      text: "BAT"
      color: {
        if (percentage <= 20) {
          return ConfigService.colors.base08
        }

        if (device.state === UPowerDeviceState.Unknown || device.state === UPowerDeviceState.PendingCharge) {
          return ConfigService.colors.base0B
        }

        return ConfigService.colors.base05
      }
    }

    MesaText {
      text: percentage + "%"
    }
  }
}

