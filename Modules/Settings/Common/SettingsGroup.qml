import QtQuick
import QtQuick.Layouts

import qs.Services
import qs.Components

ColumnLayout {
  id: root

  property string title
  property Component headerContent: null

  default property alias content: body.data

  Layout.fillWidth: true

  spacing: ConfigService.spacing

  RowLayout {
    Layout.fillWidth: true

    spacing: ConfigService.spacing

    MesaText {
      Layout.alignment: Qt.AlignVCenter

      text: root.title
      font.bold: true
    }

    Item {
      Layout.fillWidth: true
    }

    Loader {
      Layout.alignment: Qt.AlignVCenter

      active: root.headerContent !== null
      sourceComponent: root.headerContent
    }
  }

  ColumnLayout {
    id: body

    Layout.fillWidth: true

    spacing: ConfigService.spacing
  }
}
