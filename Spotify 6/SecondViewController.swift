//
//  SecondViewController.swift
//  Spotify 6
//
//  Created by Tommaso on 1/3/15.
//  Copyright (c) 2015 Tommaso. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, SPTAudioStreamingPlaybackDelegate {
    
    var track_name:String!
    var session:SPTSession!
    var player:SPTAudioStreamingController!

    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var album_label: UILabel!
    @IBOutlet weak var uri_label: UILabel!
    @IBOutlet weak var playlist_input: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        println(track_name)
        self.playTrack(self.session)
    }
    
    func playTrack(sessionObj: SPTSession) {
        player?.loginWithSession(sessionObj, callback: { (error: NSError!) -> Void in
            if error != nil {
                println("Enabling player got an error")
                return
            }
            
            SPTRequest.performSearchWithQuery(self.track_name, queryType: SPTSearchQueryType.QueryTypeTrack, offset: 0, session: nil, callback: { (error: NSError!, result: AnyObject!) -> Void in
            
                let trackListPage = result as SPTListPage
                let partialTrack = trackListPage.items.first as SPTPartialTrack
            
                SPTRequest.requestItemFromPartialObject(partialTrack, withSession: nil, callback: { (error:     NSError!, results: AnyObject!) -> Void in
                    let track = results as SPTTrack
                    
                    self.name_label.text = track.name
                    
                    //self.album_label.text = String (track.album)
                    //self.uri_label.text = String (track.uri)
            
                    //self.player?.playTrackProvider(track, callback: nil)
                })
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "secondSegue") {
            var svc = segue!.destinationViewController as ThirdViewController;
            
            svc.playlist_name = self.playlist_input.text
            svc.session = self.session
            svc.player = self.player
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
