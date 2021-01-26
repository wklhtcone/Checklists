//
//  ItemDetailViewController.swift
//  待办清单
//
//  Created by 王凯霖 on 1/4/21.
//

import UIKit


protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController,didFinishAdding item: ChecklistClass)
    func itemDetailViewController(_ controller: ItemDetailViewController,didFinishEditing item: ChecklistClass)
}

class ItemDetailViewController: UITableViewController,UITextFieldDelegate {

    
    
    @IBOutlet weak var textField: UITextField! //用来获取textFiled的内容
    @IBOutlet weak var doneBarButton: UIBarButtonItem! //AddItemVC通过控制outlet的值来禁用barButton
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!//这个是String类型，不是Date，不能直接用
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!

    
    weak var delegate : ItemDetailViewControllerDelegate? //?可选类型表示可以为nil，这个delegate就是ChecklistViewController
    var itemToEdit:ChecklistClass?//编辑的时候已经有item了，需要修改AddItemVC的title和cell中文本框内容
    var dueDate = Date()
    var datePickerVisable = false


    
    override func viewDidLoad(){
        super.viewDidLoad()
        if let item = itemToEdit{
            title = "编辑事项"
            textField.text = item.text
            doneBarButton.isEnabled = true
            shouldRemindSwitch.isOn = item.shouldRemind
            dueDate = item.dueDate
        }
        updateDueDateLabel()
    }
    
    func updateDueDateLabel() {
        let nowDate = DateFormatter()
        nowDate.dateStyle = .medium
        nowDate.timeStyle = .short
        dueDateLabel.text = nowDate.string(from: dueDate)
    }
    
    @IBAction func dataChanged(_ datePicker: UIDatePicker) {
        dueDate = datePicker.date
        updateDueDateLabel()
    }
    
  
    
    @IBAction func done(){
        if let item = itemToEdit {
            item.text = textField.text!
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            item.setNotification()
            delegate?.itemDetailViewController(self, didFinishEditing: item)
        }
        else{
            //新对象在addItemVC中创建，通过delegate传到checkListVC
            let item = ChecklistClass(text: textField.text!, flag: false)
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            item.setNotification()
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }
    
    @IBAction func cancel(){
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    

    
    //无需点击文本框，自动弹出键盘
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    func textField(_ textField:UITextField,shouldChangeCharactersIn range:NSRange, replacementString string:String) -> Bool{
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString

        doneBarButton.isEnabled = (newText.length > 0)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
    }
    
    
    func showDatePicker() {
        datePickerVisable = true
        
        let dueDateIndexPath = IndexPath(row: 1, section: 1)
        let datePickerIndexPath = IndexPath(row: 2, section: 1)
        
        //改变dueDate的颜色
        if let cell = tableView.cellForRow(at: dueDateIndexPath) {
            cell.detailTextLabel!.textColor = cell.detailTextLabel!.tintColor
        }
        
        //重新加载dueDate，插入新的datePicker
        tableView.beginUpdates()
        tableView.reloadRows(at: [dueDateIndexPath], with: .none)
        tableView.insertRows(at: [datePickerIndexPath], with: .fade)
        tableView.endUpdates()
        
        
        datePicker.setDate(dueDate, animated: false)//保证编辑已有item时，datePicker不是显示当前时间而是原有时间
    }
    
    func hideDatePicker() {
        if datePickerVisable {
            datePickerVisable = false
            let dueDateIndexPath = IndexPath(row: 1, section: 1)
            let datePickerIndexPath = IndexPath(row: 2, section: 1)
            
            //改变dueDate的颜色
            if let cell = tableView.cellForRow(at: dueDateIndexPath) {
                cell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
            }
            
            tableView.beginUpdates()
            tableView.reloadRows(at: [dueDateIndexPath], with: .none)
            tableView.deleteRows(at: [datePickerIndexPath], with: .fade)
            tableView.endUpdates()
            
        }
    }
    

    //TableView datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisable {
            return 3
        }
        else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            return datePickerCell
        }
        else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        }
        else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    
    //静态Table View数据源更改后，也要更改delegate，返回一个已经存在的indexPath对应的缩紧
    //可以是section 0，row 0；或section 1，row 0/1
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndexPath = indexPath
        if indexPath.section == 1 && indexPath.row == 2 {
            newIndexPath = IndexPath(row: 0, section: 0)
        }
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
    }
    
    
    
    //TableView Delegate，禁止选择非datePicker的输入文本行
    override func tableView(_ tableView:UITableView, willSelectRowAt indexPath:IndexPath) -> IndexPath? {
        if indexPath.row == 1 && indexPath.section == 1 {
            return indexPath
        }
        else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        textField.resignFirstResponder()
        
        if indexPath.section == 1 && indexPath.row == 1 {
            if !datePickerVisable {
                showDatePicker()
            }
            else {
                hideDatePicker()
            }
            
        }
    }

    

   
}
