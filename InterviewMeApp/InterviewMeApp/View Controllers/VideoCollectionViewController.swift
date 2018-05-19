//
//  VideoCollectionViewController.swift
//  InterviewMeApp
//
//  Created by Kevin Wood on 5/18/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit
import AVKit

private let reuseIdentifier = "VideoCell"

class VideoCollectionViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super .viewDidLoad()
        collectionView?.register(VideoCollectionCell.self, forCellWithReuseIdentifier: reuseIdentifier)
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
        navigationController?.navigationBar.tintColor = .blue
    }
}

extension VideoCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return VideoController.shared.videos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? VideoCollectionCell else { return UICollectionViewCell() }
        
        let video = VideoController.shared.videos[indexPath.row]
        
        cell.thumbnailImage.image = VideoController.shared.createThumbnail(url: video.url)
        print(video.url)
        cell.backgroundColor = .red
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let video = VideoController.shared.videos[indexPath.row]
        let player = AVPlayer(url: video.url)
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.present(playerController, animated: true) {
            player.play()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(20, 20, 20, 20)
    }
}
