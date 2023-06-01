import QtQuick 2.15
import QtQuick.Controls 2.15

Page {

    required property StackView stackView

    header: Rectangle {
        width: parent.width
        height: 80

        Label {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 20

            text: "<b>Клиенты</b>"
            font.pointSize: 24
        }

        Label {
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.bottom: parent.bottom

            text: "№"
            font.pointSize: 16
        }

        Label {
            anchors.left: parent.left
            anchors.leftMargin: 55
            anchors.bottom: parent.bottom

            text: "Имя"
            font.pointSize: 16
        }

        Label {
            anchors.left: parent.horizontalCenter
            anchors.bottom: parent.bottom

            text: "Контакты"
            font.pointSize: 16
        }

        ToolButton {
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 20

            icon.source: "qrc:/images/add.png"
            icon.height: 20
            icon.width: 20

            ToolTip.visible: hovered
            ToolTip.text: "Добавить клиента"

            onClicked: addClientPopup.open()
        }

        AddClientPopup {
            id: addClientPopup

            onClientCreate: (clientName, clientPhone, clientAddress) => {
                Models.addClient(clientName, clientPhone, clientAddress)
            }
        }
    }

    Component {
        id: clientsDelegate

        ItemDelegate {

            width: ListView.view.width
            height: 70

            Label {
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter

                text: `<b>${clientId}</b>`
                font.pointSize: 16
            }

            Label {
                anchors.left: parent.left
                anchors.leftMargin: 55
                anchors.verticalCenter: parent.verticalCenter

                text: clientName
                font.pointSize: 16
            }

            Label {
                anchors.top: parent.top
                anchors.left: parent.horizontalCenter
                anchors.topMargin: 5

                text: `<b>Телефон: </b>${clientPhone}<br><b>Адрес: </b>${clientAddress}`
                font.pointSize: 16
            }

            onClicked: editClientPopup.popup(clientName, clientPhone, clientAddress)

            EditClientPopup {
                id: editClientPopup

                onClientEdit: (_clientName, _clientPhone, _clientAddress) => {
                    Models.editClient(index, clientId, _clientName, _clientPhone, _clientAddress)
                }
            }
        }
    }

    ListView {
        anchors.fill: parent
        anchors.topMargin: 5

        clip: true
        spacing: 5

        model: Models.getClients()
        delegate: clientsDelegate
    }
}
