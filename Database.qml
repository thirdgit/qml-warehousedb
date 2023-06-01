pragma Singleton

import QtQml
import QtQuick.LocalStorage

QtObject {
    id: root

    property var _db

    function _database() {
        if (_db)
            return _db

        try {
            let db = LocalStorage.openDatabaseSync("WarehouseDB", "1.0", "")

            db.transaction((tx) => {
                tx.executeSql("create table if not exists `clients` (
                    `client_id` integer primary key autoincrement,
                    `client_name` text,
                    `client_phone` text,
                    `client_address` text
                );")
                tx.executeSql("create table if not exists `materials` (
                    `material_id` integer primary key autoincrement,
                    `material_title` text,
                    `material_price` real,
                    `material_count` integer
                );")
                tx.executeSql("create table if not exists `orders` (
                    `order_id` integer primary key autoincrement,
                    `order_time` timestamp default current_timestamp,
                    `order_amount` real default '0',
                    `client_id` integer,
                    foreign key (`client_id`) references `clients` (`client_id`)
                );")
                tx.executeSql("create table if not exists `supplies` (
                    `supply_id` integer primary key autoincrement,
                    `supply_time` timestamp default current_timestamp,
                    `supply_amount` real default '0'
                );")
                tx.executeSql("create table if not exists `orders_has_materials` (
                    `order_id` integer,
                    `material_id` integer,
                    `count` integer,
                    `price` real,
                    constraint `fk_ohm_o` foreign key (`order_id`) references `orders` (`order_id`),
                    constraint `fk_ohm_m` foreign key (`material_id`) references `materials` (`material_id`)
                );")
                tx.executeSql("create table if not exists `supplies_has_materials` (
                    `supply_id` integer,
                    `material_id` integer,
                    `count` integer,
                    `price` real,
                    constraint `fk_shm_s` foreign key (`supply_id`) references `supplies` (`supply_id`),
                    constraint `fk_shm_m` foreign key (`material_id`) references `materials` (`material_id`)
                );")

                tx.executeSql("insert or ignore into `clients` (`client_id`, `client_name`, `client_phone`, `client_address`) values
                                ('1', 'Дорофеев Дмитрий Алексеевич', '+7-920-100-50-25', 'г. Тверь, ул. Советская, д. 37'),
                                ('2', 'Терёхин Валентин Витальевич', '+8-800-24-85-293', 'г. Самара, ул. Ленина, д. 24'),
                                ('3', 'Авдеева Анжелика Сидоровна', '+7-900-012-34-56', 'г. Тверь, ул. Пушкина, д. 14'),
                                ('4', 'Уральская Антонина Ивановна', '+7-900-012-34-56', 'д. Глазково, ул. Берёзовая, д. 15'),
                                ('5', 'Соболев Фёдор Николаевич', '+7-920-100-50-25', 'г. Тверь, ул. Красина, д. 15');")
                tx.executeSql("insert or ignore into `materials` (`material_id`, `material_title`, `material_price`, `material_count`) values
                                ('1', 'Цемент М400 Д20, 50 кг', '388', '500'),
                                ('2', 'Кирпич рядовой полнотелый, 1 шт', '22.5', '2500'),
                                ('3', 'Кирпич рядовой поризованный, 1 шт', '31', '2500'),
                                ('4', 'Песок строительный, 50 кг', '123', '500'),
                                ('5', 'Щебень гранитный фракция 5-20 мм, 50 кг', '123', '500');")
                /*tx.executeSql("insert or ignore into `orders` (`order_id`, `order_amount`, `client_id`) values
                                ('1', '300', '1'),
                                ('2', '225', '3');")
                tx.executeSql("insert or ignore into `orders_has_materials` (`order_id`, `material_id`, `count`, `price`) values
                                ('1', '1', '2', '150'),
                                ('2', '2', '10', '22.5');")
                tx.executeSql("insert or ignore into `supplies` (`supply_id`, `supply_amount`) values
                                ('1', '300'),
                                ('2', '225');")
                tx.executeSql("insert or ignore into `supplies_has_materials` (`supply_id`, `material_id`, `count`, `price`) values
                                ('1', '1', '2', '150'),
                                ('2', '2', '10', '22.5');")*/
            })

            _db = db
        } catch (error) {
            console.log("Error opening database: " + error)
        };

        return _db
    }

    function getClients() {
        let clients = []
        root._database().transaction((tx) => {
            let result = tx.executeSql('select * from `clients`;')
            for (let i = 0; i < result.rows.length; i++) {
                let row = result.rows.item(i)
                clients.push({
                    "clientId": row.client_id,
                    "clientName": row.client_name,
                    "clientPhone": row.client_phone,
                    "clientAddress": row.client_address
                })
            }
        })
        return clients
    }

    function addClient(clientName, clientPhone, clientAddress) {
        let rowId
        root._database().transaction((tx) => {
            let result = tx.executeSql("insert into `clients` (`client_name`, `client_phone`, `client_address`) values (?, ?, ?);", [clientName, clientPhone, clientAddress])
            rowId = parseInt(result.insertId)
        })
        return rowId
    }

    function updateClient(clientId, clientName, clientPhone, clientAddress) {
        root._database().transaction((tx) => {
            tx.executeSql("update `clients` set `client_name`=?, `client_phone`=?, `client_address`=? where `client_id`=?;", [clientName, clientPhone, clientAddress, clientId])
        })
    }

    /* ------------------------------------------ */

    function getMaterials() {
        let materials = []
        root._database().transaction((tx) => {
            let result = tx.executeSql('select * from `materials`;')
            for (let i = 0; i < result.rows.length; i++) {
                let row = result.rows.item(i)
                materials.push({
                    "materialId": row.material_id,
                    "materialTitle": row.material_title,
                    "materialPrice": row.material_price,
                    "materialCount": row.material_count
                })
            }
        })
        return materials
    }

    function addMaterial(materialTitle, materialPrice, materialCount) {
        let rowId
        root._database().transaction((tx) => {
            let result = tx.executeSql("insert into `materials` (`material_title`, `material_price`, `material_count`) values (?, ?, ?);", [materialTitle, materialPrice, materialCount])
            rowId = parseInt(result.insertId)
        })
        return rowId
    }

    function updateMaterial(materialId, materialTitle, materialPrice, materialCount) {
        root._database().transaction((tx) => {
            tx.executeSql("update `materials` set `material_title`=?, `material_price`=?, `material_count`=? where `material_id`=?;", [materialTitle, materialPrice, materialCount, materialId])
        })
    }

    /* ------------------------------------------ */

    function getOrders() {
        let orders = []
        root._database().transaction((tx) => {
            let result = tx.executeSql("select
                    `o`.`order_id`,
                    datetime(`o`.`order_time`, 'localtime') as `order_time`,
                    `o`.`order_amount`,
                    `o`.`client_id`,
                    `c`.`client_name`
                from `orders` as `o`
                inner join `clients` as `c`
                    on `c`.`client_id` = `o`.`client_id`
                order by `o`.`order_id` desc;")
            for (let i = 0; i < result.rows.length; i++) {
                let row = result.rows.item(i)
                orders.push({
                    "orderId": row.order_id,
                    "orderTime": row.order_time,
                    "orderAmount": row.order_amount,
                    "clientId": row.client_id,
                    "clientName": row.client_name
                })
            }
        })
        return orders
    }

    function getOrderDetails(orderId) {
        let entries = []
        root._database().transaction((tx) => {
            let result = tx.executeSql("select
                    `m`.`material_title`,
                    `ohm`.`count`,
                    `ohm`.`price`
                from `orders_has_materials` as `ohm`
                inner join `materials` as `m`
                    on `ohm`.`material_id` = `m`.`material_id`
                where `ohm`.`order_id`=?;", [orderId])
            for (let i = 0; i < result.rows.length; i++) {
                let row = result.rows.item(i)
                entries.push({
                    "omTitle": row.material_title,
                    "omCount": row.count,
                    "omPrice": row.price
                })
            }
        })
        return entries
    }

    function createOrder(clientId) {
        let rowId
        root._database().transaction((tx) => {
            let result = tx.executeSql("insert into `orders` (`client_id`, `order_amount`) values (?, 0);", [clientId])
            rowId = parseInt(result.insertId)
        })
        return rowId
    }

    function addOrderItem(orderId, materialId, materialPrice, materialCount) {
        root._database().transaction((tx) => {
            tx.executeSql("insert into `orders_has_materials` (`order_id`, `material_id`, `count`, `price`) values (?, ?, ?, ?);", [orderId, materialId, materialCount, materialPrice])
            tx.executeSql("update `orders` set `order_amount`=`order_amount` + ? where `order_id` = ?;", [materialPrice * materialCount, orderId])
            tx.executeSql("update `materials` set `material_count`=`material_count` - ? where `material_id` = ?;", [materialCount, materialId])
        })
    }

    /* ------------------------------------------ */

    function getSupplies() {
        let supplies = []
        root._database().transaction((tx) => {
            let result = tx.executeSql("select
                    `supply_id`,
                    datetime(`supply_time`, 'localtime') as `supply_time`,
                    `supply_amount`
                from `supplies` order by `supply_id` desc;")
            for (let i = 0; i < result.rows.length; i++) {
                let row = result.rows.item(i)
                supplies.push({
                    "supplyId": row.supply_id,
                    "supplyTime": row.supply_time,
                    "supplyAmount": row.supply_amount
                })
            }
        })
        return supplies
    }

    function getSupplyDetails(supplyId) {
        let entries = []
        root._database().transaction((tx) => {
            let result = tx.executeSql("select
                    `m`.`material_title`,
                    `shm`.`count`,
                    `shm`.`price`
                from `supplies_has_materials` as `shm`
                inner join `materials` as `m`
                    on `shm`.`material_id` = `m`.`material_id`
                where `shm`.`supply_id`=?;", [supplyId])
            for (let i = 0; i < result.rows.length; i++) {
                let row = result.rows.item(i)
                entries.push({
                    "smTitle": row.material_title,
                    "smCount": row.count,
                    "smPrice": row.price
                })
            }
        })
        return entries
    }

    function createSupply() {
        let rowId
        root._database().transaction((tx) => {
            let result = tx.executeSql("insert into `supplies` (`supply_amount`) values (0);")
            rowId = parseInt(result.insertId)
        })
        return rowId
    }

    function addSupplyItem(supplyId, materialId, materialPrice, materialCount) {
        root._database().transaction((tx) => {
            tx.executeSql("insert into `supplies_has_materials` (`supply_id`, `material_id`, `count`, `price`) values (?, ?, ?, ?);", [supplyId, materialId, materialCount, materialPrice])
            tx.executeSql("update `supplies` set `supply_amount`=`supply_amount` + ? where `supply_id` = ?;", [materialPrice * materialCount, supplyId])
            tx.executeSql("update `materials` set `material_count`=`material_count` + ? where `material_id` = ?;", [materialCount, materialId])
        })
    }
}
