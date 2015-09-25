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
    static let Development = "https://private-e8504-newsapp3.apiary-mock.com/api/v1/"
  }
  
  struct Notification {
    static let SignIn = "SignIn"
    static let SignOut = "SignOut"
  }
  
  struct PayPal {
    static let SandBox = "ASmHc1Vntg-KyLxUlgsEsL3JeH15Ih34zTHbhLocc9tyssXxCxCoXAph__kkoCPVcuuAUF-x4dwkRpom"
    static let Production = "ASmHc1Vntg-KyLxUlgsEsL3JeH15Ih34zTHbhLocc9tyssXxCxCoXAph__kkoCPVcuuAUF-x4dwkRpom"
  }
  
  struct Keychain {
    static let AuthTokenKey = "v_Data"
  }
  
  struct MockData {
    static let DocumentsName: NSMutableArray = ["Material extra 27/09.docx", "Guia de actividades 27/09.pdf", "Materiales para 27/09.xlsx", "Documento sin icono"]
    static let DocumentsSize: NSMutableArray = ["126 KB", "254 KB", "1.2 MB", "13 KB"]
    static let DocumentsUploadTime: NSMutableArray = ["Hace 3 dias, 3:24 PM", "Hace 3 dias, 3:21 PM", "Hace 4 dias, 12:05 PM", "Hace 7 dias, 1:14 PM"]
    static let DocumentsImage: NSMutableArray = ["WordIcon", "PDFIcon", "ExcelIcon", "GenericDocIcon"]
  }
  
}
