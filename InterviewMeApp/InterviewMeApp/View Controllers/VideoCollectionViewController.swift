//
//  VideoCollectionViewController.swift
//  InterviewMeApp
//
//  Created by Kevin Wood on 5/18/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit
import AVKit
import MobileCoreServices


private let reuseIdentifier = "VideoCell"

class VideoCollectionViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super .viewDidLoad()
        collectionView?.register(VideoCollectionCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        navigationItem.titleView = logoTitleView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        setupNavigationBar()
        collectionView?.reloadData()
    }
    
    private func setupNavigationBar() {
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.backgroundImage(for: .default)
        navigationController?.navigationBar.barTintColor = nil
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.tintColor = mainColor
    }
}

extension VideoCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return VideoController.shared.videos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? VideoCollectionCell else { return UICollectionViewCell() }
        
        cell.delegate = self
        let video = VideoController.shared.videos[indexPath.row]
        guard let url = VideoController.shared.getPathDirectory(video: video) else { return UICollectionViewCell() }
        cell.thumbnailImage.image = VideoController.shared.createThumbnail(url: url.absoluteString)

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let video = VideoController.shared.videos[indexPath.row]
        guard let url = VideoController.shared.getPathDirectory(video: video) else { return }
        let player = AVPlayer(url: url)
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.present(playerController, animated: true) {
            player.play()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 20, bottom: 100, right: 30)
    }
}

extension VideoCollectionViewController: VideoCellDelegate {
    
    func deleteAlert(cell: VideoCollectionCell) {
        let alertController = UIAlertController(title: "Delete Video?", message: "Are you sure?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            guard let indexPath = self.collectionView?.indexPath(for: cell) else { return }
            let video = VideoController.shared.videos[indexPath.item]
            VideoController.shared.deleteVideo(video: video)
            self.collectionView?.deleteItems(at: [indexPath])
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        present(alertController, animated: true, completion: nil)
    }
}
