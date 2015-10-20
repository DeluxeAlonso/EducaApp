//
//  ArrayHelper.swift
//  EducaApp
//
//  Created by Alonso on 10/16/15.
//  Copyright © 2015 Alonso. All rights reserved.
//

import UIKit

extension Array {
  
  func each(doThis: (element: Element) -> Void) {
    for e in self {
      doThis(element: e)
    }
  }
  
}