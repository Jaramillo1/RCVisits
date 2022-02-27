//
//  CheckMyDistanceRepresentable.swift
//
//
//  Created by Ernesto Jaramillo on 2/26/22.
//

import SwiftUI
import UIKit
import NearbyInteraction


struct CheckMyDistanceRepresentable: UIViewControllerRepresentable {
    
    class Coordinator: NSObject, NBViewControllerDelegate {

        var parent: CheckMyDistanceRepresentable
        
        init(_ parent:CheckMyDistanceRepresentable) {
            self.parent = parent
        }
        
        
        func closeView(nearBy: NBViewController, results: String) {
           // <#code#>
        }
        
        var window: UIWindow?

        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            if !NISession.isSupported {
                print("unsupported device")
                // Ensure that the device supports NearbyInteraction and present
                //  an error message view controller, if not.
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "unsupportedDeviceMessage")
            }
            print("supported device")
            return true
        }

    } // class Coordinator
    
    typealias UIViewControllerType = NBViewController

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> NBViewController {

  
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "NBStoryBoard")
        return controller as! NBViewController
        
     

        
    }
    
    func updateUIViewController(_ uiViewController: NBViewController, context: Context) {
        //code
      
    }
    
    

    
    
}


