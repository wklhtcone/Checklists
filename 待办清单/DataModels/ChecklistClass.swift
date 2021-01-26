//
//  ChecklistClass.swift
//  待办清单
//
//  Created by 王凯霖 on 1/3/21.
//

import Foundation
import UserNotifications

class ChecklistClass: NSObject, Codable{
    var text = ""
    var flag = false
    
    var itemID = 0
    var shouldRemind = false
    var dueDate = Date()
    
    init(text: String, flag: Bool) {
        self.text = text
        self.flag = flag
        self.itemID = DataModel.nextItemID()
        super.init()
    }
    
    deinit {
        removeNotification()
    }
    
    func changeFlag() {
        flag = !flag
    }
    
    func setNotification() {
        removeNotification()//保证编辑了已有的switch状态、时间后会撤销掉旧的，重新安排通知
        
        if shouldRemind && dueDate > Date() {
            let content = UNMutableNotificationContent()
            content.title = "提醒事项"
            content.body = text
            content.sound = UNNotificationSound.default
            
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.month, .day, .hour, .minute], from: dueDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request)
            
            print("我们可以安排通知")
        }
    }
    
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
    
}
