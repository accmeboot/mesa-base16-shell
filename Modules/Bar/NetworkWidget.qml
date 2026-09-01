import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Networking

import qs.Components
import qs.Services

Rectangle {
  color: ConfigService.colors.base00

  implicitWidth: networkRow.implicitWidth + ConfigService.spacing.horizontal
  implicitHeight: networkRow.implicitHeight + ConfigService.spacing.vertical

  property var device: Networking.devices.values.find((d) => d.connected)

  RowLayout {
    id: networkRow
    anchors.centerIn: parent

    MesaText {
      text: "NET"
      color: ConfigService.colors.base05
    }

    MesaText {
      function getConnectedSsid() {
        const connectedWifi = device.networks.values
          .find((n) => n.state === ConnectionState.Connected)

        if (connectedWifi) return connectedWifi.name

        return "Disconnected"
      }

      text: {
        if (!device) return "N/A"

        if (device.type === DeviceType.Wifi) return getConnectedSsid() + " (wifi)"

        return device.name + " (wired)"
      }
    }
  }
}

