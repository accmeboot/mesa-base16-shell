import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower

import qs.Components
import qs.Services

Rectangle {
  id: root

  color: ConfigService.colors.base00

  implicitWidth: batteryRow.implicitWidth + ConfigService.spacing.horizontal
  implicitHeight: batteryRow.implicitHeight + ConfigService.spacing.vertical

  property UPowerDevice device: UPower.displayDevice
  property int percentage: device ? device.percentage * 100 : null

  visible: device.isLaptopBattery

  readonly property string status: {
    switch (device.state) {
    case UPowerDeviceState.Charging:
    case UPowerDeviceState.PendingCharge:
      return "charging"
    case UPowerDeviceState.FullyCharged:
      return "full"
    case UPowerDeviceState.Empty:
      return "empty"
    case UPowerDeviceState.Discharging:
    case UPowerDeviceState.PendingDischarge:
      return "on battery"
    }

    return "unknown"
  }

  RowLayout {
    id: batteryRow
    anchors.centerIn: parent

    MesaText {
      text: "BAT"
      color: ColorService.threshold(root.percentage, 50, 20)
    }

    MesaText {
      text: root.percentage + "% (" + root.status + ")"
    }
  }
}

