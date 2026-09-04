import QtQuick
import QtQuick.Layouts
import Quickshell.Networking

import qs.Services
import qs.Components
import qs.Modules.Settings.Common

ColumnLayout {
  id: root

  readonly property WifiDevice device: Networking.devices.values.find(device => device.type === DeviceType.Wifi) || null
  readonly property alias count: repeater.count

  property WifiNetwork selectedNetwork: null
  property WifiNetwork promptedNetwork: null
  property string password: ""

  Layout.fillWidth: true

  spacing: 0

  onSelectedNetworkChanged: {
    if (root.selectedNetwork !== root.promptedNetwork) root.promptedNetwork = null;
  }

  onPromptedNetworkChanged: root.password = ""

  Binding {
    target: root.device
    property: "scannerEnabled"
    value: true
  }

  Repeater {
    id: repeater

    model: root.device ? root.device.networks.values : []

    SettingsCard {
      id: card

      required property WifiNetwork modelData

      property string error: ""

      readonly property bool selected: root.selectedNetwork === card.modelData
      readonly property bool prompting: root.promptedNetwork === card.modelData
      readonly property bool needsPassword: !card.modelData.known && card.modelData.security !== WifiSecurityType.Open && card.modelData.security !== WifiSecurityType.Owe

      function activate(): void {
        const network = card.modelData;

        card.error = "";

        if (network.connected) {
          network.disconnect();
          return;
        }

        if (card.prompting) {
          network.connectWithPsk(root.password);
          return;
        }

        if (card.needsPassword) {
          root.promptedNetwork = network;
          return;
        }

        network.connect();
      }

      onSelectedChanged: {
        if (!card.selected) card.error = "";
      }

      Connections {
        target: card.modelData

        function onConnectionFailed(reason: int): void {
          switch (reason) {
          case ConnectionFailReason.NoSecrets:
            card.error = "Wrong password";
            break;
          case ConnectionFailReason.WifiAuthTimeout:
            card.error = "Authentication timed out";
            break;
          case ConnectionFailReason.WifiNetworkLost:
            card.error = "Network lost";
            break;
          case ConnectionFailReason.WifiClientDisconnected:
            card.error = "Disconnected";
            break;
          default:
            card.error = "Connection failed";
          }

          if (!card.needsPassword) return;

          root.selectedNetwork = card.modelData;
          root.promptedNetwork = card.modelData;
        }

        function onConnectedChanged(): void {
          if (!card.modelData.connected) return;

          card.error = "";
          if (card.prompting) root.promptedNetwork = null;
        }
      }

      RowLayout {
        Layout.fillWidth: true

        spacing: ConfigService.spacing.horizontal / 2

        MesaIcon {
          Layout.alignment: Qt.AlignVCenter

          visible: card.modelData.connected
          name: "dot"
          color: ConfigService.colors.base0B
          size: ConfigService.font.size * 0.5
        }

        InfoValue {
          text: card.modelData.name
        }

        MesaIcon {
          Layout.alignment: Qt.AlignVCenter

          name: card.modelData.security === WifiSecurityType.Open || card.modelData.security === WifiSecurityType.Owe ? "lock-open" : "lock"
        }

        HoverHandler {
          cursorShape: Qt.PointingHandCursor
        }

        TapHandler {
          onTapped: root.selectedNetwork = card.selected ? null : card.modelData
        }
      }

      RowLayout {
        Layout.fillWidth: true

        visible: card.selected
        spacing: ConfigService.spacing.horizontal / 2

        MesaInput {
          id: passwordInput

          function restoreFocus(): void {
            if (!passwordInput.visible) return;

            passwordInput.forceActiveFocus();
            passwordInput.cursorPosition = passwordInput.text.length;
          }

          Layout.fillWidth: true

          visible: card.prompting
          echoMode: TextInput.Password
          placeholderText: "Password"
          text: root.password

          Keys.onEscapePressed: root.promptedNetwork = null

          onTextEdited: root.password = passwordInput.text
          onAccepted: card.activate()
          onVisibleChanged: passwordInput.restoreFocus()

          Component.onCompleted: Qt.callLater(passwordInput.restoreFocus)
        }

        MesaButton {
          Layout.alignment: Qt.AlignVCenter

          enabled: !card.modelData.stateChanging
          text: {
            switch (card.modelData.state) {
            case ConnectionState.Connecting: return "Connecting";
            case ConnectionState.Disconnecting: return "Disconnecting";
            default: return card.modelData.connected ? "Disconnect" : "Connect";
            }
          }

          onClicked: card.activate()
        }

        MesaButton {
          Layout.alignment: Qt.AlignVCenter

          visible: card.modelData.known && !card.prompting
          text: "Forget"

          onClicked: card.modelData.forget()
        }

        MesaButton {
          Layout.alignment: Qt.AlignVCenter

          visible: card.prompting
          text: "Cancel"

          onClicked: root.promptedNetwork = null
        }
      }

      InfoValue {
        visible: card.error !== ""

        text: card.error
        color: ConfigService.colors.base08
      }
    }
  }
}
