import QtQuick 2.15
import QtQuick.Controls 2.15

Page {
    ListModel {
        id: menuModel

        Component.onCompleted: {
            append({ "pageTitle": "Новый заказ",    "pageIcon": "add-order",  "pageQml": "AddOrder",  "pageDesc": "Создание нового заказа" })
            append({ "pageTitle": "Материалы",      "pageIcon": "materials",  "pageQml": "Materials", "pageDesc": "Просмотр, добавление и редактирование материалов на складе" })
            append({ "pageTitle": "Заказы",         "pageIcon": "orders",     "pageQml": "Orders",    "pageDesc": "Просмотр заказов во всех подробностях" })
            append({ "pageTitle": "Клиенты",        "pageIcon": "clients",    "pageQml": "Clients",   "pageDesc": "Просмотр, добавление и редактирование клиентов склада" })
            append({ "pageTitle": "Поставки",       "pageIcon": "supplies",   "pageQml": "Supplies",  "pageDesc": "Просмотр поставок во всех подробностях" })
            append({ "pageTitle": "Новая поставка", "pageIcon": "add-supply", "pageQml": "AddSupply", "pageDesc": "Создание новой поставки" })
        }
    }

    Component {
        id: menuDelegate

        ItemDelegate {

            width: ListView.view.width
            height: 85

            Image {
                id: iconImage

                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter

                source: `images/icon-${pageIcon}.png`
            }

            Label {
                id: titleLabel

                anchors.top: iconImage.top
                anchors.left: iconImage.right
                anchors.leftMargin: 10

                text: `<b>${pageTitle}</b>`
                font.pointSize: 24
            }

            Label {
                id: descLabel

                anchors.top: titleLabel.bottom
                anchors.left: titleLabel.left

                text: pageDesc
                color: "gray"

                font.pointSize: 16
            }

            ToolButton {
                anchors.right: parent.right
                anchors.rightMargin: 20
                anchors.verticalCenter: parent.verticalCenter

                icon.source: "images/forward.png"
                icon.height: 20
                icon.width: 20

                onClicked: parent.clicked()
            }

            onClicked: stackView.push(`pages/${pageQml}Page.qml`, { "stackView": stackView })
        }
    }

    ListView {
        id: menuView

        anchors.fill: parent

        clip: true
        spacing: 5

        model: menuModel
        delegate: menuDelegate
    }
}
