//
//  GradientView.swift
//  iCodeSchool
//
//  Created by Hy99ee on 28.11.2021.
//
import UIKit
import Foundation


@IBDesignable class GradientView: UIControl {
    private var gradient: CAGradientLayer?
    @IBInspectable var startColor: UIColor?
    @IBInspectable var endColor: UIColor?
    @IBInspectable var angle: CGFloat = 270
    var newColors: [Any]?
    
    override var frame: CGRect{
        didSet{
            updateGradient()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        installGradient()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        installGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradient()
    }
    
    convenience init(frame: CGRect = UIScreen.main.bounds, isBackground:Bool = true) {
        self.init(frame: frame)
        if isBackground {setBackgroundColors()}
    }
    
    convenience init(frame: CGRect,
                     startColor:UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
                     endColor:UIColor = #colorLiteral(red: 0.8185399771, green: 0.8440650702, blue: 0.9524556994, alpha: 1),
                     angle: CGFloat = 270) {
        self.init(frame: frame)
        self.startColor = startColor
        self.endColor = endColor
        self.angle = angle
    }
    
    private func createGradient() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        return gradient
    }
    
    private func installGradient(){
        if let gradient = self.gradient {
            gradient.removeFromSuperlayer()
        }
        let gradient = createGradient()
        self.layer.addSublayer(gradient)
        self.gradient = gradient
    }
    
    private func updateGradient(){
        guard let gradient = self.gradient else {return}
        let startColor = self.startColor ?? UIColor.clear
        let endColor = self.endColor ?? UIColor.clear
        gradient.colors = newColors != nil ? newColors : [startColor.cgColor, endColor.cgColor]
        let (start, end) = gradientPointsForAngle(self.angle)
        gradient.startPoint = start
        gradient.endPoint = end
        gradient.frame = self.bounds
    }
    
    
    private func gradientPointsForAngle(_ angle: CGFloat) -> (CGPoint, CGPoint) {
        // get vector start and end points
        let end = pointForAngle(angle)
        let start = oppositePoint(end)
        // convert to gradient space
        let p0 = transformToGradientSpace(start)
        let p1 = transformToGradientSpace(end)
        return (p0, p1)
    }
    
    private func oppositePoint(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: -point.x, y: -point.y)
    }
    
    private func pointForAngle(_ angle: CGFloat) -> CGPoint {
        // convert degrees to radians
        let radians = angle * .pi / 180.0
        var x = cos(radians)
        var y = sin(radians)
        // (x,y) is in terms unit circle. Extrapolate to unit square to get full vector length
        if (abs(x) > abs(y)) {
            // extrapolate x to unit length
            x = x > 0 ? 1 : -1
            y = x * tan(radians)
        } else {
            // extrapolate y to unit length
            y = y > 0 ? 1 : -1
            x = y / tan(radians)
        }
        return CGPoint(x: x, y: y)
    }
    private func transformToGradientSpace(_ point: CGPoint) -> CGPoint {
        // input point is in signed unit space: (-1,-1) to (1,1)
        // convert to gradient space: (0,0) to (1,1), with flipped Y axis
        return CGPoint(x: (point.x + 1) * 0.5, y: 1.0 - (point.y + 1) * 0.5)
    }
    
    private func setBackgroundColors(){
        startColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        endColor = #colorLiteral(red: 0.7058312297, green: 0.7157550454, blue: 0.9302562475, alpha: 1)
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        installGradient()
        updateGradient()
    }
}
