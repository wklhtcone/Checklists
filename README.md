- 如果有的GIF加载不出来，移步[待办清单-iOS项目说明](https://blog.csdn.net/qq_35087425/article/details/112884120)
## 1.功能与`ViewController`介绍
**1. 查看已有待办分类，并可以新增、编辑待办分类，并为该分类选择图标**

 - 每个分类显示其中还未完成的项目，这是`AllListsViewController`

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210126163123240.JPEG?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1MDg3NDI1,size_16,color_FFFFFF,t_70)

 - 新增、编辑待办分类，这是`ListDetailViewController`

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210126163145968.JPEG?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1MDg3NDI1,size_16,color_FFFFFF,t_70)

 - 为分类选择图标，这是`IconPickerViewController`

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210126163201827.JPEG?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1MDg3NDI1,size_16,color_FFFFFF,t_70)


**2. 每个分类中有它的待办清单，可以新增、编辑待办事项，并可选择提醒时间、是否提醒**
- 可以点击行来标记是否完成该事项，这是`ChecklistsViewController`

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210126163237694.JPEG?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1MDg3NDI1,size_16,color_FFFFFF,t_70)

- 可以新增、编辑待办事项并选择提醒时间，这是`ItemDetailViewController`

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210126163255600.JPEG?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1MDg3NDI1,size_16,color_FFFFFF,t_70)



**3. 使用`plist`保存待办数据**

![实体机](https://img-blog.csdnimg.cn/20210126164309766.png)
![模拟器](https://img-blog.csdnimg.cn/20210126164322398.png)

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210126163847848.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1MDg3NDI1,size_16,color_FFFFFF,t_70)

**4. 使用`UserDefault`和导航控制器代理方法实现保存和恢复上次的浏览位置**

![在这里插入图片描述](https://img-blog.csdnimg.cn/2021012616484783.GIF)


**5. 用户可以为每条待办事项选择提醒时间，并会按时收到本地通知**

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210126165257413.JPEG?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1MDg3NDI1,size_16,color_FFFFFF,t_70)


## 2.数据结构
**1. 对于待办事项**
- 应包含的变量：
事项ID、事项名、是否完成、提醒时间、是否提醒；其中事项ID是用于设置本地提醒时的`identifier`

- 应包含的方法：
重写`init`（方便新增待办事项）、重写`deinit`（删除待办事项时本地通知也要移除）、切换是否完成、设置本地通知、移除本地通知

代码如下，方法的具体实现省略，见源文件

```swift
class ChecklistClass: NSObject, Codable{
	//成员变量
	var itemID = 0
    var text = ""
    var flag = false
    var shouldRemind = false
    var dueDate = Date()
    //方法
    init(text: String, flag: Bool) {
    }
    deinit {
    }
    func changeFlag() {
    }
    func setNotification() {
    }
    func removeNotification() {
    }
 }
```

**2. 对于待办分类**
- 应包含的变量：
分类名、分类图标名、事项数组

- 应包含的方法：
重写`init`（方便新增待办分类）、计算未完成的待办事项数

```swift
class ChecklistKindClass: NSObject, Codable {
    var name = ""
    var iconName = "No Icon"
    var items = [ChecklistClass]()
    init(name: String, iconName: String = "No Icon") {
    }
    func cntNoflag() -> Int {
    }
}
```
**3. 顶层数据结构**
- 顶层数据用来存放待办分类数组、实现数据的存储和读取，并封装一些方法（如存取用户上次点击的待办分类序号、计算下一条事项ID）供外部方法调用。
- `AppDelegate`是整个App中最顶层的对象，因此让`AppDelegate`持有DataModel是最合理的，它可以向任何需要DataModel的视图控制器传递这一对象

```swift
class DataModel {
    var lists = [ChecklistKindClass]()
    //数据持久化
    func documentsDirectory() -> URL {
    }
    func dataFilePath() -> URL {
    }
    func loadLists(){
    }
    func saveLists(){
    } 
    //初始化时加载plist数据
    init() {
        loadLists()
    }
    //存取上一次访问的分类序号
    var indexOfLastList : Int {
        get {
            return UserDefaults.standard.integer(forKey: "listIndex")
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: "listIndex")
        }
    }
    //类方法直接用类名调用，ChecklistClass的初始化时调用生成不重复的事项ID
    class func nextItemID() -> Int {
        let userDefaults = UserDefaults.standard
        //一开始没有ItemID，返回0；
        let itemID = userDefaults.integer(forKey: "ItemID")
        userDefaults.set(itemID + 1, forKey: "ItemID")
        userDefaults.synchronize()
        return itemID
    }
}
```
## 3.`ViewController`关系图与转场
**1. `ViewController`关系图简介**
- 以下“`xxViewController`”简称“`xxVC`”
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210126223754190.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1MDg3NDI1,size_16,color_FFFFFF,t_70)

