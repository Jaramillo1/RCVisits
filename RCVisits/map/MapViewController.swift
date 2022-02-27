//
//  ViewController.swift
//  Measure
//
//  Created by levantAJ on 8/9/17. 
//  Copyright © 2017 levantAJ. All rights reserved.    
//

import UIKit
import MapKit
import CoreLocation


struct SiteMap: Codable {
    let image: String
    let coordinates: [SiteCoordinate]
}
struct SiteCoordinate: Codable {
    let lat: String
    let long: String
}

@objc protocol MapViewControllerDelegate: class {
    

    func closeView(map:MapViewController  ,results: String )
 
}
 

final class MapViewController: UIViewController {

    let kDefault_latitude: CLLocationDegrees = 37.484557
    let kDefault_longitude: CLLocationDegrees = 126.896367
    var _snapShotOptions: MKMapSnapshotter.Options = MKMapSnapshotter.Options()
    var _snapShot: MKMapSnapshotter!
    var kDefault_height: CGFloat! = 50.0
    var center: CLLocationCoordinate2D!
    var currentLoc: CLLocation!
    var mySpan: MKCoordinateSpan!
    var myRegion: MKCoordinateRegion!
    var snapshotString:String = ""
    var lastAnnotation:MKPointAnnotation!
    var done:Bool = false
    var locations:Array<CLLocationCoordinate2D> = []
    var locationString:String = ""
     // Generate MKMapView
       lazy var _mapView: MKMapView = {
           let mv = MKMapView(frame: self.view.frame)
        mv.autoresizesSubviews = true
        mv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mv.delegate = self as MKMapViewDelegate
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: "handleLongPress:");
           mv.addGestureRecognizer(longPressRecogniser)
           
