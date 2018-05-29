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
    
    var isRecording = false
    var progress: CGFloat = 0
    var progressTime: Timer!
    let cameraView = CameraView(frame: UIScreen.main.bounds)
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        self.videoGravity = .resizeAspectFill
        super .viewDidLoad()
        cameraDelegate = self
        defaultCamera = .front
        setupViews()
        cameraView.cameraViewController = self
        guard let captureButton = cameraView.recordButton as UIButton as? SwiftyCamButton else { return }
        captureButton.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        cameraView.setupNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        Timer.scheduledTimer(withTimeInterval: 0.35, repeats: false) { (_) in
            self.view.addSubview(self.cameraView)
        }
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
    }
    
    private func showQuestionView() {
        guard let navigationBarHeight = navigationController?.navigationBar.frame.height else { return }
        cameraView.questionView.center.y = navigationBarHeight + 40
    }
    
    private func hideQuestionView() {
        guard let navigationBarHeight = navigationController?.navigationBar.frame.height else { return }
        cameraView.questionView.center.y = -navigationBarHeight - 100
    }
    
    @objc func record() {
        if isRecording {
            stopRecording()
            UIView.animate(withDuration: 0.33) {
                self.hideQuestionView()
            }
        } else {
            startRecording()
            UIView.animate(withDuration: 0.33) {
                self.showQuestionView()
            }
        }
    }
    
    @objc private func startRecording() {
        cameraView.recordButton.buttonState = .recording
        isRecording = true
        progressTime = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        startVideoRecording()
        navigationController?.navigationBar.isHidden = true
    }
    
    @objc private func stopRecording() {
        cameraView.recordButton.buttonState = .idle
        self.progress = 0
        isRecording = false
        progressTime.invalidate()
        stopVideoRecording()
        startActivityIndicator()
        navigationController?.navigationBar.isHidden = false
    }
    
    @objc private func updateProgress() {
        let maxDuration: CGFloat = 180
        let increment: CGFloat = 0.05
        
        self.progress = progress + (increment / maxDuration)
        cameraView.recordButton.setProgress(progress)
        if progress >= 1 {
            progressTime.invalidate()
            isRecording = false
            self.progress = 0 
            cameraView.recordButton.buttonState = .idle
            stopVideoRecording()
            stopActivityIndicator()
        }
    }
    
    @objc func popController() {
        navigationController?.popViewController(animated: true)
    }

    func startActivityIndicator() {
        cameraView.boxView.isHidden = false
    }
    
    func stopActivityIndicator() {
        cameraView.savingLabel.removeFromSuperview()
        cameraView.boxView.removeFromSuperview()
        popController()
    }
}

extension CameraViewController: SwiftyCamViewControllerDelegate {
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        let newURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".mov")
        VideoController.shared.compressVideo(inputURL: url, outputURL: newURL) { (exportSession) in
            if exportSession?.status == .completed {
                DispatchQueue.main.async {
                    VideoController.shared.saveVideoWithURL(tempURL: newURL, completion: { (url) in
                        if let url = url {
                            let stringURL = "\(url)"
                            VideoController.shared.recordVideo(videoURL: stringURL)
                            VideoController.shared.deleteTempDirectory()
                        }
                    })
                    self.stopActivityIndicator()
                    InterviewQuestionController.shared.removeInterviewQuestion()
                }
            } else if exportSession?.status == .failed {
                print("there was a problem compressing")
            }
        }
    }
}