- `AllListsVC`与`ChecklistsVC`在同一个导航控制器中，在`AllListsVC`中点击某分类行进入`ChecklistsVC`，`ChecklistVC`点击左上角可返回上一级

- 在`ChecklistsVC`界面，点击右上角“+”或点击某行的Detail Disclosure，可进入`ItemDetailVC`进行添加/编辑该项目；`ChecklistsVC`通过`ItemDetailVC`的导航控制器找到它

- 在`AllListsVC`界面，点击右上角“+”或点击某行的Detail Disclosure，可进入`listDetailVC`进行添加/编辑该分类；`AllListsVC`通过`listDetailVC`的导航控制器找到它。

> **关于为什么要将`ItemDetailVC`嵌入一个新的导航控制器中：**
> - 这里使用`present modally`转场方式，是一个弹出的页面效果。如果不嵌入导航控制器，无法显示该页的`title`（添加还是编辑）、也无法在顶部添加done、cancel的`Label`
> - 如果不给`ItemDetailVC`加导航控制器，也可以使用`show`转场，不过这种的话它与`ChecklistsVC`处于同一个导航控制器下，就不是页面弹出的效果而是页面层级的关系
> - 我个人觉得添加、编辑待办事项用弹出页面的方式更好一些，而不像待办分类`AllListsVC`和待办事项`ChecklistsVC`那两个层级的页面关系；同理，添加、编辑待办分类的`listDetailVC`也嵌入到导航控制器中。
> - 此外，如果是`present modally`转场，应该在done、cancel（完成编辑、取消编辑）的代理方法中用dismiss；如果是`show`转场，它们处于同一个导航控制器，应该用`navigationController`的`popViewController`方法，因为导航控制器是一个类似栈的结构，是`ViewController`的容器，栈顶放的是当前显示的`ViewController`。


![在这里插入图片描述](https://img-blog.csdnimg.cn/20210126170517914.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1MDg3NDI1,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210126170527769.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1MDg3NDI1,size_16,color_FFFFFF,t_70)




**2. 通过Storyboard转场**
- 以添加、编辑待办事项为例（`ChecklistsVC`转场至`ItemDetailVC`）


1. 按住ctrl，连接“+”的 `Label` 和`ItemDetailVC`的导航控制器，选择“Action Segue”中的`present modally`，并在属性器中填入转场ID：addItemSegue
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210121170020784.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1MDg3NDI1,size_16,color_FFFFFF,t_70)
2. 按住ctrl，连接 `Table View Cell` 和`ItemDetailVC`的导航控制器，选择“Accessory Action”中的`present modally`，并在属性器中填入转场ID：editItemSegue。
- 注意要选中cell与导航控制器相连（而不是cell中的`Label`），因为那个Detail Disclosure的accessory是cell的属性
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210121170029195.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1MDg3NDI1,size_16,color_FFFFFF,t_70)
3. 代码及注释如下，将`ChecklistVC`设为`ItemDetailVC`的`delegate`是为了反向传值

```swift
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

```

**3. 通过`Table View Delegate`手动转场**
- 以进入某个待办分类为例（`AllListsVC`转场至`ChecklistsVC`）

1. 按住ctrl，连接`AllListsVC`和`ChecklistsVC`，选择“Manual Segue”中的`show`，并在属性器中填入转场ID：showItemSegue![在这里插入图片描述](https://img-blog.csdnimg.cn/2021012215174814.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1MDg3NDI1,size_16,color_FFFFFF,t_70)
2. 重写`AllListsVC` Table View的代理方法，在点击某一行时手动触发转场，并正向传值告诉`ChecklistsVC`选择的是哪个待办分类

```swift
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {
    let checklistKind = dataModel.lists[indexPath.row]
    //向ChecklistViewController传checklistKind对象
    performSegue(withIdentifier: "showItemSegue", sender: checklistKind)
}

```


**4. 通过`Table View Delegate`与`present`方法**
- 以编辑某个待办分类为例，从`AllListsVC`到`ListDetailVC`
1. 在Storyboad中，给`ListDetailVC`的导航控制器填入ID![在这里插入图片描述](https://img-blog.csdnimg.cn/20210122153652928.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1MDg3NDI1,size_16,color_FFFFFF,t_70)
2. 重写`AllListsVC` Table View的代理方法，当点击某一行的Accessory时被调用：Storyboard根据上面的ID实例化一个视图控制器（就是`ListDetailVC`的导航控制器
）并展现在屏幕上，效果和转场类似。

```swift
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
```
- 这里将`ListDetailVC`嵌入一个单独导航控制器的原因上面已经提到了，在使用`present`时是一个弹出的效果，如果不嵌入导航控制器无法显示`title`的顶部`Label`；
- 如果不用`present`，则不用将`ListDetailVC`嵌入一个单独的导航控制器：用导航控制器的`pushViewController`方法（相当于转场中的`show`），相应的要将实例化视图控制器的ID填入`ListDetailVC`中，代码如下：

```swift
override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
    let controller = storyboard!.instantiateViewController(withIdentifier: "ListDetailNavigationController") as! ListDetailViewController
    controller.delegate = self
    let checklistKind = dataModel.lists[indexPath.row]
    controller.listToEdit = checklistKind
    navigationController?.pushViewController(controller, animated: true)
}
```

## 4.制作`Table View Cell`的方式
**1. 标准cell**
- 以`ChecklistsVC`为例，在storyboard中放置一个cell并填入ID
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210122161716474.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1MDg3NDI1,size_16,color_FFFFFF,t_70)
- 数据源方法，这个`dequeueReusableCell`方法是有`indexPath`参数的

```swift
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
    //省略设置cell内容的部分
    return cell
}
```

**2. 静态cell**
- 在编辑、添加页面（`ItemDetailVC`、`ListDetailVC`）中使用的是这种，不需要数据源方法，适用于提前知道cell内容的情况
- 比如下图中的 section 0 的cell中是一个`TextField`，section 1 的cell是几个`Label`、`Switch`
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210122162633520.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1MDg3NDI1,size_16,color_FFFFFF,t_70)

