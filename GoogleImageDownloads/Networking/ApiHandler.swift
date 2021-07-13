//
//  ApiHandler.swift
//  GoogleImageDownloads
//
//  Created by Rana Farooq Hassan on 12/07/2021.
//

import Foundation
import Alamofire

class ApiHandler {
    
    static let shardInstance = ApiHandler()
    private init(){}
    
    
    func downloadfile(link:String,completion: @escaping (_ fileUrl:URL)->(), onError: @escaping(_ error:AFError)->(), onProgress: @escaping(_ progress:Double)->()){
        let fileUrl = self.getSaveFileUrl(fileName: link)
        let destination: DownloadRequest.Destination = { _, _ in
            return (fileUrl, [.removePreviousFile, .createIntermediateDirectories])
        }
        AF.download(link, to:destination)
            .downloadProgress { (progress) in
                onProgress(progress.fractionCompleted)
            }
            .response { (response) in
                if response.error == nil, let imagePath = response.fileURL {
                    completion(imagePath)
                }else{
                    onError(response.error!)
                }
               
            }

    }
    
   

    func getSaveFileUrl(fileName: String) -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let nameUrl = URL(string: fileName)
        let fileURL = documentsURL.appendingPathComponent((nameUrl?.lastPathComponent)!)
        NSLog(fileURL.absoluteString)
        return fileURL;
    }
    
}
