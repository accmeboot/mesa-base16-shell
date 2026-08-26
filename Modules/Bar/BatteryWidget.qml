import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower

import qs.Components
import qs.Services

Rectangle {
  color: SettingsService.colors.base00

  implicitWidth: batteryRow.implicitWidth + 20
  implicitHeight: batteryRow.implicitHeight + 5

  property UPowerDevice device: UPower.displayDevice
  property int percentage: device ? device.percentage * 100 : null

  RowLayout {
    id: batteryRow
    anchors.centerIn: parent

    MesaText {
      text: {
        switch (device.state) {
          case UPowerDeviceState.Charging:
          return getChargingIconByPercentage();
          case UPowerDeviceState.FullyCharged:
          return "󰂅";
          case UPowerDeviceState.Unknown:
          case UPowerDeviceState.PendingCharge:
          return "";
          case UPowerDeviceState.Discharging:
          case UPowerDeviceState.PendingDischarge:
          case UPowerDeviceState.Empty:
          default:
          return getIconByPercentage();
        }
      }
      color: {
        if (percentage <= 20) {
          return SettingsService.colors.base08
        }

        if (device.state === UPowerDeviceState.Unknown || device.state === UPowerDeviceState.PendingCharge) {
          return SettingsService.colors.base0B
        }

        return SettingsService.colors.base05
      }
    }

    MesaText {
      text: percentage + "%"
    }
  }

  function getIconByPercentage() {
    switch (true) {
      case percentage >= 90:
      return "󰁹";
      case percentage >= 80:
      return "󰂂";
      case percentage >= 70:
      return "󰂁";
      case percentage >= 60:
      return "󰂀";
      case percentage >= 50:
      return "󰁿";
      case percentage >= 40:
      return "󰁾";
      case percentage >= 30:
      return "󰁽";
      case percentage >= 20:
      return "󰁼";
      case percentage >= 10:
      return "󰁻";
      default:
      return "󰁺";
    }
  }

  function getChargingIconByPercentage() {
    switch (true) {
      case percentage >= 90:
      return "󰂋";
      case percentage >= 80:
      return "󰂊";
      case percentage >= 70:
      return "󰂉";
      case percentage >= 60:
      return "󰢞";
      case percentage >= 50:
      return "󰂈";
      case percentage >= 40:
      return "󰂇";
      case percentage >= 30:
      return "󰂆";
      case percentage >= 20:
      return "󰢝";
      case percentage >= 10:
      return "󰢜";
      default:
      return "󰢟";
    }
  }
}