**3. 手动创建cell**
- 以`AllListsVC`为例，不需要在storyboard中放置cell
- 数据源中`dequeueReusableCell`方法是没有`indexPath`参数的，因为在storyboard中没有相应的cell，如果加了`indexPath`参数程序会崩溃
- 没有`indexPath`参数的`dequeueReusableCell`在找不到可重用的cell时会返回`nil`，因此需要在`makeCell`方法中else部分手动创建cell，可以指定cell的style。比如待办分类cell的style是`subtitle`，可以在子标题显示该分类未完成的事项数

```swift
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = makeCell(for:tableView)
    //省略设置cell内容的部分
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
```


**4. 使用nib**
- 类似于一个只包含`UITableViewCell`的storyboard，在storyboard之外使用，用法和标准的cell相似，本App中未使用。

## 5.`Table View`的数据源和代理方法
1.  `Table View`中 `indexPath.row` 是数据（`Model`），cell是视图（`View`），`Table View Controller`通过数据源和代理方法将它们联系在一起

2. 以待办事项`ChecklistsVC`为例，可以显示已添加、编辑的事项，并通过点击行来标记已完成/未完成该事项，并可以进行左滑删除该事项。数据源和代理方法如下：

- 数据源：

```swift
// Table View Data Source
//根据数据返回cell的行数
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int ) -> Int {
    return checklistKind.items.count
}

//生成cell并根据数据设置cell的内容
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
    let item = checklistKind.items[indexPath.row]
    
    configCellText(for:cell, with:item)
    configCellFlag(for:cell, with:item)

    return cell
}

//删除cell及相应数据
override func tableView(_ tableView:UITableView, commit editingStyle:UITableViewCell.EditingStyle,forRowAt indexPath:IndexPath){
    checklistKind.items.remove(at: indexPath.row)
    let indexPaths = [indexPath]
    tableView.deleteRows(at: indexPaths, with: .automatic)
}
```

- 代理方法：

```swift
// Table View Delegate
//点击行，选择是否已完成，更新 Model 和 View
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let cell=tableView.cellForRow(at:indexPath){
        let item = checklistKind.items[indexPath.row]
        item.changeFlag()
        configCellFlag(for:cell, with:item)
    }
    //防止被选中行一直是被选中状态（变灰）
    tableView.deselectRow(at: indexPath, animated: true) 
}
```

## 6.`ViewController`之间传值
- 数据在视图控制器间传递有两种方法：
1. 从`A`到`B`。当界面`A`打开界面`B`时，`A`可以给`B`需要的数据。在`B`的`ViewController`中创建一个实例变量，然后`A`转场到`B`时给这个变量赋值就可以了，赋值通常都是在`prepare(for:sender:)`中完成。
2. 从`B`到`A`，`B`回传数据给`A`则需要使用代理（或者说委托）。

- 下面以从待办事项页面（`ChecklistsVC`）进入事项编辑页面（`ItemDetailVC`）为例说明。

### 6.1 正向传值
- `ItemDetailVC` 有两个功能：添加和编辑，分别在 `ChecklistsVC` 点击“+”、cell的Detail Disclosure进入；应按照不同的功能显示相应的标题，且编辑时文本框中为 `ChecklistsVC` 传来的内容。
- 为了区别到底是“添加”还是“编辑”，需要在`ItemDetailVC`中新增一个实例变量，根据该变量是否为`nil`来判断，而给这个实例变量赋值的过程就发生在`prepare(for:sender:)`中。

