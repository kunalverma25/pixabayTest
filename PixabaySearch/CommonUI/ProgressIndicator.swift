//
//  ProgressIndicator.swift
//  PixabaySearch
//
//  Created by Kunal Verma on 6/10/20.
//  Copyright © 2020 Kunal Verma. All rights reserved.
//

import Foundation
import UIKit

public class ProgressIndicator: NSObject {
    public var springIndicatorView: SpringIndicatorView!
    public var messageLabel: UILabel!
    public var progressView        = UIView()

    public init(withView pView: UIView) {
        super.init()
        progressView.frame = CGRect(x: 0, y: 0, width: pView.frame.size.width, height: pView.frame.size.height)
        progressView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        progressView.isHidden = true
        progressView.backgroundColor = UIColor(white: 1, alpha: 0.4)

        springIndicatorView = SpringIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        springIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        springIndicatorView.center = progressView.center
        progressView.addSubview(springIndicatorView)
        pView.addSubview(progressView)
    }
    
    public convenience init(withView pView: UIView, topDistance: CGFloat) {
        self.init(withView: pView)
        progressView.frame = CGRect(x: 0, y: topDistance, width: pView.frame.size.width, height: pView.frame.size.height - topDistance)
        springIndicatorView.center = CGPoint(x: springIndicatorView.center.x, y: springIndicatorView.center.y - topDistance/2)
    }

    public func setAlpha(_ value: Double) {
        progressView.backgroundColor = UIColor(white: 1, alpha: CGFloat(value))
    }

    public func setMessage(_ msg: String) {
        progressView.backgroundColor = UIColor(white: 1, alpha: 0.8)
        if messageLabel == nil {
            messageLabel                = UILabel(frame: CGRect(x: 0, y: 0, width: 280, height: 42))
            messageLabel.numberOfLines  = 0
            messageLabel.center         = CGPoint(x: progressView.center.x, y: progressView.center.y + 60)
            messageLabel.textColor      = UIColor.black
            messageLabel.font           = UIFont.systemFont(ofSize: 14)
            messageLabel.textAlignment  = .center
            messageLabel.text           = msg
            progressView.addSubview(messageLabel)
        } else {
            messageLabel.text           = msg
        }
    }

    public func showProgressView() {
        DispatchQueue.main.async {
            self.progressView.window?.endEditing(true)
            self.progressView.isHidden = false
            self.springIndicatorView.startAnimation()
        }
    }

    public func hideProgressView() {
        DispatchQueue.main.async {
            self.progressView.isHidden = true
            self.springIndicatorView.stopAnimation(false)
        }
    }
}
