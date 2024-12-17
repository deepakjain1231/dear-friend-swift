//
//  BottomStackItem.swift
//  MYTabBarDemo
//
//  Created by Abhishek Thapliyal on 30/05/20.
//  Copyright © 2020 Abhishek Thapliyal. All rights reserved.
//

import Foundation

class BottomStackItem {
    
    var title: String
    var image: String
    var selectedImage: String
    var isSelected: Bool
    
    init(title: String,
         image: String,
         selectedImage: String,
         isSelected: Bool = false) {
        self.title = title
        self.image = image
        self.selectedImage = selectedImage
        self.isSelected = isSelected
    }
}
