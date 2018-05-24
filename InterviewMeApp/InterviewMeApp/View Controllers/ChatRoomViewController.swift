//
//  ChatRoomViewController.swift
//  InterviewMeApp
//
//  Created by Kevin Wood on 5/16/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit
import FirebaseAuth
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
        createRoom()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super .viewDidDisappear(animated)
        ChatRoomController.shared.leaveLobby()
        self.roomName = nil
    }
    
    private func createRoom() {
        guard let displayName =
            Auth.auth().currentUser?.displayName?.components(separatedBy: .whitespacesAndNewlines).joined() else { return }
        
        var internalRoomName: String?
        
        if roomName == nil {
            internalRoomName = displayName
        } else if roomName != nil {
            internalRoomName = roomName?.components(separatedBy: .whitespacesAndNewlines).joined()
        }
        
        do {
            let url = "\(baseTokenURL)name=\(displayName)&roomname=\(internalRoomName ?? "")"
            let token = try TokenUtils.fetchToken(url: url)
            let connectOptions = TVIConnectOptions(token: token) { (builder) in
                builder.roomName = internalRoomName
                
                if let audioTracks = self.localAudioTrack {
                    builder.audioTracks = [audioTracks]
                }
                
                if let videoTracks = self.localVideoTrack {
                    builder.videoTracks = [videoTracks]
                }
            }
            room = TwilioVideo.connect(with: connectOptions, delegate: self)
        } catch {
            print("Error Joining Room")
        }
    }
    
    private func setupRemote() {
        navigationController?.navigationBar.isHidden = true
        
        self.remoteView = TVIVideoView(frame: CGRect.zero, delegate: self)
        
        self.remoteView.contentMode = .scaleAspectFill
        
        self.remoteView.clipsToBounds = true
        
        self.view.insertSubview(remoteView, at: 0)
        
        let hangupButton = UIButton()
        hangupButton.setImage(#imageLiteral(resourceName: "End Call").withRenderingMode(.alwaysTemplate), for: .normal)
        hangupButton.tintColor = UIColor(red: 223/255, green: 23/255, blue: 26/255, alpha: 1.0)
        hangupButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.remoteView.addSubview(hangupButton)
        
        hangupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hangupButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        hangupButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        hangupButton.heightAnchor.constraint(equalToConstant: 120).isActive = true

        hangupButton.addTarget(self, action: #selector(hangupCall), for: .touchUpInside)
        
        remoteView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        remoteView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        remoteView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        remoteView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    @objc private func hangupCall() {
        navigationController?.popViewController(animated: true)
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
        previewView.shouldMirror = (source == .frontCamera)
    }
}

extension ChatRoomViewController: TVIRoomDelegate {
    
    func didConnect(to room: TVIRoom) {
        if room.remoteParticipants.count > 0 {
            self.remoteParticipant = room.remoteParticipants.first
            self.remoteParticipant?.delegate = self
        }
    }
    
    func room(_ room: TVIRoom, participantDidConnect participant: TVIRemoteParticipant) {
        participant.delegate = self
    }
    
    func room(_ room: TVIRoom, participantDidDisconnect participant: TVIRemoteParticipant) {
        ChatRoomController.shared.enterLobby()
    }
    
    func room(_ room: TVIRoom, didDisconnectWithError error: Error?) {
        ChatRoomController.shared.enterLobby()
    }
    
    func room(_ room: TVIRoom, didFailToConnectWithError error: Error) {
        navigationController?.popViewController(animated: true)
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
