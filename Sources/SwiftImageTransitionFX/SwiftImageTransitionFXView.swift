//
//  SwiftImageTransitionFXView.swift
//
//
//  Created by Furkan Sandal on 19.03.2024.
//

import SnapKit
import UIKit

public class SwiftImageTransitionFXView: UIView {
    private let beforeImageView = UIImageView()
    private let afterImageView = UIImageView()
    private let maskLayer = CALayer()
    private let borderLayer = CALayer()

    public var transitionColor = UIColor.white
    public var transitionWidth: CGFloat = 5
    public var forwardSpeed: CGFloat = 3.0
    public var backwardSpeed: CGFloat = 3.0
    public var isInfinityLoop = true
    public var enableReturnBackAfterForward = true
    public var loopWaitTime: CGFloat = 0
    
    public var imageContentMode: UIView.ContentMode = .scaleAspectFit {
        didSet {
            beforeImageView.contentMode = imageContentMode
            afterImageView.contentMode = imageContentMode
        }
    }

    public init() {
        super.init(frame: .zero)
        setupViews()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func populate(beforeImage: UIImage?, afterImage: UIImage?) {
        beforeImageView.image = beforeImage
        afterImageView.image = afterImage
    }

    public func start() {
        forwardAnimation()
    }
}

private extension SwiftImageTransitionFXView {
    func setupViews() {
        addSubview(beforeImageView)
        addSubview(afterImageView)
        beforeImageView.contentMode = imageContentMode
        afterImageView.contentMode = imageContentMode

        beforeImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        afterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        clipsToBounds = true
    }

    func configureBorderLayer() {
        borderLayer.backgroundColor = transitionColor.cgColor
        borderLayer.frame = CGRect(x: afterImageView.frame.width, y: 0, width: transitionWidth, height: afterImageView.frame.height)
        afterImageView.layer.addSublayer(borderLayer)
    }

    @objc func forwardAnimation() {
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: 0, y: 0, width: 0, height: afterImageView.frame.height)
        afterImageView.layer.mask = maskLayer

        configureBorderLayer()
        let forwardAnimation = CABasicAnimation(keyPath: "bounds")
        forwardAnimation.fromValue = NSValue(cgRect: maskLayer.bounds)
        forwardAnimation.toValue = NSValue(cgRect: CGRect(x: 0, y: 0, width: afterImageView.frame.width * 2, height: afterImageView.frame.height))
        forwardAnimation.duration = forwardSpeed
        forwardAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        forwardAnimation.fillMode = .forwards
        forwardAnimation.isRemovedOnCompletion = false
        forwardAnimation.delegate = self
        forwardAnimation.setValue("forwardAnimation", forKey: "id")

        maskLayer.add(forwardAnimation, forKey: "maskAnimation")

        let forwardBorderAnimation = CABasicAnimation(keyPath: "position.x")
        forwardBorderAnimation.fromValue = 0 - borderLayer.frame.width / 2
        forwardBorderAnimation.toValue = afterImageView.frame.width - borderLayer.frame.width / 2
        forwardBorderAnimation.duration = forwardSpeed
        forwardBorderAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        forwardBorderAnimation.fillMode = .forwards
        forwardBorderAnimation.isRemovedOnCompletion = false

        borderLayer.add(forwardBorderAnimation, forKey: "borderReverseAnimation")
    }

    @objc func backwardAnimation() {
        let reverseAnimation = CABasicAnimation(keyPath: "bounds")
        reverseAnimation.fromValue = NSValue(cgRect: CGRect(x: 0, y: 0, width: afterImageView.frame.width * 2, height: afterImageView.frame.height))
        reverseAnimation.toValue = NSValue(cgRect: CGRect(x: 0, y: 0, width: 0, height: afterImageView.frame.height))
        reverseAnimation.duration = backwardSpeed
        reverseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        reverseAnimation.fillMode = .forwards
        reverseAnimation.isRemovedOnCompletion = false
        reverseAnimation.delegate = self
        reverseAnimation.setValue("backwardAnimation", forKey: "id")

        maskLayer.add(reverseAnimation, forKey: "reverseMaskAnimation")

        let reverseBorderAnimation = CABasicAnimation(keyPath: "position.x")
        reverseBorderAnimation.fromValue = afterImageView.frame.width - borderLayer.frame.width / 2
        reverseBorderAnimation.toValue = 0 - borderLayer.frame.width / 2 // Sola doğru kaydır
        reverseBorderAnimation.duration = backwardSpeed // Mask animasyonuyla aynı süre
        reverseBorderAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        reverseBorderAnimation.fillMode = .forwards
        reverseBorderAnimation.isRemovedOnCompletion = false

        borderLayer.add(reverseBorderAnimation, forKey: "borderAnimation")
    }
}

extension SwiftImageTransitionFXView: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let animationID = anim.value(forKey: "id") as? String else { return }
        switch animationID {
        case "forwardAnimation":
            if enableReturnBackAfterForward {
                backwardAnimation()
            }
        case "backwardAnimation":
            if isInfinityLoop {
                DispatchQueue.main.asyncAfter(deadline: .now() + loopWaitTime, execute: {
                    self.forwardAnimation()
                })
            }
        default:
            break
        }
    }
}
