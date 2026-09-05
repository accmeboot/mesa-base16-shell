import QtQuick.Layouts

import qs.Services
import qs.Modules.Settings.Common

ColumnLayout {
  id: root

  spacing: ConfigService.spacing * 3

  SettingsGroup {
    title: "Ethernet"
    visible: ethernet.count > 0

    EthernetGroup {
      id: ethernet
    }
  }

  SettingsGroup {
    title: "Wifi"
    visible: wifi.count > 0

    WifiGroup {
      id: wifi
    }
  }
}
