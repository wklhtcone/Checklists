//
//  ListDetailViewController.swift
//  待办清单
//
//  Created by 王凯霖 on 1/6/21.
//

import UIKit

protocol ListDetailViewControllerDelegate: class {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    func listDetailViewController(_ controller:ListDetailViewController, didFinishAdding checklistKind:ChecklistKindClass)
    func listDetailViewController(_ controller:ListDetailViewController, didFinishEditing checklistKind:ChecklistKindClass)
}


class ListDetailViewController:UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
    
    //读取选择的图标image、图标name
    @IBOutlet weak var iconImageView: UIImageView!
    var iconName = "Folder"
    
    //读取textField数据、根据是否为空控制button是否可用
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    

    weak var delegate: ListDetailViewControllerDelegate?
    
    var listToEdit: ChecklistKindClass?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let list = listToEdit{
            title = "编辑清单种类"
            textField.text = list.name
            doneBarButton.isEnabled=true
            iconName = list.iconName //编辑时更新iconName
        }
        iconImageView.image = UIImage(named: iconName) //编辑时更新iconImageView
    }
    
    //自动出现键盘
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    //防止选择list名字的行变灰；同时第二部分选择图片可以点
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 {
            return indexPath
        }
        else {
            return nil
        }
    }
    
    //textField的代理，防止textField中什么都没有时，键盘的done按钮有效
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        doneBarButton.isEnabled = (newText.length > 0)
        return true
    }
    
    
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let newList = listToEdit {
            newList.name = textField.text!
            newList.iconName = iconName//更新dataModel
            delegate?.listDetailViewController(self, didFinishEditing: newList)
        }
        else{
            let newList = ChecklistKindClass(name: textField.text!, iconName: iconName)//更新dataModel
            delegate?.listDetailViewController(self, didFinishAdding: newList)
        }
    }
    
    //设置IconPickerVC的delegate为自己
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickIconSegue" {
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
        }
    }
    
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
        //右边的iconName是 IconPickerVC传过来的
        //反向传值更新iconName和iconImageView
        self.iconName = iconName
        self.iconImageView.image = UIImage(named: iconName)
        navigationController?.popViewController(animated: true)
    }
}

