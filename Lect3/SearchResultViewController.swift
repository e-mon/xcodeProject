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
    var api:APIController?
    var imageCache = [String : UIImage]()
    var albums = [Album]()
    
    @IBOutlet weak var appsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        api = APIController(delegate: self)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api!.searchItunesFor("Beatles")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var detailsViewController: DetailsViewController = segue.destinationViewController as DetailsViewController
        var albumIndex = appsTableView!.indexPathForSelectedRow()!.row
        var selectedAlbum = self.albums[albumIndex]
        detailsViewController.album = selectedAlbum
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        
        let album = self.albums[indexPath.row]
        cell.textLabel?.text = album.title
        cell.imageView?.image = UIImage(named: "Blank52")
        
        // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
        let urlString: NSString = album.thumbnailImageURL
        
        // Get the formatted price string for display in the subtitle
        let formattedPrice: NSString = album.price
        
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
        else{
            dispatch_async(dispatch_get_main_queue(), {
                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath){
                    cellToUpdate.imageView?.image = image
                }
            })
        }
        return cell
    }
    
    
    func didReceiveAPIResults(results: NSDictionary){
        var resultsArr: NSArray = results["results"] as NSArray
        dispatch_async(dispatch_get_main_queue(),{
            self.albums = Album.albumsWithJSON(resultsArr)
            self.appsTableView!.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
}

