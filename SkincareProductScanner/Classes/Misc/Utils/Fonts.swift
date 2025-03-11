//
//  Fonts.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import UIKit

struct Fonts {
    // MARK: Outfit
    struct Outfit {
        static func semiBold(size: CGFloat) -> UIFont {
            UIFont(name: "OutfitBold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "OutfitRegular", size: size)!
        }
        
        static func medium(size: CGFloat) -> UIFont {
            UIFont(name: "OutfitMedium", size: size)!
        }
        
        static func extraBold(size: CGFloat) -> UIFont {
            UIFont(name: "OutfitExtraBold", size: size)!
        }
        
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "OutfitBold", size: size)!
        }
    }
}
