//
//  File.swift
//  PHTest
//
//  Created by maples on 2020/11/11.
//

import Foundation

/// 网络请求方法
public func getRequest(url:String, callback:@escaping (Dictionary<String, Any>)->(),err:@escaping (Error?)->()) {
    guard let url = URL(string: url) else { return }

    /// 创建并启动URLSession请求
    let session = URLSession.shared
    session.dataTask(with: url) { (data, response, error) in
        if let response = response {
            /// 打印完整返回信息头
            print(response)
        }
        
        /// 数据解析
        if let data = data {
            print(data)
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let date = Date()
                let timeFormatter = DateFormatter()
                //日期显示格式
                timeFormatter.dateFormat = FormatString
                let strNowTime = timeFormatter.string(from: date) as String
                print("request time:\(strNowTime) \nReponse Data：\(json)")
                let dic = [kNAME_DATE:strNowTime,kNAME_JSON:json]
                callback(dic)
            } catch {
                print(error)
                err(error)
            }
            
        }
    }.resume()
}
