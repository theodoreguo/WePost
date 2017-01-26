//
//  QRCodeCardViewController.swift
//  TGWeibo
//
//  Created by Theodore Guo on 26/1/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit

class QRCodeCardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1. Set title
        navigationItem.title = "My Card"
        
        // 2. Add image container
        view.addSubview(iconView)
        
        // 3. Layout image container
        iconView.tg_AlignInner(type: TG_AlignType.Center, referView: view, size: CGSize(width: 200, height: 200))
        
        // 4. Generate QR code
        let qrCodeImage = createQRCodeImage()
        
        // 5. Add QR code to picture container
        iconView.image = qrCodeImage
    }
    
    /**
     Create QR code image
     */
    private func createQRCodeImage() -> UIImage {
        // 1. Create filter
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        // 2. Restore filter default setting
        filter?.setDefaults()
        
        // 3. Set data required to generate QR code
        filter?.setValue("Theodore_Guo".dataUsingEncoding(NSUTF8StringEncoding), forKey: "inputMessage")
        
        // 4. Get generated image from filter
        let ciImage = filter?.outputImage
        let bgImage = createNonInterpolatedUIImageFormCIImage(ciImage!, size: 300)
        
        // 5. Create profile (QR code + profile)
        let icon = UIImage(named: "Naruto")

        // 6. Compound image
        let newImage = createImage(bgImage, iconImage: icon!)
        
        // 7. Return generated QR code
        return newImage
    }
    
    /**
     Compound image
     */
    private func createImage(bgImage: UIImage, iconImage: UIImage) -> UIImage {
        // 1. Begin image context
        UIGraphicsBeginImageContext(bgImage.size)
        
        // 2. Draw background image
        bgImage.drawInRect(CGRect(origin: CGPointZero, size: bgImage.size))
        
        // 3. Draw profile
        let width: CGFloat = 50
        let height: CGFloat = width
        let x = (bgImage.size.width - width) * 0.5
        let y = (bgImage.size.height - height) * 0.5
        iconImage.drawInRect(CGRect(x: x, y: y, width: width, height: height))
        
        // 4. Get drawn image
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 5. Close image context
        UIGraphicsEndImageContext()
        
        // 6. Return compounded image
        return newImage
    }

    /**
     Generate target UIImage based on CIImage
     
     - parameter image: designated CIImage
     - parameter size:  designated size
     
     - returns: QR code image generated
     */
    private func createNonInterpolatedUIImageFormCIImage(image: CIImage, size: CGFloat) -> UIImage {
        let extent: CGRect = CGRectIntegral(image.extent)
        let scale: CGFloat = min(size / CGRectGetWidth(extent), size / CGRectGetHeight(extent))
        
        // 1. Create bitmap
        let width = CGRectGetWidth(extent) * scale
        let height = CGRectGetHeight(extent) * scale
        let cs: CGColorSpaceRef = CGColorSpaceCreateDeviceGray()!
        let bitmapRef = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, cs, 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImageRef = context.createCGImage(image, fromRect: extent)
        
        CGContextSetInterpolationQuality(bitmapRef,  CGInterpolationQuality.None)
        CGContextScaleCTM(bitmapRef, scale, scale)
        CGContextDrawImage(bitmapRef, extent, bitmapImage)
        
        // 2. Save bitmap
        let scaledImage: CGImageRef = CGBitmapContextCreateImage(bitmapRef)!
        
        return UIImage(CGImage: scaledImage)
    }
    
    // MARK: - Lazy loading
    private lazy var iconView = UIImageView()
}
