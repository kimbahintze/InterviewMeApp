//
//  ChatRoomViewController.swift
//  InterviewMeApp
//
//  Created by Kevin Wood on 5/16/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit
import TwilioVideo

class ChatRoomViewController: UIViewController {
    
    let baseTokenURL = "https://wisteria-saola-1695.twil.io/create-video-token"
    
    var camera: TVICameraCapturer?
    var localVideoTrack: TVILocalVideoTrack?
    var localAudioTrack = TVILocalAudioTrack()
    
    @IBOutlet weak var previewView: TVIVideoView!
    
    override func viewDidLoad() {
        super .viewDidLoad()
        ChatRoomController.shared.enterLobby()
        startPreview()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super .viewDidDisappear(animated)
        ChatRoomController.shared.leaveLobby()
    }
    
    private func startPreview() {
        camera = TVICameraCapturer(source: .frontCamera, delegate: self)
        previewView.contentMode = .scaleAspectFit
        localVideoTrack = TVILocalVideoTrack(capturer: camera!)
        localVideoTrack?.addRenderer(previewView)
    }
}

extension ChatRoomViewController: TVICameraCapturerDelegate {
    
    func cameraCapturer(_ capturer: TVICameraCapturer, didStartWith source: TVICameraCaptureSource) {
        previewView.shouldMirror = (source == .frontCamera)
    }
}
