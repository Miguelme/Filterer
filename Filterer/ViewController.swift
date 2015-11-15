//
//  ViewController.swift
//  Filterer
//
//  Created by Miguel Fagundez on 11/13/15.
//  Copyright © 2015 Miguel Fagundez. All rights reserved.
//

import UIKit


// You need to conform to the two latter protocols to pick an image from camera
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: -  IBOutlets
    
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet var menuV: UIView!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var bottomMenu: UIView!
    
    // MARK: - Variables
    var filteredImage : UIImage?
    var originalImage : UIImage?
    
    // MARK: - View Controller Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Store original image
        originalImage = imageV.image

        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - IBActions
    @IBAction func newPhotoTapped(sender: UIButton) {
    
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            self.showCamera()
        }))
    
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler:{ action in
    
        } ))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    

    @IBAction func filterBtnTapped(sender: UIButton) {
        if sender.selected {
            removeSecondaryMenu()
            sender.selected = false
        }else{
            showSecondaryMenu()
            sender.selected = true
        }
    }
    
    @IBAction func shareTapped(sender: UIButton) {

        let activityCtrl = UIActivityViewController(activityItems: [imageV.image!], applicationActivities: nil)
        self.presentViewController(activityCtrl, animated: true, completion: nil)
    
    }
    
    
    // MARK: - Filters Applications
    @IBAction func firstFilterTapped(sender: UIButton) {
    
        let rgbImage = RGBAImage(image: originalImage!)!
        filteredImage = firstFilter(rgbImage)
        imageV.image = filteredImage
    }
    @IBAction func transparentFilterTapped(sender: UIButton) {
        let rgbImage = RGBAImage(image: originalImage!)!
        filteredImage = transparencyHigh(rgbImage)
        imageV.image = filteredImage
    }
    @IBAction func blackAndWhiteTapped(sender: UIButton) {
        let rgbImage = RGBAImage(image: originalImage!)!
        filteredImage =  blackAndWhiteFilter(rgbImage)
        imageV.image = filteredImage
    }
    @IBAction func highContrastTapped(sender: UIButton) {
        let rgbImage = RGBAImage(image: originalImage!)!
        filteredImage =  highContrast(rgbImage)
        imageV.image = filteredImage
    }
    // MARK: - Helper Methods 
    
    func showSecondaryMenu(){
        view.addSubview(menuV)
        menuV.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomConstraint = menuV.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        
        let leftConstraint = menuV.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        
        let rightConstraint = menuV.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        let heightConstraint = menuV.heightAnchor.constraintEqualToConstant(44)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        menuV.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)

        menuV.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.menuV.alpha = 1
        }

    }
    
    func removeSecondaryMenu(){
        UIView.animateWithDuration(0.4, animations: {
                self.menuV.alpha = 0
            }) { completed in
                
                // If completed handles the case where the completion is being avoided because the user pressed filter again and try to show the menu again, so we only remove from SuperView if the user allowed the completion of the animation
                if completed {
                    self.menuV.removeFromSuperview()
                }
        }
        
    }
    
    func showCamera(){
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType =  .Camera
        
        self.presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum(){
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType =  .PhotoLibrary
        
        self.presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    
    // MARK: - Filters Methods
    func highContrast(rgbImage: RGBAImage) -> UIImage {
        
        let MIDDLE: UInt8 = 127
        
        for y in 0..<rgbImage.height{
            for x in 0..<rgbImage.width {
                let index = y * rgbImage.width + x
                var pixel = rgbImage.pixels[index]
                
                if pixel.red > MIDDLE {
                    pixel.red = 255
                }else{
                    pixel.red = 0
                }
                
                if pixel.green > MIDDLE {
                    pixel.green = 255
                }else{
                    pixel.green = 0
                }
                
                if pixel.blue > MIDDLE {
                    pixel.blue = 255
                }else{
                    pixel.blue = 0
                }
                
                rgbImage.pixels[index] = pixel
            }
        }
        return rgbImage.toUIImage()!
        
    }
    
    func blackAndWhiteFilter(rgbImage: RGBAImage) -> UIImage {
        
        let MIDDLE:UInt8 = 127
        for y in 0..<rgbImage.height{
            for x in 0..<rgbImage.width {
                let index = y * rgbImage.width + x
                var pixel = rgbImage.pixels[index]
                
                if pixel.red > MIDDLE || pixel.green > MIDDLE || pixel.blue > MIDDLE{
                    pixel.red = 255
                    pixel.blue = 255
                    pixel.green = 255
                }else{
                    pixel.red = 0
                    pixel.blue = 0
                    pixel.green = 0
                }
                
                rgbImage.pixels[index] = pixel
            }
        }
        return rgbImage.toUIImage()!
        
    }

    func transparencyHigh(rgbImage: RGBAImage) -> UIImage{
        
        for y in 0..<rgbImage.height{
            for x in 0..<rgbImage.width {
                let index = y * rgbImage.width + x
                var pixel = rgbImage.pixels[index]
                
                pixel.alpha = 50
                rgbImage.pixels[index] = pixel
            }
            
            
        }
        return rgbImage.toUIImage()!
        
    }
    
    func firstFilter(rgbImage: RGBAImage) -> UIImage{
        for y in 0..<rgbImage.height{
            for x in 0..<rgbImage.width {
                let index = y * rgbImage.width + x
                var pixel = rgbImage.pixels[index]
                
                pixel.red = UInt8(min(255, Int(pixel.red) + 20))
                pixel.green = UInt8(min(255, Int(pixel.green) + 40))
                pixel.blue = UInt8(max(0, Int(pixel.red) - 10))
                rgbImage.pixels[index] = pixel
            }
            
            
        }
        return rgbImage.toUIImage()!
    }

    // MARK: - UIImagePickerControllerDelegate Methods
    
    // UINavigationDelegate doesn't require methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage]
        imageV.image = image! as? UIImage
        originalImage = image! as? UIImage
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

