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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let urlString = "https://manifest.googlevideo.com/api/manifest/hls_variant/sparams/gcr%2Cgo%2Cid%2Cip%2Cipbits%2Citag%2Cmaudio%2Cplaylist_type%2Crequiressl%2Csource%2Ctx%2Ctxs%2Cexpire/go/1/id/pHvmGucGm_E.1/upn/pDka5K0-YJk/gcr/ca/signature/11DBCD0535334238F347FFD077DB495CF4824140.1FCEC5DF5AB54CF4E42971BBA0DE2D69F49DD7C5/playlist_type/DVR/itag/0/requiressl/yes/key/yt6/ip/70.35.217.14/ipbits/0/maudio/1/source/yt_live_broadcast/tx/9426732/expire/1477450355/txs/9426731%2C9426732/file/index.m3u8"
        let asset = AVAsset(url: NSURL(string: urlString)! as URL)
        
        let avPlayerItem = AVPlayerItem(asset:asset)
        let avPlayer = AVPlayer(playerItem: avPlayerItem)
        let avPlayerLayer  = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
        self.view.layer.addSublayer(avPlayerLayer)
        avPlayer.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

