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
    var remoteView: TVIVideoView!
    
    override func viewDidLoad() {
        super .viewDidLoad()
        ChatRoomController.shared.enterLobby()
        startPreview()
        if roomName == nil {
            createRoom()
        } else if roomName != nil {
            joinRoom()
        }
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super .viewDidDisappear(animated)
        ChatRoomController.shared.leaveLobby()
        self.roomName = nil
    }
    
    private func createRoom() {
        do {
            guard let displayName = ChatRoomController.shared.user?.displayName?.components(separatedBy: .whitespacesAndNewlines).joined(),
                let roomName = ChatRoomController.shared.user?.displayName?.components(separatedBy: .whitespacesAndNewlines).joined() else { return }
            let url = "\(baseTokenURL)name=\(displayName)&roomname=\(roomName)"
            let token = try TokenUtils.fetchToken(url: url)
            let connectOptions = TVIConnectOptions(token: token) { (builder) in
                builder.roomName = roomName
                
                if let audioTracks = self.localAudioTrack {
                    print("Audio Tracks")
                    builder.audioTracks = [audioTracks]
                }
                
                if let videoTracks = self.localVideoTrack {
                    print("Video Tracks")
                    builder.videoTracks = [videoTracks]
                }
            }
            room = TwilioVideo.connect(with: connectOptions, delegate: self)
        } catch {
            print("Error Creating Room")
        }
    }
    
    private func joinRoom() {
        do {
            guard let displayName = ChatRoomController.shared.user?.displayName?.components(separatedBy: .whitespacesAndNewlines).joined(), let internalRoomName = roomName?.components(separatedBy: .whitespacesAndNewlines).joined() else { return }
            
            let url = "\(baseTokenURL)name=\(displayName)&roomname=\(internalRoomName)"
            let token = try TokenUtils.fetchToken(url: url)
            print("Join Token: \(token)")
            let connectOptions = TVIConnectOptions(token: token) { (builder) in
                builder.roomName = internalRoomName
                
                if let audioTracks = self.localAudioTrack {
                    print("Audio Tracks")
                    builder.audioTracks = [audioTracks]
                }
                
                if let videoTracks = self.localVideoTrack {
                    print("Video Tracks")
                    builder.videoTracks = [videoTracks]
                }
            }
            room = TwilioVideo.connect(with: connectOptions, delegate: self)
        } catch {
            print("Error Joining Room")
        }
    }
    
    private func setupRemote() {
        self.remoteView = TVIVideoView(frame: CGRect.zero, delegate: self)
        
        self.remoteView.contentMode = .scaleAspectFill
        
        self.remoteView.clipsToBounds = true
        
        self.view.insertSubview(remoteView, at: 0)
        
        remoteView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        remoteView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        remoteView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        remoteView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func startPreview() {
        if let camera = TVICameraCapturer(source: .frontCamera) {
            let videoTrack = TVILocalVideoTrack(capturer: camera)
            videoTrack?.addRenderer(previewView)
            self.localVideoTrack = videoTrack
            self.camera = camera
            previewView.contentMode = .scaleAspectFill
            previewView.clipsToBounds = true
        }
    }
}

extension ChatRoomViewController: TVICameraCapturerDelegate {
    
    func cameraCapturer(_ capturer: TVICameraCapturer, didStartWith source: TVICameraCaptureSource) {
//        previewView.shouldMirror = (source == .frontCamera)
    }
}

extension ChatRoomViewController: TVIRoomDelegate {
    
    func didConnect(to room: TVIRoom) {
        if room.remoteParticipants.count > 0 {
            print("\(room.localParticipant?.identity) is local, \(room.remoteParticipants.first?.identity) remote")
            self.remoteParticipant = room.remoteParticipants.first
            self.remoteParticipant?.delegate = self
            print(remoteParticipant?.delegate)
        }
    }
    
    func room(_ room: TVIRoom, participantDidConnect participant: TVIRemoteParticipant) {
        participant.delegate = self
    }
    
    func room(_ room: TVIRoom, participantDidDisconnect participant: TVIRemoteParticipant) {
        navigationController?.popViewController(animated: true)
        ChatRoomController.shared.enterLobby()
    }
}

extension ChatRoomViewController: TVIRemoteParticipantDelegate {
    func subscribed(to videoTrack: TVIRemoteVideoTrack, publication: TVIRemoteVideoTrackPublication, for participant: TVIRemoteParticipant) {
        setupRemote()
        videoTrack.addRenderer(self.remoteView!)
        ChatRoomController.shared.leaveLobby()
    }
}


extension ChatRoomViewController: TVIVideoViewDelegate {
    func videoView(_ view: TVIVideoView, videoDimensionsDidChange dimensions: CMVideoDimensions) {
        view.setNeedsLayout()
    }
}
