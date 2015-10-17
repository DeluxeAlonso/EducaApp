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
  
  struct KeyboardSelector {
    static let WillShow: Selector = "keyboardWillShow:"
    static let WillHide: Selector = "keyboardWillHide:"
  }
  
  struct MockData {
    static let UsersName: NSMutableArray = ["Alonso Alvarez", "Fernando Banda", "Luis Barcena",  "Daekef Abarca", "Gloria Cisneros"]
    static let UsersDoc: NSMutableArray = ["45678954", "12345678", "10006532",  "78905321", "14792378"]
    
    static let StudentsName: NSMutableArray = ["Eduardo Arenas", "Julio Castillo", "Juan Reyes", "Andrea Roca", "Robert Aduviri"]
    static let StudentsAge: NSMutableArray = ["12", "11", "05", "07", "10"]
    static let StudentsGender: NSMutableArray = [0, 0, 0, 1, 0]
    
    static let PostsTitle: NSMutableArray = ["Titulo 1", "Titulo 2", "Titulo 3", "Titulo 4", "Titulo 5"]
    static let PostsAuthor: NSMutableArray = ["Daekef Abarca - 20/09/2015", "Daekef Abarca - 12/09/2015", "Alonso Alvarez - 11/07/2015", "Fernando Banda - 20/05/2015", "Daekef Abarca - 022/02/2015"]
    
    static let DocumentsName: NSMutableArray = ["Material extra 27/09.docx", "Guia de actividades 27/09.pdf", "Materiales para 27/09.xlsx", "Documento sin icono"]
    static let DocumentsSize: NSMutableArray = ["126 KB", "254 KB", "1.2 MB", "13 KB"]
    static let DocumentsUploadTime: NSMutableArray = ["Hace 3 dias, 3:24 PM", "Hace 3 dias, 3:21 PM", "Hace 4 dias, 12:05 PM", "Hace 7 dias, 1:14 PM"]
    static let DocumentsImage: NSMutableArray = ["WordIcon", "PDFIcon", "ExcelIcon", "GenericDocIcon"]
    
    static let FirstBlockAuthors: NSMutableArray = ["Alonso Alvarez", "Fernando Banda", "Luis Barcena",  "Daekef Abarca"]
    static let SecondBlockAuthors: NSMutableArray = ["Gloria Cisneros", "Diego Malpartida", "Luis Incio",  "Gabriel Tovar"]
    static let FirstBlockComments: NSMutableArray = ["Tuvo un buen comportamiento el dia de hoy. Sin embargo, le falto ser mas participativo y comprometido con los eventos y juegos realizados en la sesion del dia de hoy.", "Se comporto mal.", "Bien.", "Buen Desempeño."]
    static let SecondBlockComments: NSMutableArray = ["Se comporto bien.", "Tuvo un buen comportamiento el dia de hoy. Sin embargo, le falto ser mas participativo y comprometido con los eventos y juegos realizados en la sesion del dia de hoy.", "Bien", "Se comporto bien."]
    static let FirstBlockMoods: NSMutableArray = [SelectedMood.HappyMood.hashValue, SelectedMood.SadMood.hashValue, SelectedMood.HappyMood.hashValue, SelectedMood.HappyMood.hashValue]
    static let SecondBlockMoods: NSMutableArray = [SelectedMood.HappyMood.hashValue, SelectedMood.HappyMood.hashValue, SelectedMood.HappyMood.hashValue, SelectedMood.HappyMood.hashValue]
    
    static let ReunionPoints = [CLLocationCoordinate2DMake(
      -12.075931,-77.010444),CLLocationCoordinate2DMake(
        -12.072802,-77.014651), CLLocationCoordinate2DMake(
          -12.07033,-77.029138)]
    
    static let VolunteerPoints = [CLLocationCoordinate2DMake(
      -12.031812,-77.007378),CLLocationCoordinate2DMake(
        -11.991553,-77.102887), CLLocationCoordinate2DMake(
          -12.068016, -77.001027)]
  }

}
