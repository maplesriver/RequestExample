//
//  PHTestTests.swift
//  PHTestTests
//
//  Created by maples on 2020/11/11.
//

import XCTest
@testable import PHTest

class PHTestTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTimer() throws {
        let timer = TimerManager.init()
        timer.start(timeInterval: -1) {
            print("启动timer成功")
        }
        timer.stop()
    }
    
    func testRequest() throws {
        let expectation = self.expectation(description: "testGetRequest")

        getRequest(url:"www.baidu.com", callback: { (data) in
            print(data)
            XCTAssert(true, "Pass")
            expectation.fulfill()
        }, err: { (err) in
            print(err?.localizedDescription ?? "error")
            XCTAssert(false, "Failure")
        })
        waitForExpectations(timeout: 15, handler: nil)

    }

    func testDataManagerPerformance() throws {
        
        self.measure {
            let data = DataManager.init(delegate: nil)
            data.fetchData()
            print("测试数据管理器启动性能")
        }
    }
    
    func testTimerPerformance() throws {
        
        self.measure {
            let timer = TimerManager.init()
            timer.start(timeInterval: 5) {
                print("测试timer启动性能")
            }
        }
    }
    
    func testRequestPerformance() throws {
        print("测试请求性能")
        self.measure {
            getRequest(url:"www.baidu.com", callback: { (data) in
                print("获取成功")
            }, err: { (err) in
                print("获取失败")
            })

        }
    }
}
