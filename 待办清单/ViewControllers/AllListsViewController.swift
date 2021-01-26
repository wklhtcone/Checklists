//
//  AllListsViewController.swift
//  待办清单
//
//  Created by 王凯霖 on 1/5/21.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {

    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(dataModel.dataFilePath())")
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        let index = dataModel.indexOfLastList
        if index >= 0 && index < dataModel.lists.count {
            let checklistKind = dataModel.lists[index]
            performSegue(withIdentifier: "showItemSegue", sender: checklistKind)
        }
    }
    


    

    //TableView datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = makeCell(for:tableView)
        
        //cell的主内容
        let list = dataModel.lists[indexPath.row]
        cell.textLabel!.text = list.name
        cell.accessoryType = .detailDisclosureButton
        
        //cell的subtitle内容，根据未标记的item、总item确定
        let remainCnt = list.cntNoflag()
        if list.items.count == 0 {
            cell.detailTextLabel!.text = "没有项目"
        }
        else if remainCnt == 0 {
            cell.detailTextLabel!.text = "都做完了！"
        }
        else {
            cell.detailTextLabel!.text = "还剩\(remainCnt)条"
        }
        
        cell.imageView!.image = UIImage(named: list.iconName)
        return cell
    }

    func makeCell(for tableView:UITableView) -> UITableViewCell {
        let cellID = "Cell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID){
            return cell
        }
        //subtitle类型的cell
        else {
            return UITableViewCell(style: .subtitle, reuseIdentifier: cellID)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    
    
    // Table view delegate
    
    //点击cell转场，跳转到ChecklistVC
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {
        //转场时记录转到第几行
        //UserDefaults.standard.set(indexPath.row, forKey: "listIndex")
        dataModel.indexOfLastList = indexPath.row
        let checklistKind = dataModel.lists[indexPath.row]
        //向ChecklistViewController传checklistKind对象
        performSegue(withIdentifier: "showItemSegue", sender: checklistKind)
    }
    
    
    //从AllListsVC到ListDetailVC
    //ListDetailVC需要向AlllistVC反向传值，因此需要设置代理；edit也需要正向传值
    //ListDetailVC通过其导航控制器找到
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let nvController = storyboard!.instantiateViewController(withIdentifier: "ListDetailNavigationController") as! UINavigationController
        let controller = nvController.topViewController as! ListDetailViewController
        controller.delegate = self
        let checklistKind = dataModel.lists[indexPath.row]
        controller.listToEdit = checklistKind
        present(nvController, animated: true, completion: nil)
    }
    
    
    //转场传值、设置delegate
    override func prepare(for segue:UIStoryboardSegue,sender: Any?) {
        //AllListVC和ChecklistVC在同一个导航控制器中，segue ID 在storyboard中设置了，只需要正向传当前是哪一个checklistKind
        if segue.identifier == "showItemSegue" {
            let controller = segue.destination as! ChecklistsViewController
            controller.checklistKind = sender as? ChecklistKindClass
        }
        
        //AllListVC跳转到ListDetailVC，添加addList
        //ListDetailVC需要向AlllistVC反向传值，因此需要设置代理；
        //ListDetailVC通过其导航控制器找到
        else if segue.identifier == "addListSegue" {
            let nvController = segue.destination as! UINavigationController
            let controller = nvController.topViewController as! ListDetailViewController
            controller.delegate = self
            controller.listToEdit = nil
        }
    }
    

    

    
    //实现ListDetailVC的delegate方法
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    func listDetailViewController(_ controller:ListDetailViewController, didFinishAdding checklistKind:ChecklistKindClass) {
        dataModel.lists.append(checklistKind)
        dataModel.sortLists()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller:ListDetailViewController, didFinishEditing checklistKind:ChecklistKindClass) {
        dataModel.sortLists()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    //实现UINavigationControllerDelegate，返回时置indexPath.row为-1（就像ListDetailViewController实现textField的delegate一样
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self {
            //UserDefaults.standard.set(-1, forKey: "listIndex")
            dataModel.indexOfLastList = -1
        }
    }

    

    

    
    
    

    


    

}
