//
//  BookViewModel.swift
//  MVVMDemoFirebase
//
//  Created by Knoxpo MacBook Pro on 06/01/21.
//

import Foundation
import Combine
import FirebaseFirestore

class BookViewModel: ObservableObject {
    
    @Published var book: Book
    @Published var modified = false
    
    private var cancellable = Set<AnyCancellable>()
    
    init(book: Book = Book(title: "", author: "", numberOfPages: 0)) {
        self.book = book
        
        self.$book
            .dropFirst()
            .sink {[ weak self ] book in
                self?.modified = true
            }
            .store(in: &self.cancellable)
    }
    
    //Mark - firebase
    
    private var db = Firestore.firestore()
    
   
    
    ///add book
   private func addBook(_ book: Book){
   do {
    
    let _ = try db.collection("books").addDocument(from: book)
        
    }
   catch{
    
    print(error)
   }
    
    }
    //update book
    private func updateBook(_ book: Book)
    {
        if let documentId = book.id{
        
        do {
            try db.collection("books").document(documentId).setData(from: book)
            
        }
        catch
        {
           print(error)
        }
        
        
    }
    }
    
    
    // update or delte book
    
    private func updateOrAddBook() {
      if let _ = book.id {
        self.updateBook(self.book)
      }
      else {
        addBook(book)
      }
    }
    
    
    // delete book
    private func deleteBook()
    {
        if let documentId = book.id {
            
            db.collection("books").document(documentId).delete { error in
                if let error = error {
                    print(error.localizedDescription)
    
                }
                
            }
            
            
        }
        
        
        
    }
    
    
    
    func handelDoneTapped() {
        self.updateOrAddBook()
        
    }
    
    func handelDeleteTapped() {
        
        self.deleteBook()
    }
    
    
    
    
}
