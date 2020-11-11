//
//  HistoryTableVC.swift
//  PHTest
//
//  Created by maples on 2020/11/11.
//

import UIKit

class HistoryTableVC: UITableViewController {

    private var tableData:NSArray?
    
    /// 数据源设置
    public var items:NSArray? {
        didSet{
            self.tableData = items
            tableView.reloadData()
        }
    }
    
    // MARK: -private
    private func setUI() {
        navigationItem.title = NAV_TITLE_HISTORY
        
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        /// 初始化UI
        setUI()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 复用 cell
        var cell = tableView.dequeueReusableCell(withIdentifier: HistoryCellReuseId)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: HistoryCellReuseId)
        }

        /// cell内容设置
        if let data = tableData?[indexPath.row] as? Dictionary<String,Any> {
            cell?.textLabel?.text = data[kNAME_DATE] as? String
            if let dic = data[kNAME_JSON] as? Dictionary<String,String> {
                cell?.detailTextLabel?.numberOfLines = 3
                cell?.detailTextLabel?.text = dic.description
            }
        }
        
        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let data = tableData?[indexPath.row] as? Dictionary<String,Any> {
            let storyboard = UIStoryboard(name: Main_Stoybord_ID, bundle: nil)
            let detailVC:DetailVC = storyboard.instantiateViewController(withIdentifier: DetailVC_ID) as! DetailVC
            detailVC.dic = data
            navigationController?.pushViewController(detailVC, animated: true)

        }
    }
}
