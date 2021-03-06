//
//  VideoController.swift
//  InterviewMeApp
//
//  Created by Kevin Wood on 5/18/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class VideoController {
    
    static let shared = VideoController()
    
    var videos: [Video] {
        return fetchFromCoreData()
    }
    
    //MARK: - CRUD and Fetch
    
    func recordVideo(videoURL: String) {
        let _ = Video(videoURL: videoURL)
        saveToCoreData()
    }
    
    func deleteVideo(video: Video) {
        video.managedObjectContext?.delete(video)
        guard let videoString = video.videoURL else { return }
        deleteFromDocumentsDirectory(videoURLString: videoString)
        deleteTempDirectory()
        saveToCoreData()
    }
    
    func saveToCoreData() {
        let moc = CoreDataStack.context
        do {
            try moc.save()
        } catch let error {
            print("error saving to CD", error.localizedDescription)
        }
    }
    
    func fetchFromCoreData() -> [Video] {
        let moc = CoreDataStack.context
        var videosToReturn: [Video]
        let request: NSFetchRequest<Video> = Video.fetchRequest()
        do {
            videosToReturn = try moc.fetch(request)
            return videosToReturn
        } catch let error {
            print("error fetching videos", error)
        }
        return []
    }
    
    //MARK: Save and Delete from URL
    func saveVideoWithURL(tempURL: URL, completion: @escaping(URL?) -> Void){
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(tempURL.lastPathComponent)

        // to check if it exists before downloading it
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            
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
    
    func deleteFromDocumentsDirectory(videoURLString: String) {
        print("videoURLSTRING", videoURLString)
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        guard let baseURL = URL(string: videoURLString) else { return }
        let url = documentsDirectory.appendingPathComponent(baseURL.lastPathComponent)
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])
            do {
                for file in directoryContents {
                    if url == documentsDirectory.appendingPathComponent(file.lastPathComponent) {
                        try FileManager.default.removeItem(at: file)
                    }
                }
            } catch {
                print("Could not delete at the folder:", error.localizedDescription)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteTempDirectory() {
        let baseURL = FileManager.default.temporaryDirectory
        do {
            let tempContents = try FileManager.default.contentsOfDirectory(at: baseURL, includingPropertiesForKeys: nil, options: [])
            for path in tempContents {
                try FileManager.default.removeItem(at: path)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - Get Path Directory
    func getPathDirectory(video: Video) -> URL? {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        guard let videoURLAsString = video.videoURL else { return nil}
        guard let videoURL = URL(string: videoURLAsString) else { return nil}
        let url = documentDirectory.appendingPathComponent(videoURL.lastPathComponent)
        return url
    }
    
    //MARK: - Create Thumbnail
    func createThumbnail(url: String) -> UIImage? {
        guard let url = URL(string: url) else { return nil}
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        do {
            imageGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imageGenerator.copyCGImage(at: CMTimeMake(2, 10), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch {
            print("Error creating thumbnail: \(error.localizedDescription)")
        }
        return nil
    }
    
    //MARK: - Compress Video
    
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality) else {
            handler(nil)
            return
        }
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
}



