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
      text: "Adapter"
      font.bold: true
      color: ConfigService.colors.base04
    }

    MesaText {
      visible: adapter.adapters.length === 0
      text: "No bluetooth adapters"
      color: ConfigService.colors.base03
    }

    BluetoothAdapterGroup {
      id: adapter
    }
  }

  ColumnLayout {
    Layout.fillWidth: true
    Layout.fillHeight: true
    spacing: ConfigService.spacing.vertical

    RowLayout {
      Layout.fillWidth: true
      spacing: ConfigService.spacing.horizontal / 2

      MesaText {
        Layout.alignment: Qt.AlignVCenter
        text: "Devices"
        font.bold: true
        color: ConfigService.colors.base04
      }

      Item {
        Layout.fillWidth: true
      }

      MesaText {
        Layout.alignment: Qt.AlignVCenter
        visible: devices.scanning
        text: "Scanning"
        color: ConfigService.colors.base0A
      }

      MesaButton {
        Layout.alignment: Qt.AlignVCenter
        enabled: devices.adapter !== null && devices.adapter.enabled
        icon: "search-plus"
        contentColor: {
          const colors = ConfigService.colors;

          if (!devices.adapter || !devices.adapter.enabled) return colors.base03;
          return devices.scanning ? colors.base0B : colors.base05;
        }
        onClicked: devices.scanRequested = !devices.scanRequested
      }
    }

    MesaText {
      visible: devices.count === 0
      text: devices.scanning ? "Searching" : "No devices"
      color: ConfigService.colors.base03
    }

    BluetoothDeviceGroup {
      id: devices
    }
  }
}
