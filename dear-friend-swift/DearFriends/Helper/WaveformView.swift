//
//  WaveformView.swift
//  Dear Friends
//
//  Created by DEEPAK JAIN on 01/08/25.
//

import UIKit

class WaveformView: UIView {

    var amplitudes: [CGFloat] = []
    var progress: CGFloat = 0.0 {
        didSet { setNeedsDisplay() }
    }

    var barWidth: CGFloat = 3
    var spacing: CGFloat = 2
    var filledStartColor: UIColor = .systemBlue
    var filledEndColor: UIColor = .systemPurple
    var unfilledColor: UIColor = UIColor.gray.withAlphaComponent(0.3)

    var onProgressChanged: ((CGFloat) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGesture()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGesture()
    }

    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(tapGesture)
        addGestureRecognizer(panGesture)
    }

    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        updateProgress(at: location.x)
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self)
        updateProgress(at: location.x)
    }

    private func updateProgress(at x: CGFloat) {
        let clampedX = max(0, min(x, bounds.width))
        let newProgress = clampedX / bounds.width
        self.progress = newProgress
        onProgressChanged?(newProgress)
    }
   
    override func draw(_ rect: CGRect) {
        guard !amplitudes.isEmpty else { return }

        print("Redrawing at progress:", progress)

        
        let context = UIGraphicsGetCurrentContext()
        context?.clear(rect)

        let maxHeight = rect.height
        let totalBars = min(Int(rect.width / (barWidth + spacing)), amplitudes.count)
        let visibleAmplitudes = Array(amplitudes.prefix(totalBars))
        let filledBars = Int(CGFloat(totalBars) * progress)

        for (index, amplitude) in visibleAmplitudes.enumerated() {
            let x = CGFloat(index) * (barWidth + spacing)
            let barHeight = amplitude * maxHeight

            // ✅ Bars start at bottom and grow up
            let y = rect.height - barHeight

            let barRect = CGRect(x: x, y: y, width: barWidth, height: barHeight)
            //let unfilledColor: UIColor = UIColor.gray.withAlphaComponent(0.3)

            let isFilled = index < filledBars
//            let fillColor = isFilled ? gradientColor(at: CGFloat(index) / CGFloat(totalBars)).cgColor : unfilledColor.cgColor
            let fillColor = isFilled ? hexStringToUIColor(hex: "7A7AFC").cgColor : hexStringToUIColor(hex: "B2B1B").cgColor

            context?.setFillColor(fillColor)
            context?.fill(barRect)
        }
    }

    private func gradientColor(at progress: CGFloat) -> UIColor {
        var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)

        filledStartColor.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        filledEndColor.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        return UIColor(
            red: r1 + (r2 - r1) * progress,
            green: g1 + (g2 - g1) * progress,
            blue: b1 + (b2 - b1) * progress,
            alpha: a1 + (a2 - a1) * progress
        )
    }
}



