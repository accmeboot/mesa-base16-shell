import QtQuick.Layouts

import qs.Services

GridLayout {
  Layout.fillWidth: true

  columns: 2
  columnSpacing: ConfigService.spacing * 2
  rowSpacing: ConfigService.spacing / 2
}
