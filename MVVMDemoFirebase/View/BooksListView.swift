//
//  BooksListView.swift
//  MVVMDemoFirebase
//
//  Created by Knoxpo MacBook Pro on 06/01/21.
//
import SwiftUI

@available(iOS 14.0, *)
struct BooksListView: View {
 
  
  @StateObject var viewModel = BooksViewModel()
  @State var presentAddBookSheet = false
  
 
  
  private var addButton: some View {
    Button(action: { self.presentAddBookSheet.toggle() }) {
      Image(systemName: "plus")
    }
  }
  
  private func bookRowView(book: Book) -> some View {
    NavigationLink(destination: BookDetailsView(book: book)) {
      VStack(alignment: .leading) {
        Text(book.title)
          .font(.headline)
        Text(book.author)
          .font(.subheadline)
        Text("\(book.numberOfPages) pages")
          .font(.subheadline)
      }
    }
  }
  
  var body: some View {
    NavigationView {
      List {
        ForEach (viewModel.books) { book in
          bookRowView(book: book)
        }
        .onDelete() { indexSet in
            viewModel.removeBook(atOffsets: indexSet)
        }
      }
      .navigationBarTitle("Books")
      .navigationBarItems(trailing: addButton)
      .onAppear() {
        print("BooksListView appears. Subscribing to data updates.")
        viewModel.Subscribe()
      }
      .onDisappear() {
       
      }
      .sheet(isPresented: self.$presentAddBookSheet) {
        BookEditView()
      }
    }
  }
}

struct BooksListView_Previews: PreviewProvider {
  static var previews: some View {
    BooksListView()
  }
}











 

