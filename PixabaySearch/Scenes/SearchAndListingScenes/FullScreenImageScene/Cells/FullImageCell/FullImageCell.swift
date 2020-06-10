//
//  FullImageCell.swift
//  PixabaySearch
//
//  Created by Kunal Verma on 6/10/20.
//  Copyright © 2020 Kunal Verma. All rights reserved.
//

import UIKit
import Kingfisher

class FullImageCell: UICollectionViewCell {
    
    var imageData: PixImages?

    @IBOutlet weak var largeImageView: UIImageView!
    
    @IBAction func downloadImageTapped(_ sender: UIButton) {
        guard let largeImgUrl = imageData?.largeImageURL else {
            return
        }
        ImageSearchNetworkWorker().downloadAndSaveImage(url: largeImgUrl)
    }
    
    func configureCell(_ data: PixImages) {
        self.imageData = data
        largeImageView.kf.setImage(with: URL(string: data.webformatURL ?? ""), placeholder: R.image.placeHolder())
    }
    
    func cancelImageLoading() {
        largeImageView.kf.cancelDownloadTask()
    }
    
}
