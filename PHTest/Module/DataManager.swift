//
//  DataManager.swift
//  PHTest
//
//  Created by maples on 2020/11/11.
//

import Foundation

protocol DataManagerDelegate: class {
    
    /// 新增请求数据通知
    /// - Parameter newData: 新增数据
    func updateData(with newData: Dictionary<String, Any>)
}

/// 数据处理类，相当于viewModel
class DataManager: NSObject {
    // MARK: - 属性
    public var _historyItems:NSMutableArray = [] /// 历史数据

    private weak var delegate:DataManagerDelegate? /// 代理，用于更新通知
    private let bundlePath = Bundle.main.path(forResource: PlistName, ofType: nil) /// plist文件路径
    private let timerManager = TimerManager()

    
    /// 初始化构造函数
    /// - Parameter delegate: 代理
    init(delegate:DataManagerDelegate?) {
        super.init()
        self.delegate = delegate
    }
    
    /// 开始组装请求数据
    public func fetchData() {
        /// 先读取历史数据
        readData()
       /// 再开启循环
        loopRequest()
    }
    
    /// 开始循环请求数据
    private func loopRequest() {
        timerManager.start(timeInterval: 5.0) {
            getRequest(url:URLString, callback: {[weak self] (dic) in
                /// 通知界面更新
                self?.notifyUpdate(newData: dic)
                /// 保存数据到本地
                self?.saveData(newData: dic)
            }
            ,err: { (err) in
                /// 处理错误
            })
        }
    }
    
    /// 停止循环请求
    private func stopRequest() {
        timerManager.stop()
    }
    
    
    /// 通知view更新数据渲染UI
    /// - Parameter newData: 新增数据
    private func notifyUpdate(newData: Dictionary<String, Any>) {
        /// 由于请求都是在分线程进行，这里切换到主线程以便更新UI
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.updateData(with: newData)
        }
    }
    
    private func addListner() {
        
        /// 监听进入后台之后，暂停循环请求
        NotificationCenter.default.addObserver(forName: .NSExtensionHostDidEnterBackground, object: nil, queue: .main) {[weak self] (noti) in
            self?.stopRequest()
        }
        
        /// 监听返回前台之后，开始循环请求
        NotificationCenter.default.addObserver(forName: .NSExtensionHostWillEnterForeground, object: nil, queue: .main) {[weak self] (noti) in
            self?.loopRequest()
        }
        
    }
    
    deinit {
        timerManager.stop()
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: - Plist数据的读写
extension DataManager {
    
    /// 单个数据加入数组，并写入文件
    /// - Parameter newData: 请求结果数据
    public func saveData(newData:Dictionary<String, Any>) {
        do{
            /// 数据更新
            _historyItems.insert(newData, at: 0)
            
            /// 文件不存在
            let documentdirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let url = documentdirectory.appendingPathComponent(PlistName)
            if !FileManager.default.fileExists(atPath: url.path)
            {
                do{
                    try FileManager.default.copyItem(at: URL.init(fileURLWithPath: bundlePath!), to: url)
                    _historyItems.write(toFile: url.path, atomically: true)
                }catch{
                    print("File not copy")
                }
            }
            else{
                /// 文件存在，直接写入数据
                _historyItems.write(toFile: url.path, atomically: true)
               
            }
        }catch{
            print("Error to get document directory")
        }
    }
    
    
    /// 读取文件历史数组
    func readData() {
        do{
            let documentdirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let url = documentdirectory.appendingPathComponent(PlistName)
            print(url)
            if FileManager.default.fileExists(atPath: url.path)
            {
                _historyItems = NSMutableArray(contentsOfFile:url.path)!
                if let lastData = _historyItems.lastObject as? Dictionary<String,Any> {
                    /// 将历史最后一条数据用于展示
                    self.notifyUpdate(newData: lastData)
                }
                
            }
        }catch{
            print("Error to get document directory")
        }
        
    }
}
