//
//  ImageCache.swift
//  Edition
//
//  Created by Nikhil Dhavale on 17/07/15.
//  Copyright (c) 2015 Nikhil Dhavale. All rights reserved.
//

import Foundation
import UIKit
 

class ImageCache {
    static  var uiImageCache:[String:String] = [String:String]()
    static  var downloaderCache:[String:IconDownloader] = [String:IconDownloader]()
    static var documentDirectory =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    static var cacheDirectory =  NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
    /// This function retirves the image from LocalPath or writes image to local path
    static func cachedImageWithContentsOfFile(_ path:String, withImage image:UIImage?,shouldSaveToDisk:Bool ) ->UIImage?{
        if let result = uiImageCache[path]{
            let fileManager = FileManager.default

            if shouldSaveToDisk  && result.range(of: "Document") == nil
            {
                let paths  = documentDirectory
               // paths = paths.stringByAppendingPathComponent(editionId)
                var directory = ObjCBool(true)
                let splitImagePath = path.components(separatedBy: "?")
                let firstString = splitImagePath[0]

                if !fileManager.fileExists(atPath: paths, isDirectory: &directory){
                    do{
                    try fileManager.createDirectory(atPath: paths, withIntermediateDirectories: false, attributes: nil)
                    }
                    catch{
                        
                    }
                    //fileManager.createDirectoryAtPath(paths, withIntermediateDirectories: false, attributes: nil, error: nil)
                }
                let filePathToWrite = "\(paths)/\((firstString as NSString).lastPathComponent)"
                do{
                 try fileManager.copyItem(atPath: result, toPath: filePathToWrite)
                }
                catch{
                    
                }
               // fileManager.copyItemAtPath(result, toPath: filePathToWrite, error: nil)
                uiImageCache.updateValue(filePathToWrite, forKey: path)
            }
            if fileManager.fileExists(atPath: result) {
            return UIImage(contentsOfFile: result)
            }else{
                return nil 
            }
            
        }
        
        return writeToFileSystem(path, image: image,shouldSaveToDisk: shouldSaveToDisk)

        

     


        
        
    }
    static func checkIfFileExist(_ path:String) -> Bool {
        var paths  = cacheDirectory
        let splitImagePath = path.components(separatedBy: "?")
        let firstString = splitImagePath[0]
        let filePath = "\(paths)/\((firstString as NSString).lastPathComponent)"
      return  FileManager.default.fileExists(atPath: filePath)
        
    }
    static func deleteFileAtPath(_ path:String, editionId:String)  {
        var paths  = cacheDirectory
        let splitImagePath = path.components(separatedBy: "?")
        let firstString = splitImagePath[0]
        let filePath = "\(paths)/\((firstString as NSString).lastPathComponent)"
        do{
         try   FileManager.default.removeItem(atPath: filePath)
        }
        catch{
            
        }
    }
    /// This function adds local path of image to ImageCache dictionary
    static func cachedImageWithLocationOfFile(_ path:String, withImage image:URL?,shouldSaveToDisk:Bool , editionId:String){
        if let result = uiImageCache[path]{
            if shouldSaveToDisk  && result.range(of: "Document") == nil
            {
                let fileManager = FileManager.default
                var paths  = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                var directory = ObjCBool(true)
                let splitImagePath = path.components(separatedBy: "?")
                let firstString = splitImagePath[0]
                
                if !fileManager.fileExists(atPath: paths, isDirectory: &directory){
                    do{
                        try fileManager.createDirectory(atPath: paths, withIntermediateDirectories: false, attributes: nil)
                    }
                    catch{
                        
                    }
                    //fileManager.createDirectoryAtPath(paths, withIntermediateDirectories: false, attributes: nil, error: nil)
                }
                let filePathToWrite = "\(paths)/\((firstString as NSString).lastPathComponent)"
                do {
                    try fileManager.moveItem(atPath: result, toPath: filePathToWrite)
                    try (URL(fileURLWithPath: filePathToWrite) as NSURL).setResourceValue(NSNumber(value: true as Bool), forKey: URLResourceKey.isExcludedFromBackupKey)
                }
                catch{
                    
                }
           //     NSURL(fileURLWithPath: filePathToWrite).setResourceValue(NSNumber(bool: true), forKey: NSURLIsExcludedFromBackupKey, error: nil)
                uiImageCache.updateValue(filePathToWrite, forKey: path)
                return
            }
           // return UIImage(contentsOfFile: result)
            
        }
        
         writeToFileSystemWithURL(path, url: image,shouldSaveToDisk: shouldSaveToDisk)
        
        
        
        
        
        
        
        
    }
    /// This function does mapping from global path to local path
    static func writeToFileSystemWithURL(_ path:String,url:URL?,shouldSaveToDisk:Bool) {
        let splitImagePath = path.components(separatedBy: "?")
        let firstString = splitImagePath[0]
        //        var secondString:String = ""
        //
        //        if splitImagePath.count > 1{
        //            secondString = splitImagePath[1]
        //        }else{
        //            secondString =    path.componentsSeparatedByString("/").last ?? ""
        //        }
        let fileManager = FileManager.default
        var paths = ""
        if shouldSaveToDisk{
            paths  = documentDirectory
        }else{
            paths  = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        }
        var directory = ObjCBool(true)
        
        if !fileManager.fileExists(atPath: paths, isDirectory: &directory){
            do {
                try fileManager.createDirectory(atPath: paths, withIntermediateDirectories: false, attributes: nil)
            }
            catch {
                
            }
           // fileManager.createDirectoryAtPath(paths, withIntermediateDirectories: false, attributes: nil, error: nil)
        }
        let filePathToWrite = "\(paths)/\((firstString as NSString).lastPathComponent)"
        
        let getImagePath = paths.stringByAppendingPathComponent("\((firstString as NSString).lastPathComponent)")
        //
        //Check the file is already present or not.
        if (fileManager.fileExists(atPath: getImagePath))
        {
            //   println("FILE AVAILABLE");
            uiImageCache.updateValue(getImagePath, forKey: path)
            //return UIImage(contentsOfFile: getImagePath)
        }
        else if url != nil
        {
//            var imageData: NSData = UIImagePNGRepresentation(image)
//            fileManager.createFileAtPath(filePathToWrite, contents: imageData, attributes: nil)
            do {
                try fileManager.moveItem(at: url!, to: URL(fileURLWithPath: filePathToWrite))
                try (URL(fileURLWithPath: filePathToWrite) as NSURL).setResourceValue(NSNumber(value: true as Bool), forKey: URLResourceKey.isExcludedFromBackupKey)

            }
            catch{
                
            }
          //  NSURL(fileURLWithPath: filePathToWrite).setResourceValue(NSNumber(bool: true), forKey: NSURLIsExcludedFromBackupKey, error: nil)
            uiImageCache.updateValue(getImagePath, forKey: path)
            //let image = UIImage(contentsOfFile: filePathToWrite)
            //print(image)
          //  println(filePathToWrite)
           // return image
            //  println("writing to imagepath :\(filePathToWrite)")
            // println("FILE NOT AVAILABLE");
        }
        //return nil
        
    }
// This function actually writes UIImage to file system it could be document's directory and Cache directory
    static func writeToFileSystem(_ path:String,image:UIImage?,shouldSaveToDisk:Bool) -> UIImage?{
        let splitImagePath = path.components(separatedBy: "?")
        let firstString = splitImagePath[0]
//        var secondString:String = ""
//        
//        if splitImagePath.count > 1{
//            secondString = splitImagePath[1]
//        }else{
//            secondString =    path.componentsSeparatedByString("/").last ?? ""
//        }
        let fileManager = FileManager.default
        var paths = ""
        if shouldSaveToDisk{
           paths  = documentDirectory
        }else{
          paths  = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        }
        var directory = ObjCBool(true)

        if !fileManager.fileExists(atPath: paths, isDirectory: &directory){
            do{
                try fileManager.createDirectory(atPath: paths, withIntermediateDirectories: false, attributes: nil)
            }
            catch{
                
            }
            //fileManager.createDirectoryAtPath(paths, withIntermediateDirectories: false, attributes: nil, error: nil)
        }
        let filePathToWrite = "\(paths)/\((firstString as NSString).lastPathComponent)"
        
        let getImagePath = paths.stringByAppendingPathComponent("\((firstString as NSString).lastPathComponent)")
        //
        //Check the file is already present or not.
        if (fileManager.fileExists(atPath: getImagePath))
        {
            //   println("FILE AVAILABLE");
            uiImageCache.updateValue(getImagePath, forKey: path)
            return UIImage(contentsOfFile: getImagePath)
        }
        else if image != nil
        {
            autoreleasepool(){
                var imageData = image!.pngData()
            do{
                fileManager.createFile(atPath: filePathToWrite, contents: imageData, attributes: nil)
                try (URL(fileURLWithPath: filePathToWrite) as NSURL).setResourceValue(NSNumber(value: true as Bool), forKey: URLResourceKey.isExcludedFromBackupKey)
            }
            catch{
                
            }
            //NSURL(fileURLWithPath: filePathToWrite)?.setResourceValue(NSNumber(bool: true), forKey: NSURLIsExcludedFromBackupKey, error: nil)
            uiImageCache.updateValue(getImagePath, forKey: path)
            imageData = nil
            }
            return image
          //  println("writing to imagepath :\(filePathToWrite)")
            // println("FILE NOT AVAILABLE");
        }
        
        return nil

    }
/// It clears the dictionary
    static func clearCache(){
         uiImageCache.removeAll(keepingCapacity: false)
        downloaderCache.removeAll(keepingCapacity: false)
    }
    /// It removes icondownloads of a path.
    static func removeFromDownloaderCache (_ path : String){
        if downloaderCache.keys.contains(path){
            if  let iconDowloader = downloaderCache.removeValue(forKey: path) {
                iconDowloader.imageConnection?.invalidateAndCancel()
            }
        
        }
        
        
    }
    /// Get the icon downloader if exists or adds the downloader to downloader cache if absent.
    static func downloaderCache(_ path:String, andWith imageDownloader:IconDownloader?) ->IconDownloader?{

        if let image = downloaderCache[path]{
            return image
        }
        else  {
            downloaderCache.updateValue(imageDownloader!, forKey: path)
        }
        return nil
        

    }
}
