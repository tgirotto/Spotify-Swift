//
//  ViewController.swift
//  Spotify 6
//
//  Created by Tommaso on 28/2/15.
//  Copyright (c) 2015 Tommaso. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SPTAudioStreamingPlaybackDelegate {
    
    let kClientID = "40ac927645d64a6da53521bb6287db19"
    let kCallbackURL = "spotifytutorial://returnAfterLogin"
    let kTokenSwapURL = "https://hidden-hollows-1983.herokuapp.com/swap"
    let kTokenRefreshServiceURL = "https://hidden-hollows-1983.herokuapp.com/refresh"

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var session:SPTSession!
    var page_pointer: SPTPlaylistList!
    var player:SPTAudioStreamingController!
    
    var items: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        inputField.hidden = true
        searchButton.hidden = true
        tableView.hidden = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateAfterFirstLogin", name: "loginSuccessful", object: nil)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        if let sessionObj: AnyObject = userDefaults.objectForKey("SpotifySession") {
            let sessionDataObj = sessionObj as NSData
            let session = NSKeyedUnarchiver.unarchiveObjectWithData(sessionDataObj) as SPTSession
            
            if !session.isValid() {
                SPTAuth.defaultInstance().renewSession(session, withServiceEndpointAtURL: NSURL(string: kTokenRefreshServiceURL), callback: { (error: NSError!, renewedSession: SPTSession!) -> Void in
                    if error == nil {
                        let sessionData = NSKeyedArchiver.archivedDataWithRootObject(session)
                        userDefaults.setObject(sessionData, forKey: "SpotifySession")
                        userDefaults.synchronize()
                        
                        self.session = renewedSession
                        self.getPlayslists(renewedSession)
                    } else {
                        println("Error while refreshing session")
                    }
                })
            } else {
                loginButton.hidden = true
                inputField.hidden = false
                searchButton.hidden = false
                tableView.hidden = false
                
                self.session = session
                self.getPlayslists(self.session)
            }
        } else { 
            loginButton.hidden = false
        }
    }
    
    func playTrack(sessionObj: SPTSession, track: SPTTrack) {
        player?.loginWithSession(sessionObj, callback: { (error: NSError!) -> Void in
            if error != nil {
                println("Enabling player got an error")
                return
            }
            
            SPTRequest.requestItemAtURI(NSURL(string: "spotify:album:4L1HDyfdGIkACuygktO7T7"), withSession: sessionObj, callback: { (error:NSError!, album: AnyObject!) -> Void in
                if error != nil {
                    println("album lookup got error\(error)")
                    return
                }

                let albumObj = album as SPTAlbum

                self.player?.playTrackProvider(albumObj, nil)
            })
        })
    }

    func updateAfterFirstLogin() {
        loginButton.hidden = true

        inputField.hidden = false
        searchButton.hidden = false
        tableView.hidden = false
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let sessionObj:AnyObject = userDefaults.objectForKey("SpotifySession") {
            let sessionDataObj = sessionObj as NSData
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObjectWithData(sessionDataObj) as SPTSession
            self.session = firstTimeSession
            self.getPlayslists(firstTimeSession)
        }
    }
    
   /* func getNextPage(sessionObj: SPTSession, callback: (page: SPTPlaylistList) -> Void) {
        page.requestNextPageWithSession(sessionObj, callback: { (error: NSError!, result: AnyObject!) -> Void in
            
            if error != nil {
                println("an error occurred")
                return
            }
            
            println("inside callback")
            
            //new_page = result as SPTPlaylistList
            //return result
        })
    }*/
    
    func getPlayslists(sessionObj: SPTSession) {
        if player == nil {
            player = SPTAudioStreamingController(clientId: kClientID)
            player?.playbackDelegate = self
        }
        
        player?.loginWithSession(sessionObj, callback: { (error: NSError!) -> Void in
            if error != nil {
                println("Enabling player got an error")
                return
            }
            
            /*SPTRequest.requestItemAtURI(NSURL(string: "spotify:album:4L1HDyfdGIkACuygktO7T7"), withSession: sessionObj, callback: { (error:NSError!, album: AnyObject!) -> Void in
            if error != nil {
            println("album lookup got error\(error)")
            return
            }
            
            let albumObj = album as SPTAlbum
            
            self.player?.playTrackProvider(albumObj, nil)
            })
            
            SPTRequest.performSearchWithQuery("let it go", queryType: SPTSearchQueryType.QueryTypeTrack, offset: 0, session: nil, callback: { (error: NSError!, result: AnyObject!) -> Void in
            
            let trackListPage = result as SPTListPage
            let partialTrack = trackListPage.items.first as SPTPartialTrack
            
            SPTRequest.requestItemFromPartialObject(partialTrack, withSession: nil, callback: { (error: NSError!, results: AnyObject!) -> Void in
            let track = results as SPTTrack
            
            self.player?.playTrackProvider(track, callback: nil)
            })
            
            })*/
            
            SPTRequest.playlistsForUserInSession(sessionObj, callback: { (error: NSError!, result: AnyObject!) -> Void in
                if error != nil {
                    println("an error occurred")
                    return
                }
                
                self.items = []

                self.page_pointer = result as SPTPlaylistList
                let size = Int(self.page_pointer.totalListLength)
                var counter: Int = 0
                
                println(size)
                
                for var i = 0; i < 20; ++i {
                    println(self.page_pointer.items[i].name)
                    self.items.append(String (self.page_pointer.items[i].name))
                }
                
                /*while size - counter > 0 {
                    println("next page")
                    
                    self.getNextPage(sessionObj, callback: {})
                    
                    counter += 20
                    println("counter: \(counter)")
                }*/
                
                self.tableView.reloadData()
            })
        })

    }
    
    @IBAction func loginWithSpotify(sender: AnyObject) {
        let auth = SPTAuth.defaultInstance()
        let loginURL = auth.loginURLForClientId(kClientID, declaredRedirectURL: NSURL(string: kCallbackURL), scopes: [SPTAuthStreamingScope, SPTAuthPlaylistModifyPublicScope])
        
        UIApplication.sharedApplication().openURL(loginURL)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "firstSegue") {
            var svc = segue!.destinationViewController as SecondViewController;
            
            svc.track_name = inputField.text
            svc.session = self.session
            svc.player = self.player
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
        
        //self.playTrack(<#sessionObj: SPTSession#>, indexPath.row)
    }
}

