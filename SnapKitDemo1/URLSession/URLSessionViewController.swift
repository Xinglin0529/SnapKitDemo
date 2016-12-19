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

    /*
     headers {
     "Content-Type" = "application/json";
     Date = "Mon, 19 Dec 2016 08:56:00 GMT";
     "Keep-Alive" = "timeout: 38";
     Rt = "814401326_d41d8cd98f00b204e9800998ecf8427e_d41d8cd98f00b204e9800998ecf8427e";
     Sc = "HIT.0.0";
     Server = "Apache1.0";
     Tracecode = 33604948152785192128121916;
     "Transfer-Encoding" = Identity;
     "X-Lighttpd-Logid" = 814401326;
     }
    */
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
        //responseData(url: url!)
        responseJson(url: url!)
    }
    
    private func responseString(url: URL) {
        Alamofire.request(url, method: .get).responseString { (response) in
            print("Success: \(response.result.isSuccess)")
            print("Response String: \(response.result.value)")
        }
    }
    
    private func responseData(url: URL) {
        Alamofire.request(url, method: .get, parameters: nil).responseData { (response) in
            print(response.request ?? "")
            print(response.response ?? "")
            print(response.result.value ?? "")
        }
    }
    
    private func responseJson(url: URL) {
        Alamofire.request(url, method: .get).responseJSON { (response) in
            print(response)
        }
    }
    
    private func uploadData() {
        Alamofire.upload(Data(), to: URL.init(string: "")!, method: .post, headers: nil).uploadProgress { (progress) in
            print(progress)
        }
    }
    
    enum LDError: Error {
        case parseError
    }
}
