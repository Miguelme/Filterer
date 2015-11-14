//
//  ViewController.swift
//  Filterer
//
//  Created by Miguel Fagundez on 11/13/15.
//  Copyright © 2015 Miguel Fagundez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var filterBtn: UIButton!
    
    var filteredImage : UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        filterBtn.setTitle("Remove Filter", forState: .Selected)
        // Process the image!
        let rgbImage = RGBAImage(image: imageV.image!)!
        filteredImage = highContrast(rgbImage)

        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Filter
    func highContrast(rgbImage: RGBAImage) -> UIImage {
        
        let MIDDLE: UInt8 = 127
        
        for y in 0..<rgbImage.height{
            for x in 0..<rgbImage.width {
                let index = y * rgbImage.height + x
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
    @IBAction func filterBtnTapped(sender: UIButton) {
        if filterBtn.selected {
            imageV.image = UIImage(named: "sample")
        }else{
            imageV.image = filteredImage
        }
        
        filterBtn.selected = !filterBtn.selected
    }

}

