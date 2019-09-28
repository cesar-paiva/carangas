//
//  CarViewController.swift
//  Carangas
//
//  Created by Cesar Paiva.
//  Copyright © 2019 Cesar Paiva. All rights reserved.
//

import UIKit
import WebKit

class CarViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var lbBrand: UILabel!
    @IBOutlet weak var lbGasType: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var car: Car!
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = car.name
        lbBrand.text = car.brand
        lbGasType.text = car.gas
        lbPrice.text = "R$ \(car.price)"
        
        if let title = title {
            let name = (title + "+" + car.brand).replacingOccurrences(of: " ", with: "+")
            let urlString = "https://www.google.com.br/search?q=\(name)&tbm=isch"
            if let url = URL(string: urlString) {
                let request = URLRequest(url: url)
                webview.allowsBackForwardNavigationGestures = true
                webview.allowsLinkPreview = true
                webview.navigationDelegate = self
                webview.uiDelegate = self
                webview.load(request)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! AddEditViewController
        viewController.car = car
    }

}

extension CarViewController: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loading.stopAnimating()
    }
}
