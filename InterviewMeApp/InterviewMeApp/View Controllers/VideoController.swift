//
//  VideoController.swift
//  InterviewMeApp
//
//  Created by Kevin Wood on 5/18/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit
import AVFoundation

class VideoController {
    
    static let shared = VideoController()
    
    var videos: [Video] = []
    
    //MARK: - CRUD
    
    //Create
    func createVideo(permanentURL: URL) {
        let video = Video(url: permanentURL)
        videos.append(video)
    }
    
    //Save
    func saveVideoWithURL(tempURL: URL, completion: @escaping(URL?) -> Void){
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(tempURL.lastPathComponent)
        print(destinationUrl)
        
        // to check if it exists before downloading it
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            print("The file already exists at path")
            
            // if the file doesn't exist
        } else {
            
            URLSession.shared.downloadTask(with: tempURL, completionHandler: { (location, response, error) -> Void in
                guard let location = location, error == nil else { return }
                do {
                    // after downloading your file you need to move it to your destination url
                    try FileManager.default.moveItem(at: location, to: destinationUrl)
                    
                    completion(destinationUrl)
                } catch {
                    print(error.localizedDescription)
                    completion(nil)
                }
            }).resume()
        }
    }
    
    //Load
    private func loadVideos() -> [Video] {
        do {
            let jsonDecoder = JSONDecoder()
            let data = try Data(contentsOf: fileURL())
            let videos = try jsonDecoder.decode([Video].self, from: data)
            return videos
        } catch {
            print("Error loading videos : \(error.localizedDescription)")
        }
        return []
    }
    
    //Delete
    func deleteVideo(video: Video) {
        guard let index = videos.index(of: video) else { return }
        videos.remove(at: index)
        
    }
    
    private func fileURL() -> URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fullURL = documentDirectory.appendingPathComponent("Movies").appendingPathExtension("json")
        return fullURL
    }
    
    func createThumbnail(url: URL) -> UIImage? {
        do {
            let asset = AVAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imageGenerator.copyCGImage(at: CMTime(seconds: 5, preferredTimescale: 0), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch {
            print("Error creating thumbnail: \(error.localizedDescription)")
        }
        return nil
    }
    
    private init() {
        videos = loadVideos()
    }
}
