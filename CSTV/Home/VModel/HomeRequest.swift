//
//  HomeRequest.swift
//  CSTV
//
//  Created by 李林凯 on 16/9/2.
//  Copyright © 2016年 7k7k. All rights reserved.
//

import UIKit

class HomeRequest: NSObject {
    
    static func getRequest() {
        let parameters:Dictionary = ["key":"93c921ea8b0348af8e8e7a6a273c41bd"]
        Alamofire.request(.GET, "http://apis.haoservice.com/weather/city", parameters: parameters) .responseJSON { response in
            
            switch response.result{
                case .Success:
                    ()
                
                case .Failure(let error):
                    print("error =====\(error)")
                
            }
            
                print("result==\(response.result)")   // 返回结果，是否成功
                if let jsonValue = response.result.value {
                    /*
                     error_code = 0
                     reason = ""
                     result = 数组套字典的城市列表
                     */
                    print("code: \(jsonValue["error_code"])")
                }
        }
    }

}
