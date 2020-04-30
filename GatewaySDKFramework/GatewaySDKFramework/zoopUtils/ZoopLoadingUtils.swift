//
//  ZoopLoadingUtils.swift
//  GatewaySDK
//
//  Created by Divyank Vijayvergiya on 27/04/20.
//  Copyright © 2020 Zoop.one. All rights reserved.
//

import Foundation
import UIKit

class ZoopLoadingUtils {
    static var currentOverlay: UIView?
    static var currentOverlayTarget: UIView?
    static var currentLoadingText: String?
    
    static func show(){
        guard let currentMainWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {
            print("No main window.")
            return
        }
        
        show(currentMainWindow)
    }
    
    static func show(_ loadingText: String) {
           guard let currentMainWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {
               print("No main window.")
               return
           }
           show(currentMainWindow, loadingText: loadingText)
       }
       
       static func show(_ overlayTarget : UIView) {
           show(overlayTarget, loadingText: nil)
       }
    static func show(_ overlayTarget : UIView, loadingText: String?) {
            // Clear it first in case it was already shown
            hide()
            
            // register device orientation notification
    //        NotificationCenter.default.addObserver(
    //            self, selector:
    //            #selector(QtLoadingUtils.rotated),
    //
    //            name: Notification.init(name: UIDevice.orientationDidChangeNotification),
    //            object: nil)

            
            // register device orientation notification
            NotificationCenter.default.addObserver(
                self, selector:
                #selector(ZoopLoadingUtils.rotated),
                name: UIDevice.orientationDidChangeNotification,
                object: nil)

            //            name: NSNotification.Name.UIDevice.orientationDidChangeNotification,

            
            // Create the overlay
            let overlay = UIView(frame: overlayTarget.frame)
            overlay.center = overlayTarget.center
            overlay.alpha = 0
            overlay.backgroundColor = UIColor.black
            overlayTarget.addSubview(overlay)
            overlayTarget.bringSubviewToFront(overlay)
            
            // Create and animate the activity indicator
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
            indicator.center = overlay.center
            indicator.startAnimating()
            overlay.addSubview(indicator)
            
            // Create label
            if let textString = loadingText {
                let label = UILabel()
                label.text = textString
                label.textColor = UIColor.white
                label.sizeToFit()
                label.center = CGPoint(x: indicator.center.x, y: indicator.center.y + 30)
                overlay.addSubview(label)
            }
            
            // Animate the overlay to show
//            UIView.beginAnimations(nil, context: nil)
//            UIView.setAnimationDuration(0.5)
//            UIView.commitAnimations()
        UIView.animate(withDuration: 0.5, animations: {
            overlay.alpha = overlay.alpha > 0 ? 0 : 0.5
        }, completion: nil)
            
            currentOverlay = overlay
            currentOverlayTarget = overlayTarget
            currentLoadingText = loadingText
    }
        
        static func hide() {
            if currentOverlay != nil {
                
                // unregister device orientation notification
                NotificationCenter.default.removeObserver(self,name: UIDevice.orientationDidChangeNotification,                                           object: nil)
                
                currentOverlay?.removeFromSuperview()
                currentOverlay =  nil
                currentLoadingText = nil
                currentOverlayTarget = nil
            }
        }
        
        @objc private static func rotated() {
            // handle device orientation change by reactivating the loading indicator
            if currentOverlay != nil {
                show(currentOverlayTarget!, loadingText: currentLoadingText)
            }
        }
}
