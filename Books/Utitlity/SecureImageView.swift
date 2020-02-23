//
//  SecureImageView.swift
//  Edition
//
//  Created by Nikhil Dhavale on 17/07/15.
//  Copyright (c) 2015 Nikhil Dhavale. All rights reserved.
//

import UIKit

protocol SecureImageViewDelegate:class{
    //Not used for now
    func secureImageDidLoad(_ indexPath:IndexPath)
}
protocol DownloadingCompletedDelegate:class{
    // The callback informs the delegate that image is downloaded
    func downloadCompleted(_ complete:Bool,index:Int?)
}
protocol ImageSetDelegate:class{
    // This is callback to inform the delegate if set that UIImage has been set. This mainly needed since this imageview has code to download uiimage
    func imageIsSet()
}
struct ImageTag {
    static  let spinnyTag = 5555
    static let buttonTag = 100
    static let progressViewTag = 200
    static let imageDownloaded = "ImageDownloaded"
}
class SecureImageView: UIImageView,IconDownloaderDelegate {
    var filename:String?
    var shouldSaveToDisk = true
    var index:Int?
    var progressView:UIProgressView?

    override var image:UIImage? {
        didSet{
            if image != nil {
                
                self.contentMode = .scaleAspectFit
                self.removeActivityIndicator()
                self.removeButton()
                //  print("image aspect ratio \(image!.size.width/image!.size.height)")
                DispatchQueue.main.async{
                    if oldValue == nil  {
                        self.delegateImageSet?.imageIsSet()
                        self.progressView?.superview?.removeFromSuperview()
                    }
                }
                
            }
        }
    }
    //    override var frame: CGRect
    //        {
    //        didSet{
    //            print("image view frame \(frame)")
    //        }
    //    }
    weak var delegateImageSet:ImageSetDelegate?
    weak var  delegate:DownloadingCompletedDelegate?
    // lazy var progressView:CustomProgressView = CustomProgressView()
    /// This function set image if available else if sends request from server
    func getImageWithImageId(_ idForImage:String? ,shouldSaveToDisk:Bool){
        self.removeButton()
        self.shouldSaveToDisk = shouldSaveToDisk
        if idForImage != nil  {
            self.filename = idForImage
            if let image  = ImageCache.cachedImageWithContentsOfFile(idForImage!, withImage: nil,shouldSaveToDisk: shouldSaveToDisk) {
                DispatchQueue.main.async{
                    self.removeActivityIndicator()
                    self.image=image
                }
                delegate?.downloadCompleted(false,index: index)
                self.removeActivityIndicator()
                self.setNeedsLayout()
            }
            else if   idForImage != nil{
                conditionallyUseIconDownloader()
                // image is nil 
                // Thus try to check if image exist in regular interval
                self.perform( #selector(SecureImageView.setImageWithInterval), with: nil, afterDelay: 5)
            }
            
        }else{
            self.filename = nil
            self.image = nil
            self.removeActivityIndicator()
            self.setNeedsLayout()
        }
    }
    @objc func setImageWithInterval (){
        
        DispatchQueue.main.async{
            if self.filename != nil {
                if let image  = ImageCache.cachedImageWithContentsOfFile(self.filename!, withImage: nil,shouldSaveToDisk: self.shouldSaveToDisk) {
                    
                    self.removeActivityIndicator()
                    self.image=image
                    
                }
                else{
                    self.perform( #selector(SecureImageView.setImageWithInterval), with: nil, afterDelay: 5)
                    
                }
            }
        }
        
        
    }
    func appImageDidLoad(_ url: String, WithError error: NSError?) {
        if error != nil {
            self.removeActivityIndicator()
            progressView?.superview?.removeFromSuperview()
            if error!.domain == NSURLErrorDomain && error!.code == NSURLErrorNotConnectedToInternet{
                // stop downloading
                
            }else if shouldSaveToDisk{
                let iconDownloader = IconDownloader()
                iconDownloader.url = url
                iconDownloader.shouldSaveToDisk = shouldSaveToDisk
                iconDownloader.delegate = self
                iconDownloader.startDownload()
            }
            
            
        }else{
            
            if self.filename != nil {
                if let image:UIImage = ImageCache.cachedImageWithContentsOfFile(filename!, withImage: nil,shouldSaveToDisk: shouldSaveToDisk) {
                    NotificationCenter.default.post(name: Notification.Name(ImageTag.imageDownloaded), object: nil)
                    DispatchQueue.main.async{
                        self.removeActivityIndicator()
                        self.image=image
                        self.setNeedsLayout()
                        
                        
                    }
                    
                    
                    delegate?.downloadCompleted(true,index: index)
                    //  self.backgroundColor = UIColor.white
                    //setNeedsDisplay()
                }
            }
            
            //            else{
            //                NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "callAppImageDidLoad:", userInfo: nil, repeats: false)
            //                callAppImageDidLoad(nil)
            // self.appImageDidLoad(filename!, WithError: nil)
            
            //            }
        }
        
    }
    
    func progress(_ totalBytesWritten:Int64,totalBytesExpectedToWrite:Int64,url:String)
    {
        // let progressAngle =
        if self.filename == url { progressView?.setProgress(Float(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)), animated: false)
        }
        
    }
    func reloadImage(_ sender:UIButton){
        self.removeButton()
        conditionallyUseIconDownloader()
        //  getImageWithImageId(self.filename,shouldSaveToDisk: shouldSaveToDisk)
    }
    /// This optionally creates IconDownloader to start downloading images.
    func conditionallyUseIconDownloader(){
        if let iconDownloader = ImageCache.downloaderCache[filename!]{
            if(iconDownloader.delegate == nil){
                iconDownloader.delegate = self
            }
            else{
                
                NotificationCenter.default.addObserver(self, selector: #selector(SecureImageView.imageDownloaded(notification:)), name:  Notification.Name(ImageTag.imageDownloaded), object: nil)
            }
            iconDownloader.shouldSaveToDisk = shouldSaveToDisk
            if iconDownloader.error != nil && iconDownloader.downloadTask?.state != .running && iconDownloader.downloadTask?.state != .completed {
                iconDownloader.startDownload()
            }
        }else{
            let iconDownloader:IconDownloader = IconDownloader()
            iconDownloader.url=filename
            iconDownloader.shouldSaveToDisk = shouldSaveToDisk
            iconDownloader.delegate=self
            _ =  ImageCache .downloaderCache(filename!, andWith: iconDownloader)
            iconDownloader .startDownload()
            
        }
    }
    @objc func imageDownloaded(notification:Notification){
        DispatchQueue.main.async {
            let  image  = ImageCache.cachedImageWithContentsOfFile(self.filename!, withImage: nil,shouldSaveToDisk: false)
            self.image = image
        }
    }
    
    
    func callAppImageDidLoad(_ userInfo:Timer?){
        self.appImageDidLoad(filename!, WithError: nil)
        //  self.delegate?.downloadCompleted()
    }
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
    func addProgressViewWithConstraint(){
        
    }
    /// This function removes activity indicator hne called
    func removeActivityIndicator(){
        
        for view in subviews{
            if view is UIActivityIndicatorView{
                view.removeFromSuperview()
            }
        }
        
    }
    
    func removeButton(){
        if let button = self.viewWithTag(ImageTag.buttonTag) as? UIButton{
            button.removeFromSuperview()
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
