import QtQuick
import QtQuick.Window
import QtQuick.Controls.Fusion

ApplicationWindow {
    visible: true

    minimumWidth: 800
    minimumHeight: 600

    title: "Warehouse DB"

    header: NavBar {
        stackView: stackView
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: HomePage {}
    }
}
