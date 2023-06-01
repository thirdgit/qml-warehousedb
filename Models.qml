pragma Singleton

import QtQuick 2.15

Item {

    ListModel {
        id: clientsModel

        Component.onCompleted: {
            let data = Database.getClients()
            data.forEach((row) => append(row))
        }
    }

    ListModel {
        id: materialsModel

        Component.onCompleted: {
            let data = Database.getMaterials()
            data.forEach((row) => append(row))
        }
    }

    function getClients() {
        return clientsModel;
    }

    function getClient(index) {
        return clientsModel.get(index)
    }

    function getMaterials() {
        return materialsModel;
    }

    function getMaterial(index) {
        return materialsModel.get(index)
    }

    function addClient(clientName, clientPhone, clientAddress) {
        let rowId = Database.addClient(clientName, clientPhone, clientAddress)
        clientsModel.append({
            "clientId": rowId,
            "clientName": clientName,
            "clientPhone": clientPhone,
            "clientAddress": clientAddress
        })
    }

    function addMaterial(materialTitle, materialPrice, materialCount) {
        let rowId = Database.addMaterial(materialTitle, materialPrice, materialCount)
        materialsModel.append({
            "materialId": rowId,
            "materialTitle": materialTitle,
            "materialPrice": materialPrice,
            "materialCount": materialCount
        })
    }

    function editClient(index, clientId, clientName, clientPhone, clientAddress) {
        Database.updateClient(clientId, clientName, clientPhone, clientAddress)
        let client = clientsModel.get(index)
        client.clientName = clientName
        client.clientPhone = clientPhone
        client.clientAddress = clientAddress
    }

    function editMaterial(index, materialId, materialTitle, materialPrice, materialCount) {
        Database.updateMaterial(materialId, materialTitle, materialPrice, materialCount)
        let material = materialsModel.get(index)
        material.materialTitle = materialTitle
        material.materialPrice = materialPrice
        material.materialCount = materialCount
    }

    function fillOrders(model) {
        let data = Database.getOrders()
        data.forEach((row) => model.append(row))
    }

    function fillOrderDetails(model, orderId) {
        let data = Database.getOrderDetails(orderId)
        data.forEach((row) => model.append(row))
    }

    function fillSupplies(model) {
        let data = Database.getSupplies()
        data.forEach((row) => model.append(row))
    }

    function fillSupplyDetails(model, supplyId) {
        let data = Database.getSupplyDetails(supplyId)
        data.forEach((row) => model.append(row))
    }

    function fillMaterialsCombo(model) {
        for (let i = 0; i < materialsModel.count; ++i) {
            let item = materialsModel.get(i)
            model.append({
                "matId": item.materialId,
                "matText": `${item.materialId}, ${item.materialTitle}, ${item.materialPrice} ₽`
            });
        }
    }

    function createOrder(clientIndex, itemsModel) {
        let clientId = clientsModel.get(clientIndex).clientId
        let rowId = Database.createOrder(clientId)
        for (let i = 0; i < itemsModel.count; ++i) {
            let item = itemsModel.get(i)

            Database.addOrderItem(rowId, item.mat_id, item.mat_price, item.mat_count)
            materialsModel.get(item.mat_index).materialCount -= item.mat_count
        }
    }

    function createSupply(itemsModel) {
        let rowId = Database.createSupply()
        for (let i = 0; i < itemsModel.count; ++i) {
            let item = itemsModel.get(i)

            Database.addSupplyItem(rowId, item.mat_id, item.mat_price, item.mat_count)
            materialsModel.get(item.mat_index).materialCount += item.mat_count
        }
    }
}
