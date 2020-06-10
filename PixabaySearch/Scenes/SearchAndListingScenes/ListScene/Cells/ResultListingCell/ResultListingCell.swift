//
//  ResultListingCell.swift
//  PixabaySearch
//
//  Created by Kunal Verma on 6/10/20.
//  Copyright © 2020 Kunal Verma. All rights reserved.
//

import UIKit
import Kingfisher

class ResultListingCell: UITableViewCell {
    
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()
        userImageView.layer.cornerRadius = userImageView.bounds.height / 2
        userImageView.layer.masksToBounds = true
    }
    
    func configureCell(data: PixImages) {
        resultImageView.kf.setImage(with: URL(string: data.previewURL ?? ""), placeholder: R.image.placeHolder())
        userImageView.kf.setImage(with: URL(string: data.userImageURL ?? ""), placeholder: R.image.userImage())
        userNameLabel.text = data.user
        likeLabel.text = data.likes?.succinctString ?? "0"
        commentLabel.text = data.comments?.succinctString ?? "0"
        viewsLabel.text = data.views?.succinctString ?? "0"
    }
    
    func cancelImageDownload() {
        resultImageView.kf.cancelDownloadTask()
        userImageView.kf.cancelDownloadTask()
    }
    
}

fileprivate extension Int {
    var succinctString: String {
        return self > 1000 ? "1000+" : "\(self)"
    }
}