1. 在 `ItemDetailVC` 中新增实例变量和判断

```swift
// ItemDetailViewController.swift
var itemToEdit:ChecklistClass?
override func viewDidLoad(){
    super.viewDidLoad()
    if let item = itemToEdit{
        title = "编辑事项"
        textField.text = item.text
    }
}
```

> itemToEdit变量有可能为`nil`，因此类型是可选型`ChecklistClass?`


2. 在`ChecklistsVC`中，转场进入编辑页面时，向`ItemDetailVC`中的实例变量赋值

```swift
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
```

> - `prepare(for:sender:)`中包含一个参数`sender`，它会引用触发转场的控件：比如Add按钮的`UIBarButton`对象、用于列表中某一行的`UITableViewCell`等，在这里是点击`ChecklistsVC`的某一行转场至编辑，因此是`UITableViewCell`
> - `tableView.indexPath(for:)`方法用于获得某一个cell的`indexPath`，从而获得行号，然后去`Model`中找到这条数据赋值给`itemToEdit`变量。它的返回值是`IndexPath?`，即可能为`nil`，因此使用`if
> let`


### 6.2 代理模式反向传值
- 要让 `B` 向 `A` 传值，需要将 `A` 设为`B` 的代理，`B` 是委托方，`A` 是代理方，在两个对象之间创建代理的步骤如下:

#### 委托方`B`
1. 声明代理协议
2. 声明一个`weak`的`delegate`变量
3. 在某些事件触发的时候，让`B`向它的`delegate`变量发送消息：比如用户点击done按钮完成添加/编辑、或cancel取消，让B的`delegate`执行协议中相应的方法

#### 代理方`A`
1. 遵守协议
2. 实现协议中的方法
3. 将`B`的`delegate`设为`A`

#### 协议`protocol`
- 协议就是`B`委托代理方`A`去完成的事情，在`B`中声明、在`A`中遵守并实现
- 比如在这个场景下，协议中方法要实现的就是：
 1. 点击done按钮，协议中的方法将 `ItemDetailVC` 新增/编辑的 item 更新到数据模型 `Model` 中，同时将新增/编辑的数据更新到`ChecklistsVC` 的 `View` 并将视图切回`ChecklistsVC` 
 2.  点击cancel 按钮，数据和`ChecklistsVC`的视图都不用更新，视图切回`ChecklistsVC`就行

> **为什么`delegate`变量要用`weak`修饰：**
> - 代理方`A`创建委托方对象`B`，并设`B`的`delegate`变量是自己，此时`A`已经强引用了`B`；
> - 如果`B`的`delegate`变量对`A`也是强引用，会造成循环引用，两个对象都无法释放导致内存泄漏
> - 参考链接：[你真的了解iOS代理设计模式吗？](https://www.jianshu.com/p/2113ffe54b30)



- 这个例子中，`A`是`ChecklistsVC`，`B`是`ItemDetailVC`，代码及注释如下：

#### 委托方`ItemDetailVC`
1. 声明代理协议

```swift
protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController,didFinishAdding item: ChecklistClass)
    func itemDetailViewController(_ controller: ItemDetailViewController,didFinishEditing item: ChecklistClass)
}
```

2. 声明`delegate`变量

```swift
weak var delegate : ItemDetailViewControllerDelegate?
```

3. 在某些事件触发的时候向`delegate`变量发送消息

```swift
@IBAction func done(){
    if let item = itemToEdit {
    	//修改item属性代码省略
        delegate?.itemDetailViewController(self, didFinishEditing: item)
    }
    else{
        //新对象在addItemVC中创建，通过delegate传到checkListVC；设置item属性代码省略
        let item = ChecklistClass(text: textField.text!, flag: false)
        delegate?.itemDetailViewController(self, didFinishAdding: item)
    }
}
```

```swift
@IBAction func cancel(){
    delegate?.itemDetailViewControllerDidCancel(self)
}
```

#### 代理方`ChecklistsVC`
1. 遵守协议

```swift
class ChecklistsViewController: UITableViewController, ItemDetailViewControllerDelegate {
	//balabala
}
```

2. 实现协议中的方法

```swift
func itemDetailViewController(_ controller: ItemDetailViewController,didFinishAdding newItem: ChecklistClass){
    //addItem中创建新对象放在addItemVC中，通过delegate传到checkListVC，在delegate方法中完成对Model和View的更新
    let newRowIndex = checklistKind.items.count
    checklistKind.items.append(newItem)

    let newIndexPath = IndexPath(row:newRowIndex, section: 0)
    let newIndexPaths = [newIndexPath]
    tableView.insertRows(at: newIndexPaths, with: .automatic)
    
    dismiss(animated: true, completion: nil)
}
```

```swift
func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistClass) {
    //找到 Model 中被编辑item的index -> 更新 View 中对应的cell内容
    if let index = checklistKind.items.firstIndex(of: item){
        let indexPath = IndexPath(row:index, section: 0)
        if let cell = tableView.cellForRow(at: indexPath){
            configCellText(for: cell, with: item)
        }
    }
    dismiss(animated: true, completion: nil)
}
```

```swift
func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController){
    dismiss(animated: true, completion: nil)
}
```

3. 将委托方`ItemDetailVC`的`delegate`设为自己

```swift
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
```

## 7. 使用`UITextField`代理方法禁止空输入
- 在编辑/添加待办事项时，应该监测用户每次修改内容时文本框内容是否为空，空则不允许用户点击键盘或顶部的done按钮

1.  对于键盘的done来说较为简单
-  将TextField的Did End On Exit事件和视图控制器中的`@IBAction done()`方法关联
-  勾选Auto-enable Return Key
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210123212202195.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1MDg3NDI1,size_16,color_FFFFFF,t_70)

