//
//  ProgressView.swift
//  AudioLibrary
//
//  Created by Arul on 24/03/23.
//

import Foundation
import UIKit

final class ProgressView: UIView {
  private let progressView: UIView = .init(frame: .zero)
  private var progressLayer: CAShapeLayer?
  private lazy var animation: CABasicAnimation = .init(keyPath: "strokeEnd")
  
  init() {
    super.init(frame: .zero)
    layoutViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func layoutViews() {
    addSubview(progressView)
    progressView.alignEdges()
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    let path = UIBezierPath(arcCenter: .init(x: bounds.midX, y: bounds.midY), radius: 12, startAngle: -(CGFloat.pi / 2), endAngle: CGFloat(Double.pi * 2), clockwise: true)
    
    let slotLayer: CAShapeLayer = .init()
    slotLayer.strokeColor = UIColor.white.cgColor
    slotLayer.fillColor = UIColor.clear.cgColor
    slotLayer.lineWidth = 3
    slotLayer.path = path.cgPath
    progressView.layer.addSublayer(slotLayer)
    
    let progressLayer: CAShapeLayer = .init()
    progressLayer.strokeColor = UIColor.red.cgColor
    progressLayer.lineWidth = 3
    progressLayer.lineCap = CAShapeLayerLineCap(rawValue: "round")
    progressLayer.path = path.cgPath
    progressLayer.fillColor = UIColor.clear.cgColor
    progressLayer.strokeEnd = .zero
    progressView.layer.addSublayer(progressLayer)
    self.progressLayer = progressLayer
  }
  
  func update(fraction: Float) {
    animation.fillMode = CAMediaTimingFillMode.forwards
    animation.fromValue = animation.toValue ?? 0
    animation.toValue = fraction
    animation.duration = 0.2
    animation.isRemovedOnCompletion = false
    progressLayer?.add(animation, forKey: "strokeEnd")
  }
}
