//
//  IconDownloader.swift
//  Edition
//
//  Created by Nikhil Dhavale on 17/07/15.
//  Copyright (c) 2015 Nikhil Dhavale. All rights reserved.
//

import Foundation
import UIKit
@objc protocol IconDownloaderDelegate:NSObjectProtocol{
    func appImageDidLoad(_ url:String, WithError error:NSError?)
    @objc optional func appImageDidLoad(_ url:String, WithError error:NSError?,index:Int,editionId:String)
    @objc optional func progress(_ totalBytesWritten:Int64,totalBytesExpectedToWrite:Int64,url:String)
  }
class IconDownloader:NSObject,URLSessionDownloadDelegate{
    var url:String?
    var indexPath:IndexPath?
    var imageConnection:Foundation.URLSession?
    weak var delegate:IconDownloaderDelegate?
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
    {

        actionOnSuccess(location)
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){
      //  if delegate?.respondsToSelector(selector){
        DispatchQueue.main.async{

        self.delegate?.progress?(totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite,url:self.url!)
        }
        //}
        
        if shouldSaveToDisk{
          //  println("url :\(url) + bytesTobeWritten : \(totalBytesWritten) bytesExpected: \(totalBytesExpectedToWrite)")
        }
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
         //   if url!.rangeOfString("magnified") != nil {
         //   }
            if (error as! NSError).code != NSURLErrorCancelled{
                print("\n error in downloading \(url) \(error)")
                actionOnError(error! as NSError)
            }
        }
    }

  //  var dataTask:NSURLSessionDataTask?
    var downloadTask:URLSessionDownloadTask?
    var shouldSaveToDisk = true
    var error:NSError?
    var editionId:String=""
    /// This function actually starts downloading
    func startDownload(){
        if URL(string: url!) == nil {
            return;
        }
        let request = URLRequest(url:  URL(string: url!)!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 0)
        imageConnection=Foundation.URLSession.shared
        let nsurlconfig = URLSessionConfiguration.ephemeral
        imageConnection = Foundation.URLSession(configuration: nsurlconfig,delegate:self,delegateQueue: nil)
        downloadTask = imageConnection!.downloadTask(with: request)
        downloadTask?.resume()
        
    }
    
    ///
    /// This function handles error
    /// - parameter error:
    func actionOnError(_ error:NSError){
        self.error = error
        DispatchQueue.main.async(execute: {
            let selector = #selector(IconDownloaderDelegate.appImageDidLoad(_:WithError:index:editionId:))
           // delegate?.appImageDidLoad(self.url!, WithError: error)
           
            if self.delegate!.responds(to: selector) && self.indexPath != nil
            {
                self.delegate!.appImageDidLoad!(self.url!, WithError: error, index: (self.indexPath! as NSIndexPath).row,editionId: self.editionId)
            }
            else
            {
                self.delegate?.appImageDidLoad(self.url!, WithError: error)
            }
        
        
        })
        imageConnection?.invalidateAndCancel()

        ImageCache.removeFromDownloaderCache(self.url!)

    }
    ///This function handles cases of success
    func actionOnSuccess(_ url:URL){
        
        ImageCache.cachedImageWithLocationOfFile(self.url!, withImage: url, shouldSaveToDisk: self.shouldSaveToDisk, editionId: self.editionId)
        if self.delegate != nil{
            let selector = #selector(IconDownloaderDelegate.appImageDidLoad(_:WithError:index:editionId:))
            //   println(selector)
            if self.delegate!.responds(to: selector) && self.indexPath != nil
            {
                self.delegate!.appImageDidLoad!(self.url!, WithError: nil, index: (self.indexPath! as NSIndexPath).row,editionId: self.editionId)
            }
            else
            {
                if self.url != nil {
                self.delegate?.appImageDidLoad(self.url!, WithError: nil)
                }
            }
        }
        if self.url != nil {
        ImageCache.removeFromDownloaderCache(self.url!)
        }
        imageConnection?.invalidateAndCancel()
    }
    func cancelDownload(){
        imageConnection=nil
        if downloadTask != nil {
            switch(downloadTask!.state){
            case .canceling:
                print("cancelling")
            case .completed:
                print("completed")
            case .running:
                print("running")
            case .suspended:
                print("suspended")
                
            }
        }
        downloadTask?.cancel()
        imageConnection?.invalidateAndCancel()
        print("downloads cancelled \(url)")
        if self.url != nil {
            ImageCache.removeFromDownloaderCache(self.url!)
        }
        //dataTask?.cancel()
       // downloadTask?.cancel()

    }
    deinit{
       // print("releasing downloader of url \(url)")
    }
}
