import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Page {

    required property StackView stackView

    property double supplyAmount: 0

    header: Rectangle {
        width: parent.width
        height: 80

        Label {
            id: headerLabel
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 20

            text: "<b>Новая поставка</b>"
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

            text: "Наименование"
            font.pointSize: 16
        }

        Label {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: parent.width * 0.50

            text: "Цена"
            font.pointSize: 16
        }

        Label {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: parent.width * 0.65

            text: "Кол-во"
            font.pointSize: 16
        }

        Label {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: parent.width * 0.80

            text: "Итого"
            font.pointSize: 16
        }

        ToolButton {
            id: saveButton

            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 20

            icon.source: "qrc:/images/save.png"
            icon.height: 20
            icon.width: 20
            icon.color: enabled ? "black" : "gray"

            ToolTip.visible: hovered && enabled
            ToolTip.text: "Сохранить"

            onClicked: {
                Models.createSupply(supplyItemsModel)
                endPopup.open()
            }

            enabled: supplyItemsModel.count > 0
        }

        ToolButton {
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.right: saveButton.left
            anchors.rightMargin: 10

            icon.source: "qrc:/images/add.png"
            icon.height: 20
            icon.width: 20

            ToolTip.visible: hovered
            ToolTip.text: "Добавить позицию"

            onClicked: addSupplyItemPopup.popup()
        }

        AddSupplyItemPopup {
            id: addSupplyItemPopup

            onItemAdd: (materialIndex, materialCount, materialPrice) => {
                let item = Models.getMaterial(materialIndex)
                supplyItemsModel.append({ "mat_index": materialIndex, "mat_id": item.materialId, "mat_title": item.materialTitle, "mat_price": materialPrice, "mat_count": materialCount })
                supplyAmount += (materialPrice * materialCount)
            }
        }
    }

    footer: Rectangle {
        width: parent.width
        height: 40

        Label {
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.85
            anchors.verticalCenter: parent.verticalCenter

            text: `<b>${supplyAmount} ₽</b>`
            font.pointSize: 16
        }

        Label {
            anchors.right: parent.right
            anchors.rightMargin: parent.width * 0.15
            anchors.verticalCenter: parent.verticalCenter

            text: "Стоимость поставки: "
            font.pointSize: 16
        }
    }

    Component {
        id: supplyItemsDelegate

        Rectangle {

            width: ListView.view.width
            height: 40

            Label {
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter

                text: `<b>${index + 1}</b>`
                font.pointSize: 16
            }

            Label {
                anchors.left: parent.left
                anchors.leftMargin: 55
                anchors.verticalCenter: parent.verticalCenter

                text: mat_title
                font.pointSize: 16
            }

            Label {
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.50
                anchors.verticalCenter: parent.verticalCenter

                text: `<b>${mat_price} ₽</b>`
                font.pointSize: 16
            }

            Label {
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.65
                anchors.verticalCenter: parent.verticalCenter

                text: mat_count
                font.pointSize: 16
            }

            Label {
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.80
                anchors.verticalCenter: parent.verticalCenter

                text: `<b>${mat_price * mat_count} ₽</b>`
                font.pointSize: 16
            }

            ToolButton {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 20

                icon.source: "qrc:/images/delete.png"
                icon.height: 20
                icon.width: 20

                onClicked: {
                    supplyAmount -= (mat_price * mat_count)
                    supplyItemsModel.remove(index, 1)
                }
            }
        }
    }

    ListModel {
        id: supplyItemsModel
    }

    ListView {
        anchors.fill: parent
        anchors.topMargin: 5
        anchors.bottomMargin: 5

        clip: true
        spacing: 5

        model: supplyItemsModel
        delegate: supplyItemsDelegate
    }

    Popup {
        id: endPopup
        modal: true
        parent: Overlay.overlay
        anchors.centerIn: parent
        width: (parent.width / 3)

        ColumnLayout {
            anchors.fill: parent

            Label {
                text: "<b>Информация</b>"
                Layout.alignment: Qt.AlignHCenter
            }

            Label {
                text: "Поставка была добавлена в базу данных."
                Layout.alignment: Qt.AlignHCenter
            }

            Button {
                text: "Ок";
                Layout.alignment: Qt.AlignHCenter

                onClicked: endPopup.close()
            }
        }

        onClosed: stackView.pop();
    }
}
