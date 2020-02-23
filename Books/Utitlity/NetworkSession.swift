//
//  NetworkSession.swift
//  WeatherAssignment
//
//  Created by Nikhil d on 27/01/20.
//  Copyright © 2020 Nikhil Dhavale. All rights reserved.
//

import Foundation
class NetworkSession {
    var completionBlock:((Data) -> ())?
    var errorBlock:((Error)->())?
    var cancelBlock:(()->())?
    var task:URLSessionTask?
    init(completionBlock:((Data) -> ())?,errorBlock:((Error)->())?,cancelBlock:(()->())?) {
        self.completionBlock = completionBlock
        self.errorBlock = errorBlock
        self.cancelBlock = cancelBlock
    }
    func setupGetRequest(urlString:String){
        if let url = URL(string: urlString) {
            task =  URLSession.shared.dataTask(with: url as URL, completionHandler: {(data,request,error) in
                if let error = error {
                    self.errorBlock?(error)
                }
                else if let responseData = data {
                    self.completionBlock?(responseData)
                }
            })
            task?.resume()
        }
    }
    func cancel(){
        task?.cancel()
        self.cancelBlock?()
    }
    
}
