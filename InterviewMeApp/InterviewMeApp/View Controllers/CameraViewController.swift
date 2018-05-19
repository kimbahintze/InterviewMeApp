//
//  CameraViewController.swift
//  InterviewMeApp
//
//  Created by Kevin Wood on 5/18/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit
import SwiftyCam
import RecordButton

class CameraViewController: SwiftyCamViewController {
    
    //MARK: - Properties
    
    let recordButton: RecordButton = {
        let button = RecordButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.buttonColor = .white
        button.progressColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var isRecording = false
    var progress: CGFloat = 0
    var progressTime: Timer!
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super .viewDidLoad()
        cameraDelegate = self
        defaultCamera = .front
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        setupNavigationBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupViews() {
        tabBarController?.tabBar.isHidden = true
        maximumVideoDuration = 180
        swipeToZoom = false
        pinchToZoom = false
        tapToFocus = true
        shouldUseDeviceOrientation = true
        allowBackgroundAudio = true
        lowLightBoost = true
        
        recordButton.addTarget(self, action: #selector(record), for: .touchUpInside)
        view.addSubview(recordButton)
        view.bringSubview(toFront: recordButton)
        
        recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        recordButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        recordButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        recordButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        guard let captureButton = recordButton as UIButton as? SwiftyCamButton else { return }
        captureButton.delegate = self
    }
    
    @objc private func record() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    @objc private func startRecording() {
        recordButton.buttonState = .recording
        isRecording = true
        progressTime = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        startVideoRecording()
    }
    
    @objc private func stopRecording() {
        recordButton.buttonState = .idle
        self.progress = 0
        isRecording = false
        progressTime.invalidate()
        stopVideoRecording()
    }
    
    @objc private func updateProgress() {
        let maxDuration: CGFloat = 180
        let increment: CGFloat = 0.05
        
        self.progress = progress + (increment / maxDuration)
        recordButton.setProgress(progress)
        if progress >= 1 {
            progressTime.invalidate()
            isRecording = false
            self.progress = 0 
            recordButton.buttonState = .idle
        }
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Back").withRenderingMode(.alwaysTemplate), style: .done, target: self, action: #selector(popController))
        navigationController?.navigationBar.tintColor = .orange
    }
    
    @objc private func popController() {
        navigationController?.popViewController(animated: true)
    }
}

extension CameraViewController: SwiftyCamViewControllerDelegate {
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Recording")
        
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("End Recording")
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        VideoController.shared.createVideo(url: url)
    }
    
    
}