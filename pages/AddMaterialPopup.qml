import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Popup {
    modal: true
    parent: Overlay.overlay
    anchors.centerIn: parent
    width: (parent.width / 3)

    signal materialCreate(materialTitle: string, materialPrice: double, materialCount: int)

    property bool dataIsValid: false
    function doValidate() {
        let price = parseInt(priceField.text)
        let count = parseInt(countField.text)
        dataIsValid = (titleField.length > 2) && (!isNaN(price)) && (!isNaN(count)) && (price >= 0) && (count >= 0)
    }

    ColumnLayout {
        anchors.fill: parent

        Label {
            text: "<b>Добавление материала</b>"
            Layout.alignment: Qt.AlignHCenter
        }

        Label {
            text: "Название материала:"
            Layout.leftMargin: 10
        }

        TextField {
            id: titleField
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            onTextChanged: doValidate()
        }

        Label {
            text: "Стоимость материала:"
            Layout.leftMargin: 10
        }

        TextField {
            id: priceField
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            onTextChanged: doValidate()
        }

        Label {
            text: "Остаток материала:"
            Layout.leftMargin: 10
        }

        TextField {
            id: countField
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            onTextChanged: doValidate()
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter

            Button {
                enabled: dataIsValid
                text: "Добавить"
                onClicked: {
                    materialCreate(titleField.text, priceField.text, countField.text)
                    titleField.text = ""
                    priceField.text = ""
                    countField.text = ""
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
