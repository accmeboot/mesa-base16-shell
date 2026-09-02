import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.Services
import qs.Components

ColumnLayout {
  id: rootRow
  property var sections: ["Audio", "Network", "Bluetooth", "About"]
  property string activeSection: sections[0]
  spacing: 0
  Rectangle {
    id: contentRectangle
    Layout.fillHeight: true
    Layout.fillWidth: true
    color: "transparent"
    Loader {
      anchors.fill: parent
      anchors.margins: ConfigService.spacing.horizontal / 2
      source: `${rootRow.activeSection}Section.qml`
    }
  }

  Rectangle {
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignTop
    color: ConfigService.colors.base01
    implicitWidth: sectionCulumn.width
    implicitHeight: sectionCulumn.height
    RowLayout {
      id: sectionCulumn
      anchors.centerIn: parent
      Repeater {
        model: sections
        Rectangle {
          required property string modelData
          implicitWidth: sectionText.implicitWidth + ConfigService.spacing.horizontal
          implicitHeight: sectionText.implicitHeight + ConfigService.spacing.vertical
          Layout.fillWidth: true
          color: activeSection === modelData ? ConfigService.colors.base0D : "transparent"
          MesaText {
            id: sectionText
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: ConfigService.spacing.horizontal / 2
            anchors.topMargin: ConfigService.spacing.vertical / 2
            text: modelData
            color: activeSection === modelData ? ConfigService.colors.base00 : ConfigService.colors.base05
          }

          MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: activeSection = modelData
          }
        }
      }
    }
  }
}
