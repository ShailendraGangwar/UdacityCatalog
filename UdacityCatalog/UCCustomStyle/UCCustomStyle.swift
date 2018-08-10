//
//  UCCustomStyle.swift
//  UdacityCatalog
//
//  Created by Shailendra Gangwar on 10/07/18.
//  Copyright © 2018 Shailendra Gangwar. All rights reserved.
//

import Foundation
import UIKit

class UCCustomStyle {
    class func attributedText(first: String, second: String) -> NSAttributedString{
        let string = first + second as NSString
        let result = NSMutableAttributedString(string: string as String)
        
        let attributesForFirstWord = [
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15),
            NSAttributedStringKey.foregroundColor : UIColor.black,
            NSAttributedStringKey.backgroundColor : UIColor.groupTableViewBackground,
            ]
        let attributesForSecondWord = [
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14),
            NSAttributedStringKey.foregroundColor : UIColor.darkGray,
            NSAttributedStringKey.backgroundColor : UIColor.clear,
            ]
        result.setAttributes(attributesForFirstWord,
                             range: string.range(of: first))
        
        result.setAttributes(attributesForSecondWord,
                             range: string.range(of: second))
        
        return NSAttributedString(attributedString: result)
    }
    
    class func attributedText(first: String) -> NSAttributedString{
        let string = first as NSString
        let result = NSMutableAttributedString(string: string as String)
        
        let attributesForFirstWord = [
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15),
            NSAttributedStringKey.foregroundColor : UIColor.black,
            NSAttributedStringKey.backgroundColor : UIColor.groupTableViewBackground,
            ]
        result.setAttributes(attributesForFirstWord, range: string.range(of: first))
        return NSAttributedString(attributedString: result)
    }
}