2. 对于顶部的 `Bar Button` 来说，可以使用 `TextField` 的代理方法：每次 `TextField` 内容被修改时向 `ViewController` 发送消息，`ViewController` 根据 `TextField` 的内容来控制 `Bar Button` 的状态。
- `ItemDetailVC`遵守文本框的代理协议

```swift
class ItemDetailViewController: UITableViewController,UITextFieldDelegate {
	//balabala
}
```

- 告诉`TextField`它有一个代理
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210123213836230.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1MDg3NDI1,size_16,color_FFFFFF,t_70)
- 实现代理方法

```swift
//ItemDetailVC通过控制outlet的值来禁用barButton
@IBOutlet weak var doneBarButton: UIBarButtonItem! 
@IBOutlet weak var textField: UITextField! 

//实现delegate方法
func textField(_ textField:UITextField,shouldChangeCharactersIn range:NSRange, replacementString string:String) -> Bool{
    let oldText = textField.text! as NSString
    let newText = oldText.replacingCharacters(in: range, with: string) as NSString
    doneBarButton.isEnabled = (newText.length > 0)
    return true
}
```


> - `textField(shouldChangeCharactersIn, replacementString)`是 UITextField 的代理方法之一
> 1. 每次文本框的内容变化之后都会调用，不论是输入、删除还是粘贴
> 2. 不能直接得到新文本的内容，只有当文本变化时才可以，通过读取文本框的新内容，并替换自身，就得到了新的字符串对象newText
> 3. 关键字`as NSString`的作用就是将oldText转为`NSString`类型的常量，`String`类型没有`replacingCharacters(in:with:)`方法

## 8. 数据持久化
### 8.1 使用Plist存取数据
**1. 序列化与反序列化**
- 序列化：将对象转化为二进制流`NSData`存入文件中
- 反序列化：将文件中的二进制流`NSData`转化为对象

**2. NSCoding与Codable协议**
- 序列化和反序列化默认只支持基本对象类型（`NSString`、`NSArray`等）和基本数据类型和二进制数据之间的转换。
- 如果要实现自定义类型和`NSData`二进制流之间的相互转换，需要让自定义类遵守`NSCoding`协议，并在类中实现编码、解码方法。以自定义的待办事项类`ChecklistClass`为例，假设它有两个成员变量`text`、`flag`，遵守`NSCoding`协议并实现编解码的代码如下：

```swift
class ChecklistClass: NSObject,NSCoding {
	//遵守NSCoding协议实现编码
	func encode(with aCoder: NSCoder) {
	    aCoder.encode(text, forKey: "Text")
	    aCoder.encode(flag, forKey: "Flag")
	}
	//遵守NSCoding协议实现解码
	required init?(coder aDecoder: NSCoder) {
	    text = aDecoder.decodeObject(forKey: "Text") as! String
	    flag = aDecoder.decodeBool(forKey: "Flag")
	    super.init()
	}  
}

```
- Swift 4引入了`Codable`协议，与`NSCoding`协议不同的是：如果自定义的类中全都是基本数据类型、基本对象类型，它们都已经实现了`Codable`协议，那么这个自定义的类也默认实现了`Codable`，无需再实现编解码，只需要在自定义的类声明它遵守`Codable`协议即可。

```swift
class ChecklistClass: NSObject,Codable {
	//属性全是基本数据类型、基本对象类型时，无需实现编解码
}
```

