//
//  URLSessionViewController.swift
//  SnapKitDemo1
//
//  Created by Dongdong on 16/12/16.
//  Copyright © 2016年 com. All rights reserved.
//

import UIKit
import Alamofire

class URLSessionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        let url: URL? = URL.init(string: "http://tingapi.ting.baidu.com/v1/restserver/ting?from=qianqian&version=2.1.0&method=baidu.ting.radio.getCategoryList&format=json")
//        let session: URLSession = URLSession.init(configuration: URLSessionConfiguration.default)
//        guard let urlString = url else {
//            return
//        }
//        let dataTask: URLSessionDataTask = session.dataTask(with: urlString, completionHandler: { (data, response, error) in
//            if let result = data {
//                let json = try? JSONSerialization.jsonObject(with: result, options: .mutableContainers)
//                let dictionary = json as! [String: Any]
//                print("json value is \(dictionary)")
//            }
//        })
//        dataTask.resume()
        
        Alamofire.request(url!, method: .get, parameters: nil).responseData { (response) in
            if let result = response.data {
                let json = try? JSONSerialization.jsonObject(with: result, options: .mutableContainers)
                let dic = json as! [String: Any]
                print("json value is \(dic)")
            }
        }
    }
}
