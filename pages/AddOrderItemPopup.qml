import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Popup {
    modal: true
    parent: Overlay.overlay
    anchors.centerIn: parent
    width: (parent.width / 3)

    signal itemAdd(materialIndex: int, materialCount: int)

    function popup() {
        materialsCombo.currentIndex = -1
        countField.text = ""
        maxCount = -1
        open()
    }

    property int  maxCount: -1
    property bool dataIsValid: false
    function doValidate() {
        let count = parseInt(countField.text)
        dataIsValid = (materialsCombo.currentIndex !== -1) && (!isNaN(count)) && (count > 0 && count <= maxCount)
    }

    function countAvailableItems(materialId) {
        let count = 0;
        for (let i = 0; i < Models.getMaterials().count; ++i) {
            let item = Models.getMaterials().get(i)
            if (item.materialId !== materialId)
                continue;
            count = item.materialCount;
            break;
        }
        for (let j = 0; j < orderItemsModel.count; ++j) {
            let item = orderItemsModel.get(j)
            if (item.mat_id !== materialId)
                continue;
            count -= item.mat_count;
        }
        return count;
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
                countField.clear()
                if (currentIndex !== -1)
                    maxCount = countAvailableItems(model.get(currentIndex).matId)
            }

            model: ListModel {
                Component.onCompleted: Models.fillMaterialsCombo(this)
            }
        }

        RowLayout {
            visible: maxCount != -1
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10

            Label {
                text: `Количество:`
                Layout.fillWidth: true
            }
            Label {
                text: `Доступно: <b>${maxCount}шт.</b>`
                Layout.alignment: Qt.AlignRight
            }
        }

        TextField {
            id: countField
            visible: maxCount != -1
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
                    itemAdd(materialsCombo.currentIndex, parseInt(countField.text))
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
