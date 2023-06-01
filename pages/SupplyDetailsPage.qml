import QtQuick 2.15
import QtQuick.Controls 2.15

Page {

    required property int    supplyId
    required property string supplyTime
    required property double supplyAmount

    header: Rectangle {
        width: parent.width
        height: 100

        Label {
            id: headerLabel
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 20

            text: `<b>Детали поставки №${supplyId}</b>`
            font.pointSize: 24
        }

        Label {
            anchors.top: headerLabel.bottom
            anchors.left: headerLabel.left

            text: `<b>Дата поставки:</b> ${supplyTime}`
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
        id: supplyDataDelegate

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

                text: smTitle
                font.pointSize: 16
            }

            Label {
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.55
                anchors.verticalCenter: parent.verticalCenter

                text: `<b>${smPrice} ₽</b>`
                font.pointSize: 16
            }

            Label {
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.70
                anchors.verticalCenter: parent.verticalCenter

                text: smCount
                font.pointSize: 16
            }

            Label {
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.85
                anchors.verticalCenter: parent.verticalCenter

                text: `<b>${smPrice * smCount} ₽</b>`
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
            Component.onCompleted: Models.fillSupplyDetails(this, supplyId)
        }
        delegate: supplyDataDelegate
    }
}
