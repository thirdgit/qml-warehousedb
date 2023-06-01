import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Popup {
    modal: true
    parent: Overlay.overlay
    anchors.centerIn: parent
    width: (parent.width / 3)

    signal itemAdd(materialIndex: int, materialCount: int, materialPrice: double)

    function popup() {
        materialsCombo.currentIndex = -1
        countField.text = ""
        open()
    }

    property bool dataIsValid: false
    function doValidate() {
        let count = parseInt(countField.text)
        let price = parseInt(priceField.text)
        dataIsValid = (materialsCombo.currentIndex !== -1) && (!isNaN(count) && count > 0) && (!isNaN(price) && price > 0)
    }

    ColumnLayout {
        anchors.fill: parent

        Label {
            text: "<b>Добавление позиции</b>"
            Layout.alignment: Qt.AlignHCenter
        }

        Label {
            text: "Материал:"
            Layout.leftMargin: 10
        }

        ComboBox {
            id: materialsCombo

            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10

            textRole: "matText"
            currentIndex: -1

            onCurrentIndexChanged: {
                priceField.clear()
                countField.clear()
            }

            model: ListModel {
                Component.onCompleted: Models.fillMaterialsCombo(this)
            }
        }

        Label {
            visible: materialsCombo.currentIndex !== -1
            text: "Стоимость:"
            Layout.leftMargin: 10
        }

        TextField {
            id: priceField
            visible: materialsCombo.currentIndex !== -1
            enabled: visible
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            onTextChanged: doValidate()
        }

        Label {
            visible: materialsCombo.currentIndex !== -1
            text: "Количество:"
            Layout.leftMargin: 10
        }

        TextField {
            id: countField
            visible: materialsCombo.currentIndex !== -1
            enabled: visible
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
                    itemAdd(materialsCombo.currentIndex, parseInt(countField.text), parseInt(priceField.text))
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
