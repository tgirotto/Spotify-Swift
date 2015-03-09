//
//  ThirdViewController.swift
//  Spotify 6
//
//  Created by Tommaso on 3/3/15.
//  Copyright (c) 2015 Tommaso. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    
    var playlist_name:String!
    var session:SPTSession!
    var player:SPTAudioStreamingController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        println(playlist_name)
        
        var flag: ObjCBool = true
        
       /* SPTPlaylistList.createPlaylistWithName(NSString(string:"hello"), publicFlag: 1, self.session, callback: {(error: NSError!, result: AnyObject!) -> Void in
            println("playlist created")
        })*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
