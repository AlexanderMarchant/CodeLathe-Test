//
//  Fonts.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 13/01/2021.
//

import Foundation
import UIKit

struct Fonts {
    
    static var titleFont: UIFont {
        guard let titleFont = UIFont(name: "Inter-Bold", size: 26) else {
            fatalError("""
                Failed to load the "Inter-Bold" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        let metrics = UIFontMetrics(forTextStyle: .headline)
        return metrics.scaledFont(for: titleFont)
    }
    
    static var subTitleFont: UIFont {
        guard let subTitle = UIFont(name: "Inter-SemiBold", size: 22) else {
            fatalError("""
                Failed to load the "Inter-SemiBold" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        let metrics = UIFontMetrics(forTextStyle: .headline)
        return metrics.scaledFont(for: subTitle)
    }
    
    static var headerFont: UIFont {
        guard let headerFont = UIFont(name: "Inter-SemiBold", size: 18) else {
            fatalError("""
                Failed to load the "Inter-SemiBold" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        let metrics = UIFontMetrics(forTextStyle: .headline)
        return metrics.scaledFont(for: headerFont)
    }
    
    static var subHeaderFont: UIFont {
        guard let subHeaderFont = UIFont(name: "Inter-Medium", size: 16) else {
            fatalError("""
                Failed to load the "Inter-Medium" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        let metrics = UIFontMetrics(forTextStyle: .subheadline)
        return metrics.scaledFont(for: subHeaderFont)
    }
    
    static var buttonFont: UIFont {
        guard let buttonFont = UIFont(name: "Inter-SemiBold", size: 18) else {
            fatalError("""
                Failed to load the "Inter-SemiBold" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        let metrics = UIFontMetrics(forTextStyle: .title1)
        return metrics.scaledFont(for: buttonFont)
    }
    
    static var bodyFont: UIFont {
        guard let bodyFont = UIFont(name: "Inter-Regular", size: 16) else {
            fatalError("""
                Failed to load the "Inter-Regular" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        let metrics = UIFontMetrics(forTextStyle: .body)
        return metrics.scaledFont(for: bodyFont)
    }
    
    static var captionFont: UIFont {
        guard let captionFont = UIFont(name: "Inter-Regular", size: 14) else {
            fatalError("""
                Failed to load the "Inter-Regular" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        let metrics = UIFontMetrics(forTextStyle: .caption1)
        return metrics.scaledFont(for: captionFont)
    }
}