> 参考链接：
> - [Swift中的NSCoding和Codable](https://www.iloveanan.com/swiftzhong-de-nscodinghe-codable.html)
> - [Swift之Codable实战技巧](https://zhuanlan.zhihu.com/p/50043306)

**3. 文件路径**
- 在iOS中，沙盒是一种为了系统安全而为app设置的一种访问屏障。沙盒目录是app的内部空间，用来保存应用资源和数据，app只能访问自己的沙盒目录。
- 在app所属的沙盒中，可以将文件存储在Docments目录下。Documents目录主要用于存储大的文件或需要频繁更新的数据，目录中的文件可以进行iTunes或iCloud备份。
- 获取Documents及文件存储路径的代码如下：

```swift
func documentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

func dataFilePath() -> URL {
    return documentsDirectory().appendingPathComponent("Checklists.plist")
}
```

**4. 保存数据至`plist`**
- `plist`是Property List的简写，是一种XML文件，主要用来存储序列化后的对象
- 第2节-数据结构中提到了，保存和读取数据的操作都被封装到了顶层数据结构DataModel中
- 方法将 lists（`ChecklistKindClass`待办分类的对象数组）转为2进制数据并存到上面获得的文件路径中

```swift
var lists = [ChecklistKindClass]()

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
```
- **`AppDelegate` 与存储时机：**
1. 应该在App将要终止、或进入后台时，对数据进行保存。
2. APP启动时基本上每一次的状态改变都会调用一些`delegate`中的方法来响应当前的状态，让我们可以对程序进行特定操作，在`AppDelegate`中进行这些操作。
3. `AppDelegate`是整个App中最顶层的对象，因此让`AppDelegate`持有DataModel是最合理的，它可以向任何需要DataModel的视图控制器传递这一对象。
4. 在AppDelegate.swift中，初始化DataModel对象，并在App即将终止或进入后台时保存数据，代码如下：

```swift
// 在AppDelegate.swift中
class AppDelegate: UIResponder, UIApplicationDelegate {
	let dataModel = DataModel()
	func saveData() {
	    dataModel.saveLists()
	}
	
	//App将要终止时
	func applicationWillTerminate(_ application: UIApplication) {
	    saveData()
	}
	//App进入后台时
	func applicationDidEnterBackground(_ application: UIApplication) {
	    saveData()
	}
}
```

> 参考链接：[iOS开发-AppDelegate](https://blog.csdn.net/qq_36557133/article/details/86770301)

**5. 从`plist`读取数据**
- 方法将路径中的2进制文件转化为lists（`ChecklistKindClass`待办分类的对象数组）

```swift
var lists = [ChecklistKindClass]()

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
}
```

- **`AppDelegate` 与读取时机：**
1. 应该在App一启动时，就初始化DataModel并读取数据
2. 将读入数据的DataModel传给首个视图控制器`AllListsViewController`
3. `UIWindow`是最高层级的视图，通过它的`rootViewController`请求第一个视图控制器，本App中是`AllListsViewController`的导航控制器，再通过导航控制器的ViewController数组找到`AllListsViewController`
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210124112850803.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1MDg3NDI1,size_16,color_FFFFFF,t_70)


```swift
// 在AppDelegate.swift中
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	let dataModel = DataModel()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let nvController = window!.rootViewController as! UINavigationController
        let controller = nvController.viewControllers[0] as! AllListsViewController
        controller.dataModel = dataModel
        return true
   }
}
```
- 初始化DataModel时就要加载数据，因此要重写DataModel的`init()`
```swift
class DataModel {
    var lists = [ChecklistKindClass]()
    //初始化时加载plist数据
    init() {
        loadLists()
    }
    func loadLists(){
    }
}
```
### 8.2 `UserDefault` 
**1. 适用范围：**
- App在运行过程中，有时候需要临时保存一些变量（例如设置类的、屏幕浏览记录等），在下次运行时读取，此时可以用轻量级的持久化工具`NSUserDefault`，Swift中叫`UserDefault`

**2. 需求：**
- 如用户正在“生日分类”的待办事项中操作，有事情切换到了其他的App，一段时间后挂起的App可能会被释放内存，下次打开App时会进入主页面而不是“生日分类”。为了下次启动可以进入之前的浏览位置，可以使用`UserDefault`保存之前待办分类的`indexPath.row`

**3. 做法：**
1.  在主页面（`AllListsVC`）进入相应分类待办事项（`ChecklistsVC`）的转场逻辑中，将行号存入`UserDefault`

```swift
//点击cell转场，跳转到ChecklistVC
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {
    //转场时记录转到第几行
    UserDefaults.standard.set(indexPath.row, forKey: "listIndex")
    let checklistKind = dataModel.lists[indexPath.row]
    //向ChecklistViewController传checklistKind对象
    performSegue(withIdentifier: "showItemSegue", sender: checklistKind)
}
```

2. 用户点击back返回主页面`AllListsVC`时，移除刚才记录的行号，用导航控制器的代理方法`navigationController(willShow)`实现

```swift
func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    if viewController === self {
        UserDefaults.standard.set(-1, forKey: "listIndex")
        print("我要改成 -1 了")
    }
}
```

- `AllListsVC`成为导航控制器的代理，当导航控制器中出现一个新的视图控制器时都会调用这个方法，用户点击back回到主页面时，将上次访问的行号设为-1，意为移除刚才访问的位置
- 实现代理方法的同时，也要让`AllListsVC`遵守代理协议；也要将`AllListsVC`设为导航控制的代理（在第三步）

```swift
class AllListsViewController: UITableViewController, UINavigationControllerDelegate { 	
	//balabala
} 
```



3. 根据`UserDefault`中保存的行号选择是否跳转

```swift
override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    //AllListsVC设自己为导航控制器的代理
    navigationController?.delegate = self
    print("This is viewDidAppear")
    let index = UserDefaults.standard.integer(forKey: "listIndex")
    if index >= 0 && index < dataModel.lists.count {
        let checklistKind = dataModel.lists[index]
        performSegue(withIdentifier: "showItemSegue", sender: checklistKind)
    }
}
```

> - **为什么将`AllListsVC`注册为导航控制器的代理、以及转场控制的代码放在`viewDidAppear`中？**
> 
>  1. 首先，`navigationController(willShow)`方法不止在点击back回到主页面时会调用，只要导航控制器中出现一个新的视图控制器时都会调用，如每次App启动显示主页面时
>  2. 如果将`navigationController?.delegate
> = self`写在`viewDidAppear()`之前，每次App启动时主页面还没显示出来，就会调用`navigationController(willShow)`将上次访问行号置为-1，无法完成转场，因此要将注册为导航控制器的代理放在主页面显示完成后的`viewDidAppear()`
>  3. 虽然从某个待办分类返回主页面时也会调用`viewDidAppear()`，但它在`navigationController(willShow)`之后才调用，回到主页面时上次访问行号已设为-1，不会重复转场，只有在每次App启动时才会执行转场

- 效果如下：

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210125225928760.GIF)



**4.  做个实验验证一下`navigationController(willShow)`和`viewWillAppear()`的调用顺序**
1. 将转场逻辑写在页面显示前`viewWillAppear()`

```swift
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
    
    print("This is viewWillAppear")
    let index = UserDefaults.standard.integer(forKey: "listIndex")
    if index >= 0 && index < dataModel.lists.count {
        let checklistKind = dataModel.lists[index]
        performSegue(withIdentifier: "showItemSegue", sender: checklistKind)
    }
}

override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    navigationController?.delegate = self
    print("This is viewDidAppear")
}
```


2. 返回主页面效果：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210125204012778.GIF)

