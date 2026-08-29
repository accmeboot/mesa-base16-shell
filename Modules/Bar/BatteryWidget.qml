import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower

import qs.Components
import qs.Services

Rectangle {
  color: SettingsService.colors.base00

  implicitWidth: batteryRow.implicitWidth + SettingsService.spacing.horizontal
  implicitHeight: batteryRow.implicitHeight + SettingsService.spacing.vertical

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
          return SettingsService.colors.base08
        }

        if (device.state === UPowerDeviceState.Unknown || device.state === UPowerDeviceState.PendingCharge) {
          return SettingsService.colors.base0B
        }

        return SettingsService.colors.base0A
      }
    }

    MesaText {
      text: percentage + "%"
    }
  }
}

