import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Networking

import qs.Components
import qs.Services

Rectangle {
  id: root

  color: ConfigService.colors.base00

  implicitWidth: networkRow.implicitWidth + ConfigService.spacing.horizontal
  implicitHeight: networkRow.implicitHeight + ConfigService.spacing.vertical

  property var device: Networking.devices.values.find((d) => d.connected)

  readonly property string ssid: {
    if (!device || device.type !== DeviceType.Wifi) return ""

    const connectedWifi = device.networks.values
      .find((n) => n.state === ConnectionState.Connected)

    return connectedWifi ? connectedWifi.name : ""
  }

  readonly property bool connected: {
    if (!device) return false

    if (device.type === DeviceType.Wifi) return ssid !== ""

    return true
  }

  RowLayout {
    id: networkRow
    anchors.centerIn: parent

    MesaText {
      text: "NET"
      color: ColorService.status(root.connected)
    }

    MesaText {
      text: {
        if (!root.device) return "N/A"

        if (root.device.type === DeviceType.Wifi) return root.connected ? root.ssid + " (wifi)" : "Disconnected"

        return root.device.name + " (wired)"
      }
    }
  }
}
