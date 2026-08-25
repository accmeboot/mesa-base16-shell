import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Networking

import qs.Components
import qs.Services

Rectangle {
  color: SettingsService.colors.base00

  implicitWidth: networkRow.implicitWidth + 20
  implicitHeight: networkRow.implicitHeight + 5

  property var device: Networking.devices.values.find((d) => d.connected)

  RowLayout {
    id: networkRow
    anchors.centerIn: parent

    MesaText {
      text: {
        if (!device) return "󰌙"

        if (device.type === DeviceType.Wifi) {
          return "󰤨"
        }

        return "󰲝"
      }
    }

    MesaText {
      function getConnectedSsid() {
        const connectedWifi = device.networks.values
          .find((n) => n.state === ConnectionState.Connected)

        if (connectedWifi) return connectedWifi.name

        return "Disconnected"
      }

      text: {
        if (!device) return "Disconnected"

        if (device.type === DeviceType.Wifi) return getConnectedSsid()

        return device.name
      }
    }
  }
}