           return mv
       }()
       
       // Generate CLLocationManager
     lazy var _locationManager: CLLocationManager = {
         let lm = CLLocationManager()
         
        lm.delegate = self as? CLLocationManagerDelegate
         // Distance filter.
         lm.distanceFilter = 100.0
         // accuracy.
         lm.desiredAccuracy = kCLLocationAccuracyHundredMeters
         
         return lm
     }()

  
 
    
    // Generate button
    lazy var _button: UIButton = {
        let b = UIButton(frame: CGRect(x: 0, y: kDefault_height, width: 100, height: 20))
        b.layer.position = CGPoint(x: self.view.frame.width/2, y: 50) //self.view.frame.height-100)
        b.layer.cornerRadius = 3.0
        b.backgroundColor = UIColor.red
 
       // b.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        b.setTitle("Snapshot", for: .normal)
        b.setTitleColor(UIColor.white, for: .normal)
        b.addTarget(self, action: #selector(onClickButton(_:)), for: .touchUpInside)
        
        return b
    }()
     
    // Generate close button
    lazy var _closebutton: UIButton = {
        let b = UIButton(frame: CGRect(x: 0, y: kDefault_height, width: 70, height: 20))
        b.layer.position = CGPoint(x: 30,y:50)
                                   //y:self.view.frame.height-100)
        b.layer.cornerRadius = 3.0
        b.backgroundColor = UIColor.red
       // b.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        b.setTitle("Close", for: .normal)
        b.setTitleColor(UIColor.white, for: .normal)
        b.addTarget(self, action: #selector(onClickCloseButton(_:)), for: .touchUpInside)
        
        return b
    }()
    
    // Generate undo button
    lazy var _undobutton: UIButton = {
        let b = UIButton(frame: CGRect(x: 0, y: kDefault_height, width: 50, height: 20))
        b.layer.position = CGPoint(x: self.view.frame.width-30, y:50)
        b.layer.cornerRadius = 3.0
        b.backgroundColor = UIColor.red
       // b.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        b.setTitle("Undo", for: .normal)
        b.setTitleColor(UIColor.white, for: .normal)
        b.addTarget(self, action: #selector(onClickUndoButton(_:)), for: .touchUpInside)
        
        return b
    }()
     
    func getSnapShot() -> String {
         
          
        return snapshotString + "||" +  self.locationString;
       }
      
    
     // Delegate
     var delegate: MapViewControllerDelegate?
    
   
    
    init(componentName: String) {
         super.init(nibName: nil, bundle: nil)
         self.navigationItem.title = componentName
     }

     
    required init?(coder aDecoder: NSCoder) {
         fatalError("We aren't using storyboards")
     }
 
 
     override func viewDidLoad() {
         super.viewDidLoad()
         
        
   
          self.view.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
         // Do any additional setup after loading the view.
         

         // Add mapView on view
         self.view.addSubview(_mapView)
        
        // Add button on view
        self.view.addSubview(_button)
        
        // Add button on view
        self.view.addSubview(_closebutton)
         
        
        // Add button on view
        self.view.addSubview(_undobutton)
        
        // Obtain the status of security authentication.
        let status = CLLocationManager.authorizationStatus()
        
        // If authentication has not been obtained yet, an authentication dialog is displayed.
        if(status != CLAuthorizationStatus.authorizedWhenInUse) {
            print("not determined")
            // If the approval has not been obtained yet, an authentication dialog is displayed.
            _locationManager.requestWhenInUseAuthorization()
        }
        currentLoc = _locationManager.location
        
         if currentLoc == nil {
            print ("location not ready yet")
            return
         }
         
         // latitude and longitude of the center point.
        let myCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(currentLoc.coordinate.latitude, currentLoc.coordinate.longitude)
         
         // Scale.
         let myLatDist : CLLocationDistance = 100
         let myLonDist : CLLocationDistance = 100
         
         // Create Region.
        let myRegion: MKCoordinateRegion = MKCoordinateRegion(center: myCoordinate, latitudinalMeters: myLatDist, longitudinalMeters: myLonDist);
        
        // MKMapSnapShotOptions setting.
        _snapShotOptions.region = myRegion
        _snapShotOptions.size = _mapView.frame.size
        _snapShotOptions.scale = UIScreen.main.scale
        
        // Set MKMapSnapShotOptions to MKMapSnapShotter.
        _snapShot = MKMapSnapshotter(options: _snapShotOptions)
         
         // Reflected in MapView.
         _mapView.setRegion(myRegion, animated: true)
        _mapView.mapType = MKMapType.hybrid
        _mapView.isZoomEnabled = true
        _mapView.isScrollEnabled = true

     }
    
 
     

     
  
   
       override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           // Dispose of any resources that can be recreated.
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // session.pause()
    }
    
    @objc private func onClickUndoButton(_ sender: UIButton) {
    
    
        let last = _mapView.annotations.endIndex
        var count = 0
        for anno in _mapView.annotations{
            count = count + 1
            if(count == last){
                 _mapView.removeAnnotation(anno)
            }
          
        }
         
        let loc_count = self.locations.endIndex - 1
        self.locations.remove(at: loc_count )
      
   
     

       }
    
    @objc private func onClickCloseButton(_ sender: UIButton) {
        
        
        self.delegate?.closeView(map: self,results: snapshotString);

       }
    
    @objc func handleLongPress(_ gestureRecognizer : UIGestureRecognizer){
        if gestureRecognizer.state != .began { return }
        done = false
        let touchPoint = gestureRecognizer.location(in: _mapView)
      
        let touchMapCoordinate:CLLocationCoordinate2D  = _mapView.convert(touchPoint, toCoordinateFrom: _mapView)
 
       
        let annotation = MKPointAnnotation();
                   annotation.coordinate = touchMapCoordinate
                           _mapView.addAnnotation(annotation);
        locations.append( touchMapCoordinate)
        
       

    }
    
  
    
    @objc private func onClickButton(_ sender: UIButton) {
        // Cancel if there is a running snapshot.
        _snapShot.cancel()
         
        let newCenter = _mapView.centerCoordinate
        
        
        // Scale.
         let latDist : CLLocationDistance = 100
         let lonDist : CLLocationDistance = 100
         
         // Create Region.
        let newRegion: MKCoordinateRegion = MKCoordinateRegion(center: newCenter, latitudinalMeters: latDist, longitudinalMeters: lonDist);
        
        // MKMapSnapShotOptions setting.
           _snapShotOptions.region = newRegion
            _snapShotOptions.mapType = _mapView.mapType
           _snapShotOptions.size = _mapView.frame.size
           _snapShotOptions.scale = UIScreen.main.scale
           
           // Set MKMapSnapShotOptions to MKMapSnapShotter.
           _snapShot = MKMapSnapshotter(options: _snapShotOptions)
        
        // Generate UIImageView.
        
        let myImageView: UIImageView = UIImageView(frame: CGRect(x: self.view.center.x - 250, y: self.view.center.y - 180, width: 250, height: 180))
        
        // Maintain the aspect ratio of the image.
        myImageView.contentMode = UIView.ContentMode.scaleAspectFit
        
        // Set backgroundColor
        myImageView.backgroundColor = .white
        
        // Set borderLine
        myImageView.layer.masksToBounds = true
        myImageView.layer.borderWidth = 1.0
        myImageView.layer.borderColor = UIColor.red.cgColor
        
        
        // Take a snapshot.
        _snapShot.start { (snapshot, error) -> Void in
            if error == nil {
              
                myImageView.image = snapshot!.image
                
                // add back pins
                let image = snapshot?.image
                UIGraphicsBeginImageContextWithOptions((image?.size)!, true, (image?.scale)!)
                image?.draw(at: CGPoint(x: 0, y: 0))

                let context = UIGraphicsGetCurrentContext()
                context!.setStrokeColor(UIColor.orange.cgColor)
                context!.setFillColor(UIColor.yellow.cgColor)
                context!.setLineWidth(2.0)
                context!.beginPath()
                let locationsAnno = self.locations
                
                for (index, location) in locationsAnno.enumerated() {
                    let coordinates = CLLocationCoordinate2DMake(location.latitude, location.longitude)
                    self.locationString = self.locationString +
                        location.latitude.description + "," +
                        location.longitude.description + ";"
                    let point = snapshot?.point(for: coordinates)
                    // set stroking color and draw circle
                    context?.move(to: point!)

                    // make circle rect 5 px from border
                    var circleRect = CGRect(x: point!.x, y: point!.y, width: 20, height: 20)
                      // circleRect = circleRect.insetBy(dx: 5, dy: 5)

                    // draw circle
                    context!.strokeEllipse(in: circleRect)
                    context!.fillEllipse(in: circleRect)
                    
                    
                    /*
                    if index == 0 {
                        context?.move(to: point!)
                    } else {
                        context?.addLine(to:point!)
                    }
                    */
                }
                
               /* for location in locationsAnno {
                    //let coordinates = CLLocationCoordinate2DMake(location.latitude, location.longitude)
                    
                    let point = snapshot!.point(for: location)
                   
                    context?.addArc(center: point, radius: 5.0 ,startAngle: 0.0,endAngle: 3.14 * 2.0, clockwise: true)
                     
                                
                    
                   
                }
                */
                //context?.strokePath()
                let finalImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
               
                
                myImageView.image! = finalImage!
               
                let imageData = finalImage!.jpegData(compressionQuality: 0.75)
                self.snapshotString =   imageData!.base64EncodedString()
                //self.delegate?.closeView();
              
            } else {
                print("error")
            }
        }
        
        // Add UIImageView to view.
        self.view.addSubview(myImageView)
    }
     
}
extension MapViewController:MKMapViewDelegate, CLLocationManagerDelegate {
    
    // Method called when getting a value from GPS.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations")
        
        // Get the current coordinates from the array.
        let myLastLocation: CLLocation = locations.last!
        let myLocation: CLLocationCoordinate2D = myLastLocation.coordinate
        
        print("\(myLocation.latitude), \(myLocation.longitude)")
        
        // Scale.
        let myLatDist : CLLocationDistance = 100
        let myLonDist : CLLocationDistance = 100
        
        // Create Region.
        let myRegion: MKCoordinateRegion = MKCoordinateRegion(center: myLocation, latitudinalMeters: myLatDist, longitudinalMeters: myLonDist);
        
        // Reflected in MapView.
        _mapView.setRegion(myRegion, animated: true)
    }
    
    // Method called when the Region changes.
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("regionDidChangeAnimated")
    }
    
    // Method called when authentication changes.
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse: print("AuthorizedWhenInUse")
        case .authorized: print("Authorized")
        case .denied: print("Denied")
        case .restricted: print("Restricted")
        case .notDetermined: print("NotDetermined")
        case .authorizedAlways: print("authorizedAlways")
        }
    }
    
}

