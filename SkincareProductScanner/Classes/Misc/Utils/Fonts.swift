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
            UIFont(name: "Outfit-SemiBold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "Outfit-Regular", size: size)!
        }
        
        static func medium(size: CGFloat) -> UIFont {
            UIFont(name: "Outfit-Medium", size: size)!
        }
        
        static func extraBold(size: CGFloat) -> UIFont {
            UIFont(name: "Outfit-ExtraBold", size: size)!
        }
        
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "Outfit-Bold", size: size)!
        }
    }
}
