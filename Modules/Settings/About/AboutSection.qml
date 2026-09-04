import QtQuick.Layouts

import qs.Services
import qs.Modules.Settings.Common

ColumnLayout {
  id: root

  spacing: ConfigService.spacing * 3

  SettingsGroup {
    title: "System"

    SystemGroup {}
  }

  SettingsGroup {
    title: "Battery"
    emptyText: "No battery"
    empty: !battery.available

    BatteryGroup {
      id: battery
    }
  }
}
