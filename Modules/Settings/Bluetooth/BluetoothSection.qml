import QtQuick.Layouts

import qs.Services
import qs.Components
import qs.Modules.Settings.Common

ColumnLayout {
  id: root

  spacing: ConfigService.spacing * 3

  SettingsGroup {
    title: "Adapter"
    visible: adapters.count > 0

    BluetoothAdapterGroup {
      id: adapters
    }
  }

  SettingsGroup {
    title: "Devices"
    visible: devices.count > 0

    headerContent: MesaText {
      visible: devices.scanning
      text: "Scanning"
      color: ConfigService.colors.attention
    }

    BluetoothDeviceGroup {
      id: devices
    }
  }
}
