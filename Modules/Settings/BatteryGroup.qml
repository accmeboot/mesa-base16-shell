import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

import qs.Services
import qs.Components

ColumnLayout {
  id: root

  readonly property UPowerDevice device: UPower.displayDevice
  readonly property bool available: root.device?.isLaptopBattery && root.device.isPresent
  readonly property int percentage: root.device ? Math.round(root.device.percentage * 100) : 0
  readonly property bool charging: root.device?.state === UPowerDeviceState.Charging || root.device?.state === UPowerDeviceState.PendingCharge
  readonly property real remaining: root.charging ? root.device.timeToFull : root.device?.timeToEmpty ?? 0

  Layout.fillWidth: true
  spacing: ConfigService.spacing.vertical

  component InfoRow: MesaText {
    Layout.fillWidth: true
    elide: Text.ElideRight
  }

  function formatDuration(seconds: real): string {
    const hours = Math.floor(seconds / 3600);
    const minutes = Math.round(seconds % 3600 / 60);

    return hours > 0 ? `${hours}h ${minutes}m` : `${minutes}m`;
  }

  Rectangle {
    visible: root.available
    Layout.fillWidth: true
    implicitHeight: content.implicitHeight + ConfigService.spacing.vertical * 2
    color: ConfigService.colors.base01

    GridLayout {
      id: content
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.verticalCenter: parent.verticalCenter
      anchors.leftMargin: ConfigService.spacing.horizontal / 2
      anchors.rightMargin: ConfigService.spacing.horizontal / 2
      columns: 2
      columnSpacing: ConfigService.spacing.horizontal
      rowSpacing: ConfigService.spacing.vertical / 2

      MesaText {
        Layout.alignment: Qt.AlignVCenter
        text: root.device?.model || "Battery"
        font.bold: true
      }

      InfoRow {
        Layout.alignment: Qt.AlignVCenter
        text: {
          switch (root.device?.state) {
          case UPowerDeviceState.Charging: return "Charging";
          case UPowerDeviceState.PendingCharge: return "Pending charge";
          case UPowerDeviceState.Discharging: return "On battery";
          case UPowerDeviceState.PendingDischarge: return "Pending discharge";
          case UPowerDeviceState.FullyCharged: return "Fully charged";
          case UPowerDeviceState.Empty: return "Empty";
          default: return "Unknown";
          }
        }
        color: {
          const colors = ConfigService.colors;

          switch (root.device?.state) {
          case UPowerDeviceState.Charging:
          case UPowerDeviceState.FullyCharged:
            return colors.base0B;
          case UPowerDeviceState.PendingCharge:
          case UPowerDeviceState.PendingDischarge:
            return colors.base0A;
          case UPowerDeviceState.Empty: return colors.base08;
          case UPowerDeviceState.Discharging: return colors.base05;
          default: return colors.base03;
          }
        }
      }

      MesaText {
        text: "Charge"
        color: ConfigService.colors.base04
      }

      InfoRow {
        text: `${root.percentage}%`
        color: ColorService.threshold(root.percentage, 50, 20)
      }

      MesaText {
        visible: healthRow.visible
        text: "Health"
        color: ConfigService.colors.base04
      }

      InfoRow {
        id: healthRow
        visible: root.device?.healthSupported ?? false
        text: `${Math.round(root.device?.healthPercentage ?? 0)}%`
      }

      MesaText {
        visible: remainingRow.visible
        text: root.charging ? "Until full" : "Remaining"
        color: ConfigService.colors.base04
      }

      InfoRow {
        id: remainingRow
        visible: root.remaining > 0
        text: root.formatDuration(root.remaining)
      }

      MesaText {
        visible: rateRow.visible
        text: "Power draw"
        color: ConfigService.colors.base04
      }

      InfoRow {
        id: rateRow
        visible: (root.device?.changeRate ?? 0) > 0
        text: `${root.device.changeRate.toFixed(1)} W`
      }
    }
  }
}
