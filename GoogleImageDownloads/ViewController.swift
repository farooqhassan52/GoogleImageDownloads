//
//  ViewController.swift
//  GoogleImageDownloads
//
//  Created by Rana Farooq Hassan on 12/07/2021.
//

import UIKit
import LinearProgressBar

class ViewController: UIViewController {

    var images = [UIImage()]
    
    @IBOutlet weak var firstImageProgressBar: LinearProgressBar!
    @IBOutlet weak var secondImageProgressBar: LinearProgressBar!
    @IBOutlet weak var thirdImageProgressBar: LinearProgressBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    @IBAction func downloadBtnTapped(_ sender: Any) {
        
        let imagesURL = ["https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg","https://i.pinimg.com/originals/83/64/66/83646654668bf9ae412f45bb2e417ddf.jpg","https://images.unsplash.com/photo-1444703686981-a3abbc4d4fe3?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dW5pdmVyc2V8ZW58MHx8MHx8&ixlib=rb-1.2.1&w=1000&q=80"]
        
        let myQueue = DispatchQueue(label: "Concurrent Queue", attributes: .concurrent)
        myQueue.async {
        for (index,url) in imagesURL.enumerated(){
//            Thread.printCurrent()
            ApiHandler.shardInstance.downloadfile(link: url) { obj in
                print(obj)
                if let image = UIImage(contentsOfFile: obj.path){
                self.images.append(image)
                }
            } onError: { error in
                print("Error in fetch \(url)  ",error.localizedDescription)
            } onProgress: { progress in
              
                switch(index){
                case 0:
                    print("Image 1 download progress >>>>>>>>>>>",progress)
                    self.firstImageProgressBar.progressValue = CGFloat(progress*100)
                    break
                case 1:
                    print("Image 2 download progress ",progress)
                    self.secondImageProgressBar.progressValue = CGFloat(progress*100)
                    break
                case 2:
                    print("Image 3 download progress ======",progress)
                    self.thirdImageProgressBar.progressValue = CGFloat(progress*100)
                    break
                default:
                    print("undefine ")
                }
                
            }
          }
        }
    }
       
    
}


extension Thread {

    var threadName: String {
        if let currentOperationQueue = OperationQueue.current?.name {
            return "OperationQueue: \(currentOperationQueue)"
        } else if let underlyingDispatchQueue = OperationQueue.current?.underlyingQueue?.label {
            return "DispatchQueue: \(underlyingDispatchQueue)"
        } else {
            let name = __dispatch_queue_get_label(nil)
            return String(cString: name, encoding: .utf8) ?? Thread.current.description
        }
    }
}

extension Thread {
    class func printCurrent() {
        print("\r⚡️: \(Thread.current)\r" + "🏭: \(OperationQueue.current?.underlyingQueue?.label ?? "None")\r")
    }
}
