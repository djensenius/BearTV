//
//  ViewController.swift
//  BearTV
//
//  Created by David Jensenius on 2016-10-25.
//  Copyright © 2016 David Jensenius. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var liveStream = ""
    var asset: AVAsset?
    var avPlayer = AVPlayer()
    let liveStreamID = "pHvmGucGm_E"
    var playingLive = true
    var notLiveBears: NSArray?
    var avPlayerLayer: AVPlayerLayer?
    var checkLiveStreamTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        notLiveBears = [
         "FL9YYKDMZO0",
         "lD63JOjqTDg",
         "W9ki8XT2UNA",
         "5ITc3Uclb40",
         "ltvxKi9rEkI",
         "4dXxojR818w",
         "4ZkuN7QPN-U",
         "M0-EeDD6Sa4",
         "QoQ_dHCi-08"]
 
        
        playLiveBear()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectBears))
        tapRecognizer.allowedPressTypes = [NSNumber(value: UIPressType.playPause.rawValue), NSNumber(value: UIPressType.select.rawValue)]
        self.view.addGestureRecognizer(tapRecognizer)

        
    }
    
    func checkLiveStream() {
        print("Checking live stream")
        if playingLive == true {
            let liveVideo : NSDictionary = HCYoutubeParser.h264videos(withYoutubeID: liveStreamID) as NSDictionary
            print("Live is \(liveVideo["live"]!) liveStream is \(liveStream)")
            if (liveVideo["live"]! as! String != liveStream) {
                print("GOTTA REDO")
                avPlayer.pause()
                avPlayerLayer!.removeFromSuperlayer()
                liveStream = liveVideo["live"] as! String
                asset = AVAsset(url: NSURL(string: liveStream)! as URL)
                let avPlayerItem = AVPlayerItem(asset:asset!)
                avPlayer = AVPlayer(playerItem: avPlayerItem)
                avPlayerLayer  = AVPlayerLayer(player: avPlayer)
                avPlayerLayer?.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
                self.view.layer.addSublayer(avPlayerLayer!)
                avPlayer.play()
            }
        }
    }
    
    func playNotLiveBear() {
        checkLiveStreamTimer?.invalidate()
        playingLive = false
        let randomIndex = Int(arc4random_uniform(UInt32((notLiveBears?.count)!)))
    
        avPlayer.pause()
        avPlayerLayer!.removeFromSuperlayer()
        let liveVideo : NSDictionary = HCYoutubeParser.h264videos(withYoutubeID: notLiveBears?[randomIndex] as! String) as NSDictionary
        let stream = liveVideo["medium"] as! String
        asset = AVAsset(url: NSURL(string: stream)! as URL)
 
        let avPlayerItem = AVPlayerItem(asset:asset!)
        avPlayer = AVPlayer(playerItem: avPlayerItem)
        avPlayerLayer  = AVPlayerLayer(player: avPlayer)
        avPlayerLayer?.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
        self.view.layer.addSublayer(avPlayerLayer!)
        avPlayer.play()
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
    }
 
    func playLiveBear() {
        checkLiveStreamTimer = Timer.scheduledTimer(timeInterval: 120, target: self, selector: #selector(checkLiveStream), userInfo: nil, repeats: true)

        playingLive = true
        NotificationCenter.default.removeObserver(self)
        let liveVideo : NSDictionary = HCYoutubeParser.h264videos(withYoutubeID: liveStreamID) as NSDictionary
        
        liveStream = liveVideo["live"] as! String
        asset = AVAsset(url: NSURL(string: liveStream)! as URL)
        
        let avPlayerItem = AVPlayerItem(asset:asset!)
        avPlayer = AVPlayer(playerItem: avPlayerItem)
        avPlayerLayer  = AVPlayerLayer(player: avPlayer)
        avPlayerLayer?.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
        self.view.layer.addSublayer(avPlayerLayer!)
        avPlayer.play()
    }
    
    func selectBears(gesture: UITapGestureRecognizer) {
        print("Hi david")
        showAlert(status: "Which 🐻", title:"")
    }
    
    func showAlert(status: String, title:String) { // 1
        let alertController = UIAlertController(title: status, message: title, preferredStyle: .alert) // 2
        
        let prerecordedBears = UIAlertAction(title: "Prerecorded 🐻", style: .cancel) { (action) in //3
            self.playNotLiveBear()
        }
        alertController.addAction(prerecordedBears)
        
        let liveBear = UIAlertAction(title: "Live 🐻", style: .default) { (action) in
            self.playLiveBear()
        } // 4
        alertController.addAction(liveBear)
        
        self.present(alertController, animated: true) { // 5
        }
    }
    
    func playerDidFinishPlaying(note: NSNotification) {
        print("Did finish playing");
        playNotLiveBear()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

