//
//  Item.swift
//  Todo
//
//  Created by Lan Xuping on 2023/7/6.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dataCreated: Date?
    var parentCateM = LinkingObjects(fromType: CateM.self, property: "items")
}
