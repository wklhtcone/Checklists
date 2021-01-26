//
//  ViewController.swift
//  待办清单
//
//  Created by 王凯霖 on 1/3/21.
//

import UIKit

class ChecklistsViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    var checklistKind: ChecklistKindClass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklistKind.name
    }
    
    
    func configCellFlag(for cell:UITableViewCell, with item:ChecklistClass){
        let label = cell.viewWithTag(1001) as! UILabel
        if item.flag{
            label.text = "√"
        }
        else{
            label.text = ""
        }
        label.textColor = view.tintColor
    }
    
    
    func configCellText(for cell:UITableViewCell, with item:ChecklistClass){
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    
    //转场
    override func prepare(for segue:UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addItemSegue" {
            //ItemViewVC是它所在的导航控制器的第一个VC，通过找到导航控制器找到ItemDetailVC
            let nvController = segue.destination as! UINavigationController
            let controller = nvController.topViewController as! ItemDetailViewController
            controller.delegate = self
        }
        //正向传值，让ItemDetailVC知道是add还是edit
        else if segue.identifier == "editItemSegue" {
            let nvController = segue.destination as! UINavigationController
            let controller = nvController.topViewController as! ItemDetailViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                controller.itemToEdit = checklistKind.items[indexPath.row]
            }
        }
    }
       
    
    // TableView Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int ) -> Int {
        return checklistKind.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        let item = checklistKind.items[indexPath.row]
        
        configCellText(for:cell, with:item)
        configCellFlag(for:cell, with:item)

        return cell
    }
    
    override func tableView(_ tableView:UITableView, commit editingStyle:UITableViewCell.EditingStyle,forRowAt indexPath:IndexPath){
        checklistKind.items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        //saveItems()
    }


    // TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell=tableView.cellForRow(at:indexPath){
            let item = checklistKind.items[indexPath.row]
            item.changeFlag()
            configCellFlag(for:cell, with:item)
        }
        //防止被选中行一直是被选中状态（变灰）
        tableView.deselectRow(at: indexPath, animated: true)
        //saveItems()
        
    }
    

    //实现ItemDetailVC的delegate方法
    func itemDetailViewController(_ controller: ItemDetailViewController,didFinishAdding newItem: ChecklistClass){
        //addItem中创建新对象放在addItemVC中，通过delegate传到checkListVC，在delegate方法中完成对Model和View的更新
        
        let newRowIndex = checklistKind.items.count
        checklistKind.items.append(newItem)
    
        let newIndexPath = IndexPath(row:newRowIndex, section: 0)
        let newIndexPaths = [newIndexPath]
        tableView.insertRows(at: newIndexPaths, with: .automatic)
        
        dismiss(animated: true, completion: nil)
        //saveItems()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistClass) {
        //找到 Model 中被编辑item的index -> 更新 View 中对应的cell内容
        if let index = checklistKind.items.firstIndex(of: item){
            let indexPath = IndexPath(row:index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                configCellText(for: cell, with: item)
            }
        }
        dismiss(animated: true, completion: nil)
        //saveItems()
    }
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController){
        dismiss(animated: true, completion: nil)
    }
    


}