- 可见返回主页面时，会发生重复转场，即转场逻辑在行号置为-1之前执行
- 查看`print()`输出验证：

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210125214059142.png)

- 因此这几个方法执行的顺序是 `viewWillAppear()` ——> `navigationController(willShow)` ——> `viewDidAppear()`


**5. 将设置代理、转场逻辑都写在`viewDidLoad`中可以实现吗？**

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    
    //AllListsVC设自己为导航控制器的代理
    navigationController?.delegate = self
    print("This is viewDidLoad")
    
    let index = UserDefaults.standard.integer(forKey: "listIndex")
    if index >= 0 && index < dataModel.lists.count {
        let checklistKind = dataModel.lists[index]
        print("我要转场了")
        performSegue(withIdentifier: "showItemSegue", sender: checklistKind)
    }
}
```

- `viewWillAppear()`发生在`navigationController(willShow)`之前，而`viewDidLoad()`在`viewWillAppear()`之前， 因此，还没等上次访问位置改为 -1 就完成了转场，似乎没问题，运行效果如下：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210125223822217.GIF)
- 可以看出，第一次成功跳转到了上次的访问位置，在没有回到主页面的情况下将App终止，第二次再进时本该还是原来的位置，却到了主页面

![在这里插入图片描述](https://img-blog.csdnimg.cn/2021012522292733.png) 

- 查看第一次`print()`的情况，虽然已经转场但还是执行了`viewWillAppear()`和导航控制器的代理方法`navigationController(willShow)`，上次访问行号被设为 -1，第二次再打开时就显示了主页。

> - 因此要想每次都能打开时跳转到上次的浏览位置，还是要将`navigationController?.delegate = self`、转场控制写在主页面显示完成后的`viewDidAppear()`
> - 既能保证返回主页时才会移除上次的访问记录，也能保证只有每次启动App时才会触发转场，因为返回主页时`viewDidAppear()`总是发生在`navigationController(willShow)`之后

**6. 封装`UserDefault`操作**
- 隐藏执行细节是面向对象的重要原则之一，将设计`UserDefault`的操作封装在数据模型DataModel中

```swift
class DataModel {
    var indexOfLastList : Int {
        get {
            return UserDefaults.standard.integer(forKey: "listIndex")
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: "listIndex")
        }
    }
}
```
- 这样其他类不需要关心`UserDefault`的细节、直接调用DataModel中的属性就可以了
- 类似于Objc的`property`，点语法在左边调用`set`，在右边调用`get`
- 以后如果要把这个属性存到其他地方也只需要修改DataModel

```swift
//修改前后对比

