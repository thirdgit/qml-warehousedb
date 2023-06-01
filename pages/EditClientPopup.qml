import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Popup {
    modal: true
    parent: Overlay.overlay
    anchors.centerIn: parent
    width: (parent.width / 3)

    signal clientEdit(clientName: string, clientPhone: string, clientAddress: string)

    function popup(_clientName, _clientPhone, _clientAddress) {
        nameField.text = _clientName
        phoneField.text = _clientPhone
        addressField.text = _clientAddress
        open()
    }

    ColumnLayout {
        anchors.fill: parent

        Label {
            text: "<b>Редактирование клиента</b>"
            Layout.alignment: Qt.AlignHCenter
        }

        Label {
            text: "Имя клиента:"
            Layout.leftMargin: 10
        }

        TextField {
            id: nameField
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10
        }

        Label {
            text: "Телефон клиента:"
            Layout.leftMargin: 10
        }

        TextField {
            id: phoneField
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10
        }

        Label {
            text: "Адрес клиента:"
            Layout.leftMargin: 10
        }

        TextField {
            id: addressField
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter

            Button {
                enabled: (nameField.length > 0)
                text: "Сохранить"
                onClicked: {
                    clientEdit(nameField.text, phoneField.text, addressField.text)
                    close()
                }
            }

            Button {
                text: "Отмена";
                onClicked: close()
            }
        }
    }
}
