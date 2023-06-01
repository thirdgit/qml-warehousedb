import QtQuick 2.15
import QtQuick.Controls 2.15

Page {

    required property int       orderId
    required property string    orderTime
    required property double    orderAmount
    required property int       clientId
    required property string    clientName

    header: Rectangle {
        width: parent.width
        height: 125

        Label {
            id: headerLabel
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 20

            text: `<b>Детали заказа №${orderId}</b>`
            font.pointSize: 24
        }

        Label {
            anchors.top: headerLabel.bottom
            anchors.left: headerLabel.left

            text: `<b>Дата заказа:</b> ${orderTime}<br><b>Клиент:</b> ${clientName} (${clientId})`
            font.pointSize: 16
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
            anchors.leftMargin: parent.width * 0.55

            text: "Цена"
            font.pointSize: 16
        }

        Label {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: parent.width * 0.70

            text: "Кол-во"
            font.pointSize: 16
        }

        Label {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: parent.width * 0.85

            text: "Итого"
            font.pointSize: 16
        }
    }

    footer: Rectangle {
        width: parent.width
        height: 40

        Label {
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.85
            anchors.verticalCenter: parent.verticalCenter

            text: `<b>${orderAmount} ₽</b>`
            font.pointSize: 16
        }

        Label {
            anchors.right: parent.right
            anchors.rightMargin: parent.width * 0.15
            anchors.verticalCenter: parent.verticalCenter

            text: "Итоговая стоимость: "
            font.pointSize: 16
        }
    }

    Component {
        id: orderDataDelegate

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

                text: omTitle
                font.pointSize: 16
            }

            Label {
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.55
                anchors.verticalCenter: parent.verticalCenter

                text: `<b>${omPrice} ₽</b>`
                font.pointSize: 16
            }

            Label {
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.70
                anchors.verticalCenter: parent.verticalCenter

                text: omCount
                font.pointSize: 16
            }

            Label {
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.85
                anchors.verticalCenter: parent.verticalCenter

                text: `<b>${omPrice * omCount} ₽</b>`
                font.pointSize: 16
            }
        }
    }

    ListView {
        anchors.fill: parent
        anchors.topMargin: 5
        anchors.bottomMargin: 5

        clip: true
        spacing: 5

        model: ListModel {
            Component.onCompleted: Models.fillOrderDetails(this, orderId)
        }
        delegate: orderDataDelegate
    }
}
