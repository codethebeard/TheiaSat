//
//  ViewController.swift
//  TheiaSat
//
//  Created by Michael VanDyke on 6/1/19.
//  Copyright © 2019 Michael VanDyke. All rights reserved.
//

import UIKit
import ZeitSatTrack
import MapKit

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    private let tracker = ZeitSatTrackManager.sharedInstance
    private var satellites: [Satellite] = []
    private var currentSatellite: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tracker.delegate = self
        tracker.updateInterval = 5
        
        mapView.delegate = self
        mapView.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(Satellite.self))

        if let error = tracker.loadSatelliteSubGroup(subgroupName: "NOAA", group: "Weather & Earth Resources Satellites") {
            print(error.localizedDescription)
        }
        
        addSatellite(named: "NOAA 19 [+]")
        addSatellite(named: "NOAA 20 [+]")
        addSatellite(named: "NOAA 16 [-]")
    }
    
    @discardableResult
    private func addSatellite(named: String) -> Bool {
        let satellite = Satellite(name: named, coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), altitude: 0)
        if tracker.startObservingSatelliteNamed(named) {
            print("Successfully tracking \(named)")
            satellites.append(satellite)
            mapView.addAnnotation(satellites[satellites.count - 1])
            return true
        } else {
            print("Did not successfully add satellite")
            return false
        }
    }
    
    private func updatePositionForSatellite(name: String, position: CLLocationCoordinate2D) {
        guard let index = satellites.firstIndex(where: { $0.name == name }) else { return }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        
        mapView.removeAnnotation(satellites[index])
        satellites[index].coordinate = position
        mapView.addAnnotation(satellites[index])
        print("\(formatter.string(from: Date())) - Updating position for \(satellites[index].name)")
    }
}

extension ViewController: ZeitSatTrackManagerDelegate {
    
    func didObserveSatellites(satelliteList: Dictionary<String, GeoCoordinates>) {
        satelliteList.forEach { (key: String, value: GeoCoordinates) in
            let coordinate = CLLocationCoordinate2D(latitude: value.latitude, longitude: value.longitude)
            updatePositionForSatellite(name: key, position: coordinate)
        }
    }
    
    func didRemoveObservedSatellitesNamed(_ names: [String]) {
        //
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKAnnotationView?
        
        if annotation is MKUserLocation {
            return nil
        }
        
        if let satAnnotation = annotation as? Satellite {
            annotationView = MKAnnotationView(annotation: satAnnotation, reuseIdentifier: "\(NSStringFromClass(Satellite.self))AnnotationView")
            annotationView?.image = UIImage(named: "satellite-icon")
            annotationView?.canShowCallout = false
            let textView = UITextView(frame: CGRect(x: -20, y: 40, width: 80, height: 40))
            textView.text = "\(satAnnotation.name)"
            textView.textAlignment = .center
            textView.backgroundColor = UIColor.clear
            textView.textColor = UIColor.white
            annotationView?.addSubview(textView)
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? Satellite {
            currentSatellite = annotation.name
            performSegue(withIdentifier: "satDetailsSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "satDetailsSegue" {
            let vc = segue.destination as! SatelliteDetailsViewController
            vc.currentSatellite = currentSatellite
        }
    }
    
}
