//
//  QRCodeViewController.swift
//  TGWeibo
//
//  Created by Theodore Guo on 26/1/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController, UITabBarDelegate {
    /// Scanline constraints
    @IBOutlet weak var scanlineCons: NSLayoutConstraint!
    /// Container view height constraints
    @IBOutlet weak var containerHeightCons: NSLayoutConstraint!
    /// Scanline View
    @IBOutlet weak var scanlineView: UIImageView!
    /// Bottom tab bar
    @IBOutlet weak var customTabBar: UITabBar!
    
    /**
     Monitor close button click
     */
    @IBAction func closeBtnClick(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    /**
     Monitor my card button click
     */
    @IBAction func myCardBtnClick(sender: AnyObject) {
        let vc = QRCodeCardViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set tab bar's first item selected by default
        customTabBar.selectedItem = customTabBar.items![0]
        
        customTabBar.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Start scanline animation
        startAnimation()
        
        // Start scan
        startScan()
    }
    
    /**
     Execute code scanning
     */
    private func startScan() {
        // 1. Judge whether input device can be added to session
        if !session.canAddInput(deviceInput) {
            return
        }
        
        // 2. Judge whether output can be added to session
        if !session.canAddOutput(output) {
            return
        }
        
        // 3. Add both input and output to session
        session.addInput(deviceInput)
        session.addOutput(output)
        
        // 4. Set data types which can be parsed by output
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        // 5. Set output's delegate, and inform delegate once parsing successfully
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        
        // 6. Add preview layer
        view.layer.insertSublayer(previewLayer, atIndex: 0)
        
        // 7. Add drawLayer to preview layer
        previewLayer.addSublayer(drawLayer)
        
        // 8. Inform session to start scanning
        session.startRunning()
    }
    
    /**
     Execute animation
     */
    private func startAnimation() {
        // Make animation start from top by setting constraint
        self.scanlineCons.constant = -self.containerHeightCons.constant
        // Refresh view
        self.scanlineView.layoutIfNeeded()
        
        // Execute scanline animation
        UIView.animateWithDuration(2.0) {
            // Modify constraint
            self.scanlineCons.constant = self.containerHeightCons.constant
            // Set animation's repeated times
            UIView.setAnimationRepeatCount(MAXFLOAT)
            // Refresh view
            self.scanlineView.layoutIfNeeded()
        }
    }
    
    // MARK: - UITabBarDelegate
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        // Modify container's height
        if item.tag == 1 { // QR Code
            self.containerHeightCons.constant = 300
        } else { // Bar Code
            self.containerHeightCons.constant = 150
        }
        
        // Stop animation
        self.scanlineView.layer.removeAllAnimations()
        
        // Restart animation
        startAnimation()
    }
    
    // MARK: - Lazy loading
    /// Session
    private lazy var session: AVCaptureSession = AVCaptureSession()
    
    /// Get input object
    private lazy var deviceInput: AVCaptureDeviceInput? = {
        // Get camera
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do {
            // Create input object
            let input = try AVCaptureDeviceInput(device: device)
            return input
        } catch {
            print(error)
            return nil
        }
    }()
    
    /// Get output object
    private lazy var output: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    
    /// Create preview layer
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.session)
        layer.frame = UIScreen.mainScreen().bounds
        return layer
    }()
    
    /// Create layer to draw code's corners
    private lazy var drawLayer: CALayer = {
        let layer = CALayer()
        layer.frame = UIScreen.mainScreen().bounds
        return layer
    }()
}

extension QRCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        // 1. Clear layers
        clearCorners()
        
        // 2. Get scanned data
        print(metadataObjects.last?.stringValue)
        
        // 3. Get scanned QR code's position
        // 3.1 Transform coordinate
        for obj in metadataObjects {
            // 3.1.1 Judge that data acquired currently can be readable or not
            if obj is AVMetadataMachineReadableCodeObject {
                // 3.1.2 Transform coordinate to be the one that can be recognized by layer
                let codeObject = previewLayer.transformedMetadataObjectForMetadataObject(obj as! AVMetadataObject) as! AVMetadataMachineReadableCodeObject
                // 3.1.3 Draw corners
                drawCorners(codeObject)
            }
        }
    }
    
    /**
     Draw corners
     */
    private func drawCorners(codeObject: AVMetadataMachineReadableCodeObject) {
        if codeObject.corners.isEmpty {
            return
        }
        
        // 1. Create layer
        let layer = CAShapeLayer()
        layer.lineWidth = 4
        layer.strokeColor = UIColor.redColor().CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        
        // 2. Create path
        let path = UIBezierPath()
        var point = CGPointZero
        var index = 0
        // 2.1 Move to first point
        CGPointMakeWithDictionaryRepresentation((codeObject.corners[index] as! CFDictionary), &point)
        index += 1
        path.moveToPoint(point)
        // 2.2 Move to other points
        while index < codeObject.corners.count {
            CGPointMakeWithDictionaryRepresentation((codeObject.corners[index] as! CFDictionary), &point)
            index += 1
            path.addLineToPoint(point)
        }
        // 2.3 Close path
        path.closePath()
        // 2.4 Draw path
        layer.path = path.CGPath
        
        // 3. Add drawed layer to draw layer
        drawLayer.addSublayer(layer)
    }
    
    /**
     Clear remaining layer in drawLayer
     */
    private func clearCorners() {
        // 1. Judge whether other layers exist in draw layer
        if drawLayer.sublayers == nil || drawLayer.sublayers?.count == 0 {
            return
        }
        
        // 2. Remove all sublayers
        for subLayer in drawLayer.sublayers! {
            subLayer.removeFromSuperlayer()
        }
    }
}
