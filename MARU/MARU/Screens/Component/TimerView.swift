//
//  TimerView.swift
//  MARU
//
//  Created by psychehose on 2021/08/26.
//

import UIKit

protocol Timeout: AnyObject {
  func timeout()
}

final class TimerView: UIView {
  private let shapeLayer = CAShapeLayer()
  private let timeLeftShapeLayer = CAShapeLayer()
  private var countdownTimer: Timer?
  private let timerLabel = UILabel()
  private var remainTime = 0
  weak var delegate: Timeout?

  override init(frame: CGRect) {
    super.init(frame: frame)
    createLabel()
    backgroundColor = .white
    drawShapeLayer()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
extension TimerView {
  private func drawShapeLayer() {
    shapeLayer.path = UIBezierPath(
      arcCenter: CGPoint(x: frame.minX + 15, y: frame.minY + 15),
      radius: 15,
      startAngle: -90.radians,
      endAngle: 270.radians,
      clockwise: true
    ).cgPath
    shapeLayer.strokeColor = UIColor.white.cgColor
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.lineWidth = 3
    layer.addSublayer(shapeLayer)

    timeLeftShapeLayer.path = UIBezierPath(
      arcCenter: CGPoint(x: frame.minX + 15, y: frame.minY + 15),
      radius: 15,
      startAngle: -90.radians,
      endAngle: 270.radians,
      clockwise: true
    ).cgPath
    timeLeftShapeLayer.strokeColor = UIColor.blue.cgColor
    timeLeftShapeLayer.fillColor = UIColor.clear.cgColor
    timeLeftShapeLayer.lineWidth = 3
    layer.addSublayer(timeLeftShapeLayer)
  }
  private func createLabel() {
    timerLabel.textAlignment = .center
    timerLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
    timerLabel.translatesAutoresizingMaskIntoConstraints = false

    addSubview(timerLabel)
    timerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    timerLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    timerLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    timerLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
  }
  private func startAnimation() {
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    animation.fromValue = 0
    animation.toValue = 1
    animation.duration = Double(remainTime)
    animation.fillMode = CAMediaTimingFillMode.forwards
    animation.isRemovedOnCompletion = false
    timeLeftShapeLayer.add(animation, forKey: nil)
  }
  func setupTimer(time: Int) {
    timerLabel.text = time.string
    remainTime = time
  }
  func startClockTimer() {
    countdownTimer = Timer.scheduledTimer(
      timeInterval: 1,
      target: self,
      selector: #selector(countdown),
      userInfo: nil,
      repeats: true
    )
    startAnimation()
  }
  @objc
  private func countdown() {

    if remainTime > 0 {
      remainTime -= 1
      timerLabel.text = String(remainTime)
    } else {
      // Timeout
      print("Timeout")
      timerLabel.text = 0.string
      timeout()
      removeCountdown()
    }
  }
  func removeCountdown() {
    countdownTimer?.invalidate()
    countdownTimer = nil
  }
}
extension TimerView: Timeout {
  func timeout() {
    delegate?.timeout()
  }
}
