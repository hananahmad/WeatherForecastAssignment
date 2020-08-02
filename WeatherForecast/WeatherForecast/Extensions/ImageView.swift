//
//  ImageView.swift
//  WeatherForecast
//
//  Created by Hanan Ahmed on 31/07/2020.
//  Copyright © 2020 WeatherForecast. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView{
    func downloadImage(url : String, placeHolder : UIImage?) throws{
        if let url = URL(string: url){
            self.sd_imageIndicator?.startAnimatingIndicator()
            self.sd_setImage(with: url) { (image, err, type, url) in
                
                if err != nil{
                    self.sd_imageIndicator?.stopAnimatingIndicator()
                    print("Failed to download image")
                }
                self.sd_imageIndicator?.stopAnimatingIndicator()
            }
        }
    }
}
