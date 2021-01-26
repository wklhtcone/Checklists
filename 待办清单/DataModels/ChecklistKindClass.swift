//
//  ChecklistKindClass.swift
//  待办清单
//
//  Created by 王凯霖 on 1/5/21.
//

import UIKit

class ChecklistKindClass: NSObject, Codable {
    var name = ""
    var iconName = "No Icon"
    var items = [ChecklistClass]()
    

    init(name: String, iconName: String = "No Icon") {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    func cntNoflag() -> Int {
        var cnt = 0
        for item in items where !item.flag{
            cnt += 1
        }
        return cnt
    }
}


