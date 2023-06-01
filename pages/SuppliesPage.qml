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

            text: "<b>Поставки</b>"
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

            text: "Дата поставки"
            font.pointSize: 16
        }

        Label {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: parent.width * 0.50

            text: "Стоимость поставки"
            font.pointSize: 16
        }
    }

    Component {
        id: suppliesDelegate

        ItemDelegate {

            width: ListView.view.width
            height: 40

            Label {
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter

                text: `<b>${supplyId}</b>`
                font.pointSize: 16
            }

            Label {
                anchors.left: parent.left
                anchors.leftMargin: 55
                anchors.verticalCenter: parent.verticalCenter

                text: supplyTime
                font.pointSize: 16
            }

            Label {
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.50
                anchors.verticalCenter: parent.verticalCenter

                text: `<b>${supplyAmount} ₽</b>`
                font.pointSize: 16
            }

            onClicked: {
                stackView.push("SupplyDetailsPage.qml", {
                    "supplyId": supplyId,
                    "supplyTime": supplyTime,
                    "supplyAmount": supplyAmount
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
            Component.onCompleted: Models.fillSupplies(this)
        }
        delegate: suppliesDelegate
    }
}
