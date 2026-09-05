import QtQuick
import QtQuick.Layouts
import Quickshell.Bluetooth

import qs.Services
import qs.Components
import qs.Modules.Settings.Common

ColumnLayout {
  id: root

  readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter
  readonly property var devices: Bluetooth.devices.values
  readonly property var paired: root.devices.filter(device => device.paired).sort((a, b) => {
    if (a.connected !== b.connected) return a.connected ? -1 : 1;

    return a.name.localeCompare(b.name);
  })
  readonly property var available: root.devices.filter(device => !device.paired && device.deviceName !== "")
  readonly property var listed: root.scanning ? root.paired.concat(root.available) : root.paired
  readonly property bool scanning: root.adapter !== null && root.adapter.discovering
  readonly property alias count: repeater.count

  property BluetoothDevice selectedDevice: null
  property BluetoothDevice pairingDevice: null

  Layout.fillWidth: true

  spacing: ConfigService.border

  Component.onDestruction: if (root.adapter) root.adapter.discovering = false

  Binding {
    target: root.adapter
    property: "discovering"
    value: true
    when: root.adapter?.state === BluetoothAdapterState.Enabled
    restoreMode: Binding.RestoreNone
  }

  BluetoothAgent {
    id: pairingAgent
  }

  Connections {
    target: root.pairingDevice

    function onPairedChanged(): void {
      const device = root.pairingDevice;

      if (!device || !device.paired) return;

      device.trusted = true;
      root.pairingDevice = null;
    }
  }

  Repeater {
    id: repeater

    model: root.listed

    SettingsCard {
      id: card

      required property BluetoothDevice modelData

      readonly property bool selected: root.selectedDevice === card.modelData

      highlighted: card.selected

      RowLayout {
        Layout.fillWidth: true

        spacing: ConfigService.spacing

        HoverHandler {
          cursorShape: Qt.PointingHandCursor
        }

        TapHandler {
          onTapped: root.selectedDevice = card.selected ? null : card.modelData
        }

        MesaIcon {
          Layout.alignment: Qt.AlignVCenter

          visible: card.modelData.connected
          name: "dot"
          color: ConfigService.colors.ok
          size: ConfigService.font.size * 0.5
        }

        InfoValue {
          text: card.modelData.name
        }

        MesaText {
          Layout.alignment: Qt.AlignVCenter

          visible: card.modelData.connected && card.modelData.batteryAvailable
          text: `${Math.round(card.modelData.battery * 100)}%`
          color: ColorService.threshold(card.modelData.battery * 100, 30, 15)
        }

        MesaText {
          Layout.alignment: Qt.AlignVCenter

          text: {
            if (card.modelData.pairing) return "Pairing";
            if (!card.modelData.paired) return "Not paired";

            switch (card.modelData.state) {
            case BluetoothDeviceState.Connected: return "Connected";
            case BluetoothDeviceState.Connecting: return "Connecting";
            case BluetoothDeviceState.Disconnecting: return "Disconnecting";
            default: return "Disconnected";
            }
          }
          color: {
            const colors = ConfigService.colors;

            if (card.modelData.pairing) return colors.attention;
            if (!card.modelData.paired) return colors.foreground;

            switch (card.modelData.state) {
            case BluetoothDeviceState.Connected: return colors.ok;
            case BluetoothDeviceState.Connecting:
            case BluetoothDeviceState.Disconnecting:
              return colors.attention;
            default: return colors.foreground;
            }
          }
        }
      }

      InfoGrid {
        visible: card.selected

        InfoLabel {
          text: "Address"
        }

        InfoValue {
          text: card.modelData.address
        }

        InfoLabel {
          visible: card.modelData.paired

          text: "Connect automatically"
        }

        MesaCheckBox {
          Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

          visible: card.modelData.paired
          checked: card.modelData.trusted

          onToggled: card.modelData.trusted = !card.modelData.trusted
        }

        InfoLabel {
          visible: card.modelData.paired

          text: "Wake from sleep"
        }

        MesaCheckBox {
          Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

          visible: card.modelData.paired
          checked: card.modelData.wakeAllowed

          onToggled: card.modelData.wakeAllowed = !card.modelData.wakeAllowed
        }
      }

      RowLayout {
        Layout.fillWidth: true

        visible: card.selected
        spacing: ConfigService.spacing

        MesaButton {
          Layout.alignment: Qt.AlignVCenter

          visible: card.modelData.paired
          enabled: card.modelData.state === BluetoothDeviceState.Connected || card.modelData.state === BluetoothDeviceState.Disconnected
          text: card.modelData.connected ? "Disconnect" : "Connect"

          onClicked: {
            if (card.modelData.connected) card.modelData.disconnect();
            else card.modelData.connect();
          }
        }

        MesaButton {
          Layout.alignment: Qt.AlignVCenter

          visible: card.modelData.paired
          text: "Forget"

          onClicked: {
            if (card.selected) root.selectedDevice = null;
            card.modelData.forget();
          }
        }

        MesaButton {
          Layout.alignment: Qt.AlignVCenter

          visible: !card.modelData.paired
          enabled: pairingAgent.registered
          text: card.modelData.pairing ? "Cancel" : "Pair"
          contentColor: card.modelData.pairing ? ConfigService.colors.attention : ConfigService.colors.foreground

          onClicked: {
            if (card.modelData.pairing) {
              card.modelData.cancelPair();
              root.pairingDevice = null;
              return;
            }

            root.pairingDevice = card.modelData;
            card.modelData.pair();
          }
        }
      }
    }
  }
}
