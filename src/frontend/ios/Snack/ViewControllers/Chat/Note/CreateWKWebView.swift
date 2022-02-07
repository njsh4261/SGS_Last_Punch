//
//  CreateWKWebView.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/02/07.
//

import UIKit
import WebKit
import SwiftKeychainWrapper

class CreateWKWebView: UIViewController {
    private weak var webKitView: WKWebView?
    private var url: String?
    private var accessToken: String
    private var refreshToken: String
    private var headers: [String: String] {
        var header = ["Content-Type": "application/json"]
        header["X-AUTH-TOKEN"] = refreshToken
        return header
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, url: String) {
        let accessToken: String = KeychainWrapper.standard[.accessToken]!
        let refreshToken: String = KeychainWrapper.standard[.refreshToken]!
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.url = url
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        // rootView
        let view = UIView()
        self.view = view
        title = "노트"
        
        // WebKitView
        let webConfiguration = WKWebViewConfiguration()
        let webKitView: WKWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        self.webKitView = webKitView
        webKitView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(webKitView)
        
        // WebKitView 제약사항
        NSLayoutConstraint.activate([
            webKitView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            webKitView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            webKitView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            webKitView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUrl()
        webKitView!.navigationDelegate = self
        // 스와이프를 통해서 뒤로가기 앞으로가기를 할수 있게 해주는 설정값 입니다.
        self.webKitView?.allowsBackForwardNavigationGestures = true
    }
    
    // MARK: - Func
    func loadUrl() {
        if let url = URL(string: url!) {
            var urlRequest = URLRequest(url: url)
            headers.forEach {urlRequest.setValue($0.value, forHTTPHeaderField: $0.key)}
            webKitView?.load(urlRequest)
        } else {
            // 에러처리문.. 예를들어서 alert를 띄워주거나..
            print("에러")
        }
    }
}

extension CreateWKWebView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("localStorage.getItem(\"access_token\")") { (result, error) in
            webView.evaluateJavaScript("localStorage.setItem(\"access_token\", \"\(self.accessToken)\")") { (result, error) in
            }
            webView.evaluateJavaScript("localStorage.setItem(\"refresh_token\", \"\(self.refreshToken)\")") { (result, error) in
            }
        }
    }
}
