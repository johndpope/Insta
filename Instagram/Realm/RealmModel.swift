//
//  RealmModel.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/25.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import Foundation
import RealmSwift

struct RealmModel {
    struct realm {
        static var realmTry = try! Realm()
        static var realmSet = RealmDataSet()
        static var userSet = RealmModel.realm.realmTry.objects(RealmDataSet.self)
    }
}
