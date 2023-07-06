//
//  CateM.swift
//  Todo
//
//  Created by Lan Xuping on 2023/7/6.
//

import Foundation
import RealmSwift

class CateM: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
