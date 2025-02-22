//
//  NetworkTools.swift
//  Carloudy-Weather
//
//  Created by Zijia Zhai on 12/13/18.
//  Copyright © 2018 cognitiveAI. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType {
    case get
    case post
}

class NetworkTools {
    class func requestData(_ type : MethodType, URLString : String, parameters : [String : Any]? = nil, finishedCallback :  @escaping (_ result : Any?) -> Void) {
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        AF.request(URLString, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            guard let result = response.result.value else {
                print(response.result.value ?? "")
                finishedCallback(response)
                return
            }
            finishedCallback(result)
        }

    }
}

class ApiService {
    static func getPostString(params:[String:Any]) -> String {
        var data = [String]()
        for(key, value) in params {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }

    static func callPost(url:URL, params:[String:Any], finish: @escaping ((message:String, data:Data?)) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let postString = self.getPostString(params: params)
        request.httpBody = postString.data(using: .utf8)

        var result:(message:String, data:Data?) = (message: "Fail", data: nil)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in

            if(error != nil) {
                result.message = "Fail Error not null : \(error.debugDescription)"
            } else {
                result.message = "Success"
                result.data = data
            }
            finish(result)
        }
        task.resume()
    }

    static func uploadToS3(image: UIImage, urlString: String, completion: @escaping (URLResponse?, Error?) -> Void) {
        let imageData = image.jpegData(compressionQuality: 0.9)
        let decodedURLString = urlString.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "\n", with: "").removingPercentEncoding!
        guard let encoded = decodedURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let myURL = URL(string: encoded) else {
            return
        }
        var request = URLRequest(url: myURL)
        request.httpMethod = "PUT"
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.setValue("base64", forHTTPHeaderField: "Content-Encoding")
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        request.httpBody = imageData
        let task = URLSession.shared.dataTask(with: request) { (_, responce, error) in
            completion(responce, error)
        }
        task.resume()
    }
}
