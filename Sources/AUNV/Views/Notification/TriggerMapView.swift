//
//  TriggerMapView.swift
//
//  Created by Vitaly Berg on 11/18/21.
//  Copyright © 2021 Vitaly Berg. All rights reserved.
//

import UIKit
import MapKit

class TriggerMapView: UIView, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    var region: CLCircularRegion? {
        didSet {
            if let region = region {
                let mapRegion = MKCoordinateRegion(center: region.center, latitudinalMeters: region.radius * 4, longitudinalMeters: region.radius * 4)
                mapView.setRegion(mapRegion, animated: false)
                
                if let overlay = overlay {
                    mapView.removeOverlay(overlay)
                }
                let overlay = MKCircle(center: region.center, radius: region.radius)
                mapView.addOverlay(overlay)
                self.overlay = overlay
            }
        }
    }
    
    private var overlay: MKOverlay!
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.strokeColor = #colorLiteral(red: 0.02745098039, green: 0.1568627451, blue: 0.937254902, alpha: 1)
            renderer.lineWidth = 1
            renderer.fillColor = #colorLiteral(red: 0.02745098039, green: 0.1568627451, blue: 0.937254902, alpha: 0.1)
            return renderer
        }
        
        return MKOverlayRenderer(overlay: overlay)
    }
    
    // MARK: - UIView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 9
        if #available(iOS 13.0, *) {
            layer.cornerCurve = .continuous
        }
    }
}
