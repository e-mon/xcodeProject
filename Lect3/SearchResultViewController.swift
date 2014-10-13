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
        
        cell.textLabel?.text = rowData["trackName"] as? String
        
        // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
        let urlString: NSString = rowData["artworkUrl60"] as NSString
        let imgURL: NSURL = NSURL(string: urlString)
        
        // Download an NSData representation of the image at the URL
        let imgData: NSData = NSData(contentsOfURL: imgURL)
        cell.imageView?.image = UIImage(data: imgData)
        
        // Get the formatted price string for display in the subtitle
        let formattedPrice: NSString = rowData["formattedPrice"] as NSString
        
        cell.detailTextLabel?.text = formattedPrice
        
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

