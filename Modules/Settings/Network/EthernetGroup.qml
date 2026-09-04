import QtQuick
import QtQuick.Layouts
import Quickshell.Networking

import qs.Services
import qs.Components
import qs.Modules.Settings.Common

ColumnLayout {
  id: root

  readonly property var devices: Networking.devices.values.filter(device => device.type === DeviceType.Wired)
  readonly property alias count: repeater.count

  Layout.fillWidth: true

  spacing: ConfigService.spacing.vertical

  Repeater {
    id: repeater

    model: root.devices

    SettingsCard {
      id: card

      required property WiredDevice modelData

      InfoGrid {
        MesaText {
          Layout.alignment: Qt.AlignVCenter

          text: card.modelData.name
          font.bold: true
        }

        RowLayout {
          Layout.fillWidth: true

          spacing: ConfigService.spacing.horizontal / 2

          InfoValue {
            text: {
              if (!card.modelData.hasLink) return "No cable";

              switch (card.modelData.state) {
              case ConnectionState.Connected: return "Connected";
              case ConnectionState.Connecting: return "Connecting";
              case ConnectionState.Disconnecting: return "Disconnecting";
              case ConnectionState.Disconnected: return "Disconnected";
              default: return "Unknown";
              }
            }
            color: {
              const colors = ConfigService.colors;

              if (!card.modelData.hasLink) return colors.base03;

              switch (card.modelData.state) {
              case ConnectionState.Connecting:
              case ConnectionState.Disconnecting:
                return colors.base0A;
              default:
                return ColorService.status(card.modelData.connected);
              }
            }
          }

          MesaButton {
            id: connectButton

            readonly property Network network: card.modelData.network

            Layout.alignment: Qt.AlignVCenter

            visible: card.modelData.connected || connectButton.network !== null
            enabled: !(connectButton.network && connectButton.network.stateChanging)
            text: card.modelData.connected ? "Disconnect" : "Connect"

            onClicked: {
              if (card.modelData.connected) card.modelData.disconnect();
              else connectButton.network.connect();
            }
          }
        }

        InfoLabel {
          visible: macAddress.visible

          text: "MAC"
        }

        InfoValue {
          id: macAddress

          visible: card.modelData.address !== ""

          text: card.modelData.address
        }

        InfoLabel {
          visible: link.visible

          text: "Link"
        }

        InfoValue {
          id: link

          visible: card.modelData.hasLink && card.modelData.linkSpeed > 0

          text: `${card.modelData.linkSpeed} Mbps`
        }

        InfoLabel {
          Layout.topMargin: ConfigService.spacing.vertical

          text: "Autoconnect"
        }

        MesaButton {
          Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
          Layout.topMargin: ConfigService.spacing.vertical

          text: card.modelData.autoconnect ? "on" : "off"
          contentColor: card.modelData.autoconnect ? ConfigService.colors.base0B : ConfigService.colors.base04

          onClicked: card.modelData.autoconnect = !card.modelData.autoconnect
        }
      }
    }
  }
}
