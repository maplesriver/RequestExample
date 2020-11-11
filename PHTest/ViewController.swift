//
//  ViewController.swift
//  PHTest
//
//  Created by maples on 2020/11/11.
//

import UIKit

class ViewController: UIViewController {
    /// 数据管理类
    lazy var dataM:DataManager = DataManager(delegate: self)
    
    private var _showItems:NSArray = [] /// 当前数据，用于展示实时请求结果

    @IBOutlet weak var tableView:UITableView!
    
    // MARK: - private
    private func setUI() {
        navigationItem.title = NAV_TITLE_MAIN
        
        /// 右菜单历史按钮
        let rightBarButtton = UIBarButtonItem(title: HISTORY_BTN_NAME, style: .plain, target: self, action: #selector(historyBtnAction))
        navigationItem.rightBarButtonItem = rightBarButtton
        
        /// 开始抓取数据
        dataM.fetchData()
    }
    
    // MARK: - Eventhandle
    @objc private func historyBtnAction() {
        let historyVC = HistoryTableVC.init()
        historyVC.items = dataM._historyItems
        navigationController?.pushViewController(historyVC, animated: true)
    }
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setUI()
    }

    

}

extension ViewController: DataManagerDelegate{
    func updateData(with newData: Dictionary<String, Any>) {
        let tempItems = NSMutableArray(array: _showItems)
        /// 新增的数据显示在最上边
        tempItems.insert(newData, at: 0)
        /// 更新
        _showItems = tempItems.copy() as! NSArray
//        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _showItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 复用 cell
        var cell = tableView.dequeueReusableCell(withIdentifier: CellReuseId)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: CellReuseId)
        }

        
        if let data = _showItems[indexPath.row] as? Dictionary<String,Any> {
            cell?.textLabel?.text = data[kNAME_DATE] as? String
            if let dic = data[kNAME_JSON] as? Dictionary<String,String> {
                cell?.detailTextLabel?.numberOfLines = 3
                cell?.detailTextLabel?.text = dic.description
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let data = _showItems[indexPath.row] as? Dictionary<String,Any> {
            let storyboard = UIStoryboard(name: Main_Stoybord_ID, bundle: nil)
            let detailVC:DetailVC = storyboard.instantiateViewController(withIdentifier: DetailVC_ID) as! DetailVC
            detailVC.dic = data
            navigationController?.pushViewController(detailVC, animated: true)

        }
    }
    
}
