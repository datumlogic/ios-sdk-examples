//
//  UserLocationAnnotationExample.swift
//  Examples
//
//  Created by Qian Gao on 12/14/16.
//  Copyright © 2016 Mapbox. All rights reserved.
//

import Mapbox

@objc(UserLocationAnnotationExample_Swift)

// Example view controller
class UserLocationAnnotationExample_Swift: UIViewController, MGLMapViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        
        // Enable heading tracking mode so that the arrow will appear.
        mapView.userTrackingMode = .followWithHeading
        
        view.addSubview(mapView)
    }
    
    // MARK: - MGLMapViewDelegate methods
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        // This is how we substitute a custom view for the user location annotation.
        if annotation is MGLUserLocation && mapView.userLocation != nil {
            return CustomUserLocationAnnotationView()
        }
        
        return nil
    }
}

//
// MGLUserLocationAnnotationView subclass
class CustomUserLocationAnnotationView: MGLUserLocationAnnotationView {
    let size: CGFloat = 25
    var arrowSize: CGFloat!
    
    var dot: CALayer!
    var arrow: CAShapeLayer!
    
    override func update() {
        if frame.isNull {
            frame = CGRect(x: 0, y: 0, width: size, height: size)
            return setNeedsLayout()
        }
        
        // This method can be called many times a second, so be careful to keep it lightweight.
        if CLLocationCoordinate2DIsValid(self.userLocation!.coordinate) {
            setupLayers()
            updateHeading()
        }
    }
    
    private func updateHeading() {
        // Show the heading arrow, if we’re able to.
        if let heading = userLocation!.heading, mapView?.userTrackingMode == .followWithHeading {
            arrow.isHidden = false
            
            // Rotate the arrow according to the user’s heading.
            let rotation = CGAffineTransform.identity.rotated(
                by: -MGLRadiansFromDegrees(mapView!.direction - heading.trueHeading))
            layer.setAffineTransform(rotation)
        } else {
            arrow.isHidden = true
        }
    }
    
    private func setupLayers() {
        setupDot()
        setupArrow()
    }
    
    private func setupDot() {
        if dot == nil {
            dot = CALayer()
            dot.bounds = CGRect(x: 0, y: 0, width: size, height: size)
            dot.position = CGPoint(x: size / 2, y: size / 2)
            
            // Use CALayer’s corner radius to turn this layer into a circle.
            dot.cornerRadius = size / 2
            dot.backgroundColor = super.tintColor.cgColor
            dot.borderWidth = 2
            dot.borderColor = UIColor.white.cgColor
            dot.shadowColor = UIColor.black.cgColor
            dot.shadowOffset = CGSize(width: 0, height: 0)
            
            layer.addSublayer(dot)
        }
    }
    
    private func setupArrow() {
        if arrow == nil {
            arrowSize = size / 2.5
            
            arrow = CAShapeLayer()
            arrow.path = arrowPath()
            
            arrow.bounds = CGRect(x: 0, y: 0, width: arrowSize, height: arrowSize)
            arrow.position = CGPoint(x: size / 2, y: -5)
            
            arrow.fillColor = super.tintColor.cgColor
            
            arrow.borderColor = UIColor(white: 0, alpha: 0.25).cgColor
            arrow.borderWidth = 1
            
            layer.addSublayer(arrow)
        }
    }
    
    private func arrowPath() -> CGPath {
        let max: CGFloat = arrowSize
        
        let top = CGPoint(x: max * 0.5, y: max * 0.4)
        let left = CGPoint(x: 0, y: max)
        let right = CGPoint(x: max, y: max)
        let center = CGPoint(x: max * 0.5, y: max * 0.8)
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: top)
        bezierPath.addLine(to: left)
        bezierPath.addQuadCurve(to: right, controlPoint: center)
        bezierPath.addLine(to: top)
        bezierPath.close()
        
        return bezierPath.cgPath
    }
}
