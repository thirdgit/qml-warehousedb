import QtQuick
import QtQuick.Controls

ToolBar {
    id: root

    height: 45
    width: parent.width

    required property StackView stackView

    ToolButton {
        enabled: root.stackView.depth >= 2
        visible: root.stackView.depth >= 2

        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.verticalCenter: parent.verticalCenter

        icon.source: "images/back.png"
        icon.height: 20
        icon.width: 20

        onClicked: root.stackView.pop()
    }

    Label {
        text: "<b>Управление складом</b>"
        font.pointSize: 18
        anchors.centerIn: parent
    }
}
