//
//  CustomIndicatorStyles.swift
//  EducaApp
//
//  Created by Alonso on 9/13/15.
//  Copyright (c) 2015 Alonso. All rights reserved.
//

import Foundation

let kSpotifyStyleKey = "spotifyLike"
let kChasingDotsStyleKey = "chasingDots"

enum CustomIndicatorStyle: Int {
  case chasingDots, spotifyLike
  
  static let defaultValue = CustomIndicatorStyle.chasingDots
  
  static func conv(value: String) -> CustomIndicatorStyle {
    switch value {
    case kSpotifyStyleKey: return .spotifyLike
    case kChasingDotsStyleKey: return .chasingDots
    default: return defaultValue
    }
  }
  
  static func convInv(value: CustomIndicatorStyle) -> String {
    switch value {
    case .spotifyLike: return kSpotifyStyleKey
    default: return kChasingDotsStyleKey
    }
  }
}

extension CustomIndicatorStyle {
  init() { self = .chasingDots }
  
  static func random() -> CustomIndicatorStyle {
    return CustomIndicatorStyle(rawValue: Int(arc4random_uniform(7)) + 1)!
  }
  
}

extension CustomIndicatorStyle : StringLiteralConvertible {
  
  init(stringLiteral v : String) {
    self = CustomIndicatorStyle.conv(v)
  }
  
  init(unicodeScalarLiteral v : String) {
    self = CustomIndicatorStyle.conv(v)
  }
  
  init(extendedGraphemeClusterLiteral v: String) {
    self = CustomIndicatorStyle.conv(v)
  }
  
  static func convertFromStringLiteral(value: String) -> CustomIndicatorStyle {
    return conv(value)
  }
  
  static func convertFromExtendedGraphemeClusterLiteral(value: String) -> CustomIndicatorStyle {
    return conv(value)
  }
}