let index = UserDefaults.standard.integer(forKey: "listIndex")
let index = dataModel.indexOfLastList


UserDefaults.standard.set(indexPath.row, forKey: "listIndex")
dataModel.indexOfLastList = indexPath.row


UserDefaults.standard.set(-1, forKey: "listIndex")
dataModel.indexOfLastList = -1

```
## 9.本地通知
**1.  用户在`ItemDetailVC`中点击done按钮时，更新`ChecklistClass`类各变量的值，并调用`setNotification()`方法安排本地通知**

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210126151108859.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1MDg3NDI1,size_16,color_FFFFFF,t_70)

```swift
//变量定义
@IBOutlet weak var textField: UITextField! //待办事项内容
@IBOutlet weak var dueDateLabel: UILabel!//.text是String类型
@IBOutlet weak var shouldRemindSwitch: UISwitch!//.isOn是Bool类型
@IBOutlet weak var datePicker: UIDatePicker!//.date是Date类型
var dueDate = Date()//Date类型，为了更新待办事项ChecklistClass类中的变量


//datePicker代理方法，datePicker更改后更新 Label 视图和 Model 中的值
@IBAction func dataChanged(_ datePicker: UIDatePicker) {
	//更新 Model 和 View
    dueDate = datePicker.date
    updateDueDateLabel()
}

func updateDueDateLabel() {
    let nowDate = DateFormatter()
    nowDate.dateStyle = .medium
    nowDate.timeStyle = .short
    dueDateLabel.text = nowDate.string(from: dueDate)
}

```

```swift
@IBAction func done(){
	//itemToEdit不为nil，编辑模式
    if let item = itemToEdit {
        item.text = textField.text!
        item.shouldRemind = shouldRemindSwitch.isOn
        item.dueDate = dueDate
        //安排本地通知
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
```
**2.  如果满足两个条件，就会安排一条本地通知**
-  `UISwitch`控件的值`shouldRemindSwitch.isOn == YES`
-  用户选择的时间`dueDate`>当前时间

**3. 步骤及代码如下：**
- 获取待办事项的内容`text`，放入通知的`content.body`中
- 从`dueDate`中获取时间，月、日、时、分
- 设置通知触发条件为dateMatching
- 将待办事项的`itemID`转为String，并作为标识符创建一个`UNNotificationRequest`
- 将通知加入`UNUserNotificationCenter`，这个对象可以跟踪所有本地通知，并在时间到了的时候触发它们

```swift
class ChecklistClass: NSObject, Codable{
    var text = ""
    var itemID = 0
    var shouldRemind = false
    var dueDate = Date()
	
    func setNotification() {
       removeNotification()//移除该itemID对应的旧通知并重新安排，用于编辑
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
    
   //待办事项删除时移除通知
   deinit {
       removeNotification()
   } 	
}
```
- 编辑某个已存在的待办事项，为了更新通知中的内容`content`、提醒时间`trigger`，应该移除该`itemID`已有的旧通知，再重新添加
- 删除待办事项时也要移除通知，因此要重写`deinit()`方法
- 第 2 节数据结构中提到了，`itemID`由顶层数据结构DataModel生成，保证每个待办事项都有一个独特的ID，代码如下：

```swift
//相当于static方法，调用无需实例对象
class func nextItemID() -> Int {
    let userDefaults = UserDefaults.standard
    //一开始没有ItemID，返回0；
    let itemID = userDefaults.integer(forKey: "ItemID")
    userDefaults.set(itemID + 1, forKey: "ItemID")
    return itemID
}
```
**4. `AppDelegate`是推送通知的代理类**
- 将`AppDelegate`注册为`UNUserNotificationCenter`的代理并遵守协议
- 通知仅在用户允许的情况下通知，首次启动App时需要询问用户是否接收通知
- `application(didFinishLaunchingWithOptions)`在App启动后调用，可以把注册代理、请求通知的代码写在这里

```swift
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    
    let dataModel = DataModel()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
        let nvController = window!.rootViewController as! UINavigationController
        let controller = nvController.viewControllers[0] as! AllListsViewController
        controller.dataModel = dataModel
        
        //AppDelegate注册为UNUserNotificationCenter的代理
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        //请求通知
        center.requestAuthorization(options: [.alert, .sound], completionHandler: {
            granted, error in
        })

        return true
    }
}
```
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210126161513291.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM1MDg3NDI1,size_16,color_FFFFFF,t_70)



