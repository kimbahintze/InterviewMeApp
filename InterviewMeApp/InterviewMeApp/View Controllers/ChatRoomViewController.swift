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
    
    //MARK: - Properties
    
    let baseTokenURL = "https://wisteria-saola-1695.twil.io/create-video-token?"
    
    var roomName: String?
    var room: TVIRoom?
    var camera: TVICameraCapturer?
    var localVideoTrack: TVILocalVideoTrack?
    var localAudioTrack = TVILocalAudioTrack()
    var remoteParticipant: TVIRemoteParticipant?

  
    @IBOutlet weak var previewView: TVIVideoView!
    var remoteView: TVIVideoView!
    
    let activityIndicator : UIActivityIndicatorView = {
       let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        indicator.startAnimating()
        return indicator
    }()
    
    let boxView : UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let waitingLabel : UILabel = {
        let label = UILabel()
        label.text = "Waiting on others to join"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont(name: GTWalsheimMedium, size: 20)
        label.textColor = UIColor(white: 0.9, alpha: 0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let hangupButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "End Call"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ChatRoomController.shared.enterLobby()
        startPreview()
        createRoom()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super .viewDidDisappear(animated)
        ChatRoomController.shared.leaveLobby()
        self.roomName = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    //MARK: - Actions
    
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
        
        self.remoteView.addSubview(hangupButton)
        
        hangupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hangupButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        hangupButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        hangupButton.heightAnchor.constraint(equalToConstant: 80).isActive = true

        hangupButton.addTarget(self, action: #selector(hangupCall), for: .touchUpInside)
        
        remoteView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        remoteView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        remoteView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        remoteView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        stopActivityIndicator()
    }
    
    private func removeRemote() {
        navigationController?.navigationBar.isHidden = false
        remoteView.removeFromSuperview()
        hangupButton.removeFromSuperview()
        startActivityIndicator()
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
        startActivityIndicator()
    }
    
    private func startActivityIndicator() {
        view.addSubview(boxView)
        boxView.contentView.addSubview(waitingLabel)
        boxView.contentView.addSubview(activityIndicator)
        
        boxView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        boxView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -5).isActive = true
        boxView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        boxView.widthAnchor.constraint(equalToConstant: 150).isActive = true

        waitingLabel.centerXAnchor.constraint(equalTo: boxView.centerXAnchor).isActive = true
        waitingLabel.centerYAnchor.constraint(equalTo: boxView.centerYAnchor, constant: -20).isActive = true
        waitingLabel.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: 8).isActive = true
        waitingLabel.trailingAnchor.constraint(equalTo: boxView.trailingAnchor, constant: -8).isActive = true
        
        activityIndicator.frame = CGRect(x: 75, y: 110, width: 0, height: 0)
        
    }
    private func stopActivityIndicator() {

        waitingLabel.removeFromSuperview()
        boxView.removeFromSuperview()
        activityIndicator.stopAnimating()
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
        removeRemote()
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
