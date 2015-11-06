//
//  Constants.swift
//  EducaApp
//
//  Created by Alonso on 9/6/15.
//  Copyright (c) 2015 Alonso. All rights reserved.
//

import UIKit

struct Constants {
  
  struct Path {
    static let Development = "http://200.16.7.111/afiperularavel/public/api/v1/"
    static let Localhost = "http://192.168.1.6:8000/api/v1/"
    static let Apiary = "http://private-7791c-afiapp.apiary-mock.com/api/v1/"
    static let BaseUrl = "http://200.16.7.111/afiperularavel/public/"
  }
  
  struct Notification {
    static let SignIn = "SignIn"
    static let SignOut = "SignOut"
  }
  
  struct PayPal {
    static let SandBox = "ASmHc1Vntg-KyLxUlgsEsL3JeH15Ih34zTHbhLocc9tyssXxCxCoXAph__kkoCPVcuuAUF-x4dwkRpom"
    static let Production = "ASmHc1Vntg-KyLxUlgsEsL3JeH15Ih34zTHbhLocc9tyssXxCxCoXAph__kkoCPVcuuAUF-x4dwkRpom"
  }
  
  struct Api {
    static let Header = "Authorization"
    static let ErrorKey = "error"
  }
  
  struct Keychain {
    static let AuthTokenKey = "v_Data"
  }
  
  struct KeyboardSelector {
    static let WillShow: Selector = "keyboardWillShow:"
    static let WillHide: Selector = "keyboardWillHide:"
  }
  
  struct MockData {
    static let PostsTitle: NSMutableArray = ["Titulo 1", "Titulo 2", "Titulo 3", "Titulo 4", "Titulo 5"]
    static let PostsAuthor: NSMutableArray = ["Daekef Abarca - 20/09/2015", "Daekef Abarca - 12/09/2015", "Alonso Alvarez - 11/07/2015", "Fernando Banda - 20/05/2015", "Daekef Abarca - 022/02/2015"]
  }

}
