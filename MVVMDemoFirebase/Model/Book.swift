//
//  Book.swift
//  MVVMDemoFirebase
//
//  Created by Knoxpo MacBook Pro on 06/01/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Book: Identifiable, Codable{
    @DocumentID var id: String?
    var title: String
    var author: String
    var numberOfPages: Int
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case title
        case author
        case numberOfPages = "pages"
        
        
    }
    
    
    
    
}
