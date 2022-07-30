//
//  WebViewController.swift
//  SeSACNetworkBasic
//
//  Created by 이현호 on 2022/07/28.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    
    var destinationURL: String = "https://www.apple.com"
    //App Transport Security Settings
    //http는 보안상 사이트 차단됨
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openWebPage(url: destinationURL)
        searchBar.delegate = self
        
        backButton.setBackgroundImage(UIImage(systemName: "chevron.backward"), for: .normal, barMetrics: .default)
        backButton.title = ""
        
        forwardButton.setBackgroundImage(UIImage(systemName: "chevron.forward"), for: .normal, barMetrics: .default)
        forwardButton.title = ""
        
    }
    
    @IBAction func goBackButtonClicked(_ sender: Any) {
        
        if webView.canGoBack {
            webView.goBack()
        }
        
    }
    
    @IBAction func reloadButtonClicked(_ sender: Any) {
        
        webView.reload()
        
    }
    
    @IBAction func goForwardButtonClicked(_ sender: Any) {
        
        if webView.canGoForward {
            webView.goForward()
        }
        
    }
    
    
    //로딩바는 skeletonView로 간단하게 라이브러리 가져와서 구현 가능
    func openWebPage(url: String) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
}

extension WebViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        openWebPage(url: searchBar.text!)
    }
    
}
