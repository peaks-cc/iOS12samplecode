//
//  ViewController.swift
//  TryXcode10
//
//  Created by satoutakeshi on 2018/07/30.
//  Copyright © 2018年 Personal Factory. All rights reserved.
//

import UIKit
import os.signpost
class ViewController: UIViewController {

    var fetchImage = FetchImage()
    let imageUrlString = "https://www.dropbox.com/s/knf2y2fu2d5kwlz/green.png?dl=1"
    @IBOutlet weak var imageView: UIImageView!

    /// 画像を設定する。環境変数が設定されていればOSLogを記録する。
    func fetchSync() {
        let fetchOSLog: OSLog
        if ProcessInfo.processInfo.environment.keys.contains("SIGNPOST_FOR_FETCH") {
            fetchOSLog = OSLog(subsystem: "com.personal-factory.TryXcode10",
                               category: "fetchImage")
        } else {
            fetchOSLog = .disabled
        }
        let fetchSignpostID = OSSignpostID(log: fetchOSLog)
        os_signpost(.begin,
                    log: fetchOSLog,
                    name: "fetchAsset",
                    signpostID: fetchSignpostID,
                    "fetch start")
        let image = fetchImage.fetchAsset(type: FetchImage.ImageType.allCases.randomElement()!)
        imageView.image = image
        os_signpost(.end,
                    log: fetchOSLog,
                    name: "fetchAsset",
                    signpostID: fetchSignpostID,
                    "fetch end: %s", image.description)
    }

    @IBAction func addItem(_ sender: UIBarButtonItem) {
        fetchSync()
    }

    @IBAction func downloadImage(_ sender: UIBarButtonItem) {
        guard let url = URL(string: imageUrlString) else { return }

        // 非同期はOSSignpostIDを指定する
        let signpostID = OSSignpostID(log: OSLog.downloadImage, object: imageView)
        os_signpost(.begin, log: OSLog.downloadImage, name: "download", signpostID: signpostID, "download start")

        fetchImage.download(url: url, completion: {[weak self] (image) in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.imageView.image = image
                os_signpost(.end, log: OSLog.downloadImage, name: "download", signpostID: signpostID, "image: %s", image.description)
            }
        })
    }
}

struct FetchImage {
    enum ImageType: String, CaseIterable {
        case green = "green"
        case red = "red"
        case blue = "blue"
    }

    func fetchAsset(type: ImageType) -> UIImage {
        return UIImage(named: type.rawValue)!
    }

    private var task: URLSessionDataTask?

    mutating func download(url: URL, completion: @escaping ((UIImage) -> ()))  {

        task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            completion(image)
        }
        task?.resume()
    }

    mutating func downloadCancel() {
        task?.cancel()
        task = nil
    }
}
