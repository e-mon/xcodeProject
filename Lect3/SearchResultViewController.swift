//
//  SearchResultViewController
//  Lect3
//
//  Created by emon on 2014/10/14.
//  Copyright (c) 2014年 emon. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,APIControllerProtocol {
    let kCellIdentifier: String = "SearchResultCell"
    var tableData = []
    var api = APIController()
    var imageCache = [String : UIImage]()
    
    @IBOutlet weak var appsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        api.searchItunesFor("Angry Birds")
        self.api.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView,didSelectRowAtIndexPath indexPath:NSIndexPath){
        var rowData:NSDictionary = self.tableData[indexPath.row] as NSDictionary
        
        var name:String = rowData["trackName"] as String
        var formattedPrice:String = rowData["formattedPrice"] as String
        
        var alert:UIAlertView = UIAlertView()
        alert.title = name
        alert.message = formattedPrice
        alert.addButtonWithTitle("OK")
        alert.show()
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        
        let rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        
        let cellText:String? = rowData["trackName"] as? String
        cell.textLabel?.text = cellText
        cell.imageView?.image = UIImage(named: "Blank52")
        
        // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
        let urlString: NSString = rowData["artworkUrl60"] as NSString
        
        // Get the formatted price string for display in the subtitle
        let formattedPrice: NSString = rowData["formattedPrice"] as NSString
        
        cell.detailTextLabel?.text = formattedPrice
        
        var image = self.imageCache[urlString]
        
        if(image == nil){
            var imgURL: NSURL = NSURL(string: urlString)
            
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil{
                    image = UIImage(data: data)
                
                    self.imageCache[urlString] = image
                    dispatch_async(dispatch_get_main_queue(), {
                        if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath){
                            cellToUpdate.imageView?.image = image
                        }
                    })
                }
                else{
                    println("Error: \(error.localizedDescription)")
                }
            })
        }
        //else{
            dispatch_async(dispatch_get_main_queue(), {
                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath){
                    cellToUpdate.imageView?.image = image
                }
            })
     //   }
        return cell
    }
    
    
    func didReceiveAPIResults(results: NSDictionary){
        var resultsArr: NSArray = results["results"] as NSArray
        dispatch_async(dispatch_get_main_queue(),{
            self.tableData = resultsArr
            self.appsTableView!.reloadData()
        })
    }
}

