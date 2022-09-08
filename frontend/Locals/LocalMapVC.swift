//
//  LocalMapVC.swift
//  eventsProject
//
//  Created by Pietro Putelli on 15/07/18.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocalMapVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var getDirectionOnMapButton: UIButton!
    @IBOutlet weak var getDirectionOnMapButtonOutlet: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var geoCoder = CLGeocoder()
    var address = String()
    var local_title = String()
    var latitude = CLLocationDegrees()
    var longitude = CLLocationDegrees()
    
    var currentTheme: Themes! = nil
    var themes = Themes.setArrayThemes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.cornerRadius = view.frame.width / 64
        
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.init(name: "Accuratist", size: 16) as Any],for: .normal)
        getDirectionOnMapButtonOutlet.layer.cornerRadius = getDirectionOnMapButtonOutlet.frame.width / 16
        mapView.delegate = self
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            
            guard let placemarks = placemarks, let location = placemarks.first?.location else {
                print(error!.localizedDescription)
                return
            }
            
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
            
            let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
            let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
            self.mapView.setRegion(region, animated: true)
            self.mapView.showsUserLocation = false
            
            let marker = MKPointAnnotation()
            marker.coordinate = location.coordinate
            
            self.mapView.addAnnotation(marker)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationReuseId = "Place"
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationReuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationReuseId)
        } else {
            anView?.annotation = annotation
        }
        anView!.image = #imageLiteral(resourceName: "mapMarker")
        anView?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        anView!.backgroundColor = .clear
        anView!.canShowCallout = false
        return anView
    }
    
    func openMapForPlace(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = local_title
        mapItem.openInMaps(launchOptions: options)
    }
    
    @IBAction func openInMap(_ sender: UIButton) {
        self.openMapForPlace(latitude: latitude, longitude: longitude)
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {if segmentedControl.selectedSegmentIndex == 0 {mapView.mapType = .standard} else {mapView.mapType = .satellite}}
    
    override func viewWillAppear(_ animated: Bool) {

        let themeIndex = UserDefaults.standard.value(forKey: "THEME_TYPE") as! Int
        currentTheme = themes[themeIndex]
        
        getDirectionOnMapButtonOutlet.backgroundColor = currentTheme.barColor
        getDirectionOnMapButton.setTitle(User.language.get_direction_map, for: .normal)
        getDirectionOnMapButton.sizeToFit()
    }
}
