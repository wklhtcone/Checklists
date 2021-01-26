//
//  DataModel.swift
//  待办清单
//
//  Created by 王凯霖 on 1/7/21.
//

import Foundation

class DataModel {
    var lists = [ChecklistKindClass]()

    
    var indexOfLastList : Int {
        get {
            return UserDefaults.standard.integer(forKey: "listIndex")
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: "listIndex")
        }
    }

    
    init() {
        loadLists()
        setDefault()
        solveFirstTime()
    }
    
    func setDefault() {
        let dic: [String : Any] = ["listIndex" : -1 ,"FirstTime" : true]
        UserDefaults.standard.register(defaults: dic)
    }
    
    func solveFirstTime() {
        if UserDefaults.standard.bool(forKey: "FirstTime") {
            let list = ChecklistKindClass(name: "欢迎使用")
            lists.append(list)
            indexOfLastList = 0
            UserDefaults.standard.set(false, forKey: "FirstTime")
        }
    }
    
    func sortLists() {
        lists.sort(by: {
            listA, listB in
            return listA.name.localizedStandardCompare(listB.name) == .orderedAscending
        })
    }
    
    
    
    
    //数据持久化
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }


    func saveLists() {
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        }
        catch{
            print("Error encoding list array\(error.localizedDescription)")
        }
    }

    func loadLists(){
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path){
            let decoder = PropertyListDecoder()
            do{
                lists = try decoder.decode([ChecklistKindClass].self, from: data)
            }
            catch{
                print("Error decoding list array\(error.localizedDescription)")
            }
        }
        sortLists()
    }
    
    //相当于static方法，调用无需实例对象
    class func nextItemID() -> Int {
        let userDefaults = UserDefaults.standard
        //一开始没有ItemID，返回0；
        let itemID = userDefaults.integer(forKey: "ItemID")
        userDefaults.set(itemID + 1, forKey: "ItemID")
        return itemID
    }
    

}





    
        
    

