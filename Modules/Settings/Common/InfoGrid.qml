import QtQuick.Layouts

import qs.Services

GridLayout {
  Layout.fillWidth: true

  columns: 2
  columnSpacing: ConfigService.spacing.horizontal
  rowSpacing: ConfigService.spacing.vertical / 2
}
