//
//  TriggerMapView.swift
//
//  Created by Vitaly Berg on 11/18/21.
//  Copyright © 2021 Vitaly Berg. All rights reserved.
//

import UIKit
import MapKit

class TriggerMapView: UIView {
    @IBOutlet weak var mapView: MKMapView!
    
    var region: CLCircularRegion? {
        didSet {
            if let region = region {
                let mapRegion = MKCoordinateRegion(center: region.center, latitudinalMeters: region.radius * 4, longitudinalMeters: region.radius * 4)
                mapView.setRegion(mapRegion, animated: false)
            }
        }
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
