//
//  Timer.swift
//  PHTest
//
//  Created by maples on 2020/11/11.
//

import Foundation

/// 定时循环任务管理器
class TimerManager {
    /// 循环定时器
    var timer: DispatchSourceTimer?
    
    
    /// 启动GCD循环定时器
    /// - Parameters:
    ///   - timeInterval: 定时间隔
    ///   - handler: 定时任务
    /// - Returns:
    func start(timeInterval: Double, handler:@escaping ()->()) {
        if timeInterval < 0 {
            handler()
            return
        }
        /// 创建与设置
        self.timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        self.timer?.schedule(deadline: .now() + timeInterval,repeating: timeInterval)
        self.timer?.setEventHandler(handler: {
                handler()
        })
        
        /// 启动
        self.timer?.resume()
    }
    
    /// 停止定时器
    func stop() {
        self.timer?.cancel()
        self.timer = nil
    }
    
    deinit {
        self.timer?.cancel()
    }
}


