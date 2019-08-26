//
//  WKWebviewControl.swift
//  baedalgeek
//
//  Created by Nine on 02/07/2019.
//  Copyright © 2019 clouldStone. All rights reserved.
//

import WebKit

class WKWebviewControl: NSObject, WKUIDelegate, WKNavigationDelegate, appFunctions {
    var callerViewController: UIViewController!
    var webView: WKWebView!
    var pageLoadedFirst: Bool = true
    var lastRequest:URLRequest?
    var createWebView: WKWebView?
    
    init(_ caller: UIViewController, webviewObj: WKWebView) {
        super.init()
        self.callerViewController = caller;
        self.webView = webviewObj
        self.webView.configuration.websiteDataStore = WKWebsiteDataStore.default()
        self.webView.configuration.processPool = GlobalData.processPool
        self.webView.allowsBackForwardNavigationGestures = true
        self.webView.scrollView.bounces = false
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        
        self.loadWebView(self.webView, pageUrl: GlobalData.startPage)
    }
    
    func loadWebView(_ webviewObj: WKWebView, pageUrl: String) {
        webviewObj.load(URLRequest(url: URL(string: pageUrl)!))
    }
    
    //============================================WKWebViewDelegate============================================/
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        if self.pageLoadedFirst == true {
            // 어플이 완전 죽은상태에서 푸시로 깨어난경우는 메인웹뷰가 뜨는 컨트롤러에서 appDelete 의 launchOptions 를 검사해서 푸시를 타고 왔는지 검사한다.
            self.pageLoadedFirst = false
        }
    }
    
    // 웹뷰 Delegate : 페이지 로딩시 네트워크 상태 체크
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        if let isConnected = GlobalData.reachable?.connection {
            switch isConnected {
            case .cellular, .wifi:
                if self.lastRequest != nil { // networkUnreachable로 이동하면서 저장해둔 경로가 존재하는 경우
                    webView.goBack() // networkUnreachable을 히스토리에서 제거
                    webView.load(self.lastRequest!) // 기존의 페이지로 재접근
                    self.lastRequest = nil
                }
            case .none:
                print("네트워크가 연결되지 않습니다.")
            }
        } else {
            print("네트워크가 연결되지 않습니다.")
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        alert(title: "", message: message, okLabel:  "확인", okPressed: completionHandler)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) {
            action in completionHandler(false)
        }
        let okAction = UIAlertAction(title: "확인", style: .default) {
            action in completionHandler(true)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        getVisibleViewController().present(alertController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let requestUrl = navigationAction.request.url?.absoluteString
        let hostAddr = navigationAction.request.url?.host
        
        if hostAddr == "itunes.apple.com" {
            if UIApplication.shared.canOpenURL(navigationAction.request.url!) {
                UIApplication.shared.open(navigationAction.request.url!, options: [:], completionHandler: nil)
                decisionHandler(.cancel)
                return
            }
        }
        
        let url_elements = requestUrl!.components(separatedBy: ":")
        
        switch url_elements[0] {
        case "tel":
            openCustomApp(urlScheme: "telprompt://", additional_info: url_elements[1])
            decisionHandler(.cancel)
        case "sms":
            openCustomApp(urlScheme: "sms://", additional_info: url_elements[1])
            decisionHandler(.cancel)
        case "mailto":
            openCustomApp(urlScheme: "mailto://", additional_info: url_elements[1])
            decisionHandler(.cancel)
        default:
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        let frame = UIScreen.main.bounds
        
        //파라미터로 받은 configuration
        createWebView = WKWebView(frame: frame, configuration: configuration)
        
        //오토레이아웃 처리
        createWebView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        createWebView?.navigationDelegate = self
        createWebView?.uiDelegate = self
        
        
        self.callerViewController.view.addSubview(createWebView!)
        
        return createWebView!
        
        /* 현재 창에서 열고 싶은 경우
         self.webView.load(navigationAction.request)
         return nil
         */
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        if webView == createWebView {
            createWebView?.removeFromSuperview()
            createWebView = nil
        }
    }
}
