//
//  BooksViewModel.swift
//  MVVMDemoFirebase
//
//  Created by Knoxpo MacBook Pro on 06/01/21.
//

import Foundation
import Combine
import FirebaseFirestore

class BooksViewModel: ObservableObject {
    @Published var books = [Book]()
    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    
    deinit {
        Unsubscribe()
    }
     
    func Unsubscribe()
    {
        if listenerRegistration != nil{
            listenerRegistration?.remove()
            listenerRegistration = nil
            
        }
        
        
        
    }
    func Subscribe()
    {
        if listenerRegistration == nil{
            
            listenerRegistration = db.collection("books").addSnapshotListener { (querySnapshot, error) in
                
                guard let documents = querySnapshot?.documents else{
                    
                  print("no document")
                    return
                    
                }
                self.books = documents.compactMap { queryDocumentSnapShot in
                    try? queryDocumentSnapShot.data(as: Book.self)
                    
                    
                    
                    
                    
                }
                
                
            }
            
        }
        
        
        
    }
    
    func removeBook(atOffsets indexset: IndexSet)
    {
        let books = indexset.lazy.map { self.books[$0] }
        books.forEach { book in
            if let documentId = book.id {
                
                db.collection("books").document(documentId).delete { error in
                    if let error = error{
                        
                        print("Unable to remove document: \(error .localizedDescription)")
                    }
                    
                    
                }
                
            }
            
            
        }
        
        
    }
    
    
    
}
