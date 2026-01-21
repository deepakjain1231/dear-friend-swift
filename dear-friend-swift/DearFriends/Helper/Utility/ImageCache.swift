//
//  ImageCache.swift
//  Dear Friends
//
//  Created by DEEPAK JAIN on 21/01/26.
//

import UIKit

final class RemoteImageCacheLoader {

    static let shared = RemoteImageCacheLoader()

    private let memoryCache = NSCache<NSString, UIImage>()

    private init() {}

    func loadImage(from urlString: String,
                   into imageView: UIImageView,
                   placeholder: UIImage? = nil) {

        guard let url = URL(string: urlString) else { return }

        let cacheKey = (urlString.components(separatedBy: "?").first ?? "") as NSString

        print(cacheKey)
        // 1️⃣ Memory cache
        if let image = memoryCache.object(forKey: cacheKey) {
            imageView.image = image
            return
        }

        // 2️⃣ Disk cache (internal only)
        if let diskImage = loadFromDisk(key: cacheKey as String) {
            memoryCache.setObject(diskImage, forKey: cacheKey)
            imageView.image = diskImage
            return
        }

        imageView.image = placeholder

        // 3️⃣ Download
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self,
                  let data = data,
                  let image = UIImage(data: data) else { return }

            print(cacheKey)
            self.memoryCache.setObject(image, forKey: cacheKey)
            self.saveToDisk(image, key: cacheKey as String)

            DispatchQueue.main.async {
                imageView.image = image
            }
        }.resume()
    }
}


extension RemoteImageCacheLoader {

    func cacheDirectory() -> URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }

    func fileURL(for key: String) -> URL {
        let safeKey = key.replacingOccurrences(of: "/", with: "_")
        return cacheDirectory().appendingPathComponent(safeKey)
    }

    func saveToDisk(_ image: UIImage, key: String) {
        guard let data = image.pngData() else { return }
        try? data.write(to: fileURL(for: key), options: .atomic)
    }

    func loadFromDisk(key: String) -> UIImage? {
        let url = fileURL(for: key)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }
}
