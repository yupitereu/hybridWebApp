//
//  GlobalData.swift
//  baedalgeek
//
//  Created by Nine on 02/07/2019.
//  Copyright © 2019 clouldStone. All rights reserved.
//
import UIKit
import WebKit
import Reachability

struct GlobalData {
    // 초기 홈페이지.
    static var startPage                    = "https://m.baedalgeek.com/"
    // 디바이스정보
    static var deviceInfo = DeviceInfo()
    
    static var processPool = WKProcessPool()
    
    static var reachable = Reachability()
    
    static var rootNavigationController: UINavigationController?
}
struct Coord {
    var latitude = 0.0             // 위도
    var longitude = 0.0             // 경도
    var lastUpdateStatus:Bool = false    // 마지막 업데이트 결과.
    var locationServiceEnabled:Bool = true
}


struct DeviceInfo {
    var UUID = ""
    var SYSTEM_VERSION = ""
    var TOKEN_ID = ""
    var APP_VERSION = ""
}
