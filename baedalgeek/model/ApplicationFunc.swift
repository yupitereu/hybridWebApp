//
//  ApplicationFunc.swift
//  baedalgeek
//
//  Created by Nine on 02/07/2019.
//  Copyright © 2019 clouldStone. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol appFunctions {
    func openCustomApp(urlScheme:String, additional_info:String)
}

extension appFunctions {
    func getNavigationController() -> UINavigationController {
        return GlobalData.rootNavigationController ?? UIApplication.shared.windows[0].rootViewController as! UINavigationController
    }
    
    // return visible view controller
    func getVisibleViewController() -> UIViewController {
        return getNavigationController().visibleViewController!
    }
    
    // return top view controller
    func getTopViewController() -> UIViewController {
        return getNavigationController().topViewController!
    }
    
    func openCustomApp(urlScheme:String, additional_info:String) {
        if let requestUrl:URL = URL(string:"\(urlScheme)"+"\(additional_info)") {
            let application:UIApplication = UIApplication.shared
            if application.canOpenURL(requestUrl) {
                application.open(requestUrl, options: [:], completionHandler: nil)
            }
        }
    }
    
    // confirm 창.
    func confirm(title: String, message: String, cancelLabel: String, okLabel: String, cancelPressed: (()->Void)?, okPressed: (()->Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelLabel, style: .default, handler: {(action) in
            if let cancelCallback = cancelPressed {
                cancelCallback()
            }
        })
        let okAction = UIAlertAction(title: okLabel, style: .default, handler: {(action) in
            if let okCallback = okPressed {
                okCallback()
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        getVisibleViewController().present(alertController, animated: false, completion: nil)
    }
    
    // alert 창.
    func alert(title: String, message: String, okLabel: String, okPressed: (()->Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okLabel, style: .default, handler: {(action) in
            if let okCallback = okPressed {
                okCallback()
            }
        })
        alertController.addAction(okAction)
        getVisibleViewController().present(alertController, animated: false, completion: nil)
    }
}
