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

            text: "<b>Материалы</b>"
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

            text: "Название"
            font.pointSize: 16
        }

        Label {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: parent.width * 0.60

            text: "Стоимость"
            font.pointSize: 16
        }

        Label {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: parent.width * 0.80

            text: "Остаток"
            font.pointSize: 16
        }

        ToolButton {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 10
            anchors.rightMargin: 20

            icon.source: "qrc:/images/add.png"
            icon.height: 20
            icon.width: 20

            ToolTip.visible: hovered
            ToolTip.text: "Добавить материал"

            onClicked: addMaterialPopup.open()
        }

        AddMaterialPopup {
            id: addMaterialPopup

            onMaterialCreate: (materialTitle, materialPrice, materialCount) => {
                Models.addMaterial(materialTitle, materialPrice, materialCount)
            }
        }
    }

    Component {
        id: materialsDelegate

        ItemDelegate {

            width: ListView.view.width
            height: 40

            Label {
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter

                text: `<b>${materialId}</b>`
                font.pointSize: 16
            }

            Label {
                anchors.left: parent.left
                anchors.leftMargin: 55
                anchors.verticalCenter: parent.verticalCenter

                text: materialTitle
                font.pointSize: 16
            }

            Label {
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.60
                anchors.verticalCenter: parent.verticalCenter

                text: `<b>${materialPrice} ₽</b>`
                font.pointSize: 16
            }

            Label {
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.80
                anchors.verticalCenter: parent.verticalCenter

                text: `${materialCount} шт.`
                color: materialCount ? "black" : "red"
                font.pointSize: 16
            }

            onClicked: editMaterialPopup.popup(materialTitle, materialPrice, materialCount)

            EditMaterialPopup {
                id: editMaterialPopup

                onMaterialEdit: (_materialTitle, _materialPrice, _materialCount) => {
                    Models.editMaterial(index, materialId, _materialTitle, _materialPrice, _materialCount)
                }
            }
        }
    }

    ListView {
        anchors.fill: parent
        anchors.topMargin: 5

        clip: true
        spacing: 5

        model: Models.getMaterials()
        delegate: materialsDelegate
    }
}
