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
    
    let baseTokenURL = "https://wisteria-saola-1695.twil.io/create-video-token?"
    
    var roomName: String?
    var room: TVIRoom?
    var camera: TVICameraCapturer?
    var localVideoTrack: TVILocalVideoTrack?
    var localAudioTrack = TVILocalAudioTrack()
    var remoteParticipant: TVIRemoteParticipant?
    
    @IBOutlet weak var previewView: TVIVideoView!
    var remoteView: TVIVideoView?
    
    override func viewDidLoad() {
        super .viewDidLoad()
        ChatRoomController.shared.enterLobby()
        joinRoom()
        startPreview()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super .viewDidDisappear(animated)
        ChatRoomController.shared.leaveLobby()
        roomName = nil
    }
    
    private func joinRoom() {
        guard let displayName = ChatRoomController.shared.user?.displayName?.components(separatedBy: .whitespacesAndNewlines).joined() else { return }
        
        var token = "ACCESS_TOKEN"
        var internalRoomName = "ROOM_NAME".components(separatedBy: .whitespacesAndNewlines).joined()
        
        if roomName == nil {
            internalRoomName = displayName
        } else if roomName != nil {
            internalRoomName = (roomName?.components(separatedBy: .whitespacesAndNewlines).joined())!
        }
        
        do {
            let url = "\(baseTokenURL)name=\(displayName)&roomname=\(internalRoomName)"
            token = try TokenUtils.fetchToken(url: url)
        } catch {
            print("Error Creating Room")
        }
        
        let connectOptions = TVIConnectOptions(token: token) { (builder) in
            builder.roomName = internalRoomName
            
            if let videoTrack = self.localVideoTrack {
                builder.videoTracks = [videoTrack]
            }
            
            if let audioTrack = self.localAudioTrack {
                builder.audioTracks = [audioTrack]
            }
        }
        room = TwilioVideo.connect(with: connectOptions, delegate: self)
    }
    
    private func startPreview() {
        camera = TVICameraCapturer(source: .frontCamera, delegate: self)
        localVideoTrack = TVILocalVideoTrack.init(capturer: camera!, enabled: true, constraints: nil, name: "Camera")
        previewView.contentMode = .scaleAspectFit
        if (localVideoTrack == nil) {
        } else {
            // Add renderer to video track for local preview
            localVideoTrack!.addRenderer(self.previewView)
        }
    }
    
    private func setupRemoteView() {
        remoteView = TVIVideoView(frame: CGRect.zero, delegate: self)
        
        self.view.insertSubview(remoteView!, at: 0)
        
        self.remoteView?.contentMode = .scaleAspectFit
        
        remoteView?.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        remoteView?.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        remoteView?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        remoteView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension ChatRoomViewController: TVICameraCapturerDelegate {
    
    func cameraCapturer(_ capturer: TVICameraCapturer, didStartWith source: TVICameraCaptureSource) {
        previewView.shouldMirror = (source == .frontCamera)
    }
}

extension ChatRoomViewController: TVIRoomDelegate {
    
    func didConnect(to room: TVIRoom) {
        print("\(room.localParticipant?.identity) Owns this lobby, \(room.remoteParticipants.first?.identity) Joined")
        room.remoteParticipants.first?.delegate = self
    }
    
    func room(_ room: TVIRoom, participantDidConnect participant: TVIRemoteParticipant) {
        if remoteParticipant == nil {
            print("Remote Participant Nil")
            participant.delegate = self
        }
    }
    
    func room(_ room: TVIRoom, participantDidDisconnect participant: TVIRemoteParticipant) {
        navigationController?.popViewController(animated: true)
    }
}

extension ChatRoomViewController: TVIRemoteParticipantDelegate {
    func subscribed(to videoTrack: TVIRemoteVideoTrack, publication: TVIRemoteVideoTrackPublication, for participant: TVIRemoteParticipant) {
        print("Subscribed")
        if remoteParticipant != nil {
            setupRemoteView()
            videoTrack.addRenderer(remoteView!)
        }
    }
}


extension ChatRoomViewController: TVIVideoViewDelegate {
    func videoView(_ view: TVIVideoView, videoDimensionsDidChange dimensions: CMVideoDimensions) {
        view.setNeedsLayout()
    }
}
