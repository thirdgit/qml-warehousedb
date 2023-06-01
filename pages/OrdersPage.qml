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

            text: "<b>Заказы</b>"
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

            text: "Дата заказа"
            font.pointSize: 16
        }

        Label {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: parent.width * 0.35

            text: "Итого"
            font.pointSize: 16
        }

        Label {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: parent.width * 0.50

            text: "Клиент"
            font.pointSize: 16
        }
    }

    Component {
        id: ordersDelegate

        ItemDelegate {

            width: ListView.view.width
            height: 40

            Label {
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter

                text: `<b>${orderId}</b>`
                font.pointSize: 16
            }

            Label {
                anchors.left: parent.left
                anchors.leftMargin: 55
                anchors.verticalCenter: parent.verticalCenter

                text: orderTime
                font.pointSize: 16
            }

            Label {
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.35
                anchors.verticalCenter: parent.verticalCenter

                text: `<b>${orderAmount} ₽</b>`
                font.pointSize: 16
            }

            Label {
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.50
                anchors.verticalCenter: parent.verticalCenter

                text: `${clientName} (${clientId})`
                font.pointSize: 16
            }

            onClicked: {
                stackView.push("OrderDetailsPage.qml", {
                    "orderId": orderId,
                    "orderTime": orderTime,
                    "orderAmount": orderAmount,
                    "clientId": clientId,
                    "clientName": clientName
                })
            }
        }
    }

    ListView {
        anchors.fill: parent
        anchors.topMargin: 5

        clip: true
        spacing: 5

        model: ListModel {
            Component.onCompleted: Models.fillOrders(this)
        }
        delegate: ordersDelegate
    }
}
