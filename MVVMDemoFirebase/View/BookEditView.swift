//
//  BookEditView.swift
//  MVVMDemoFirebase
//
//  Created by Knoxpo MacBook Pro on 06/01/21.
//

import SwiftUI

enum Mode {
  case new
  case edit
}

enum Action {
  case delete
  case done
  case cancel
}

struct BookEditView: View {
 
  
  @Environment(\.presentationMode) private var presentationMode
  @State var presentActionSheet = false

  
  
  @ObservedObject var viewModel = BookViewModel()
  var mode: Mode = .new
  var completionHandler: ((Result<Action, Error>) -> Void)?
  
  
  
  var cancelButton: some View {
    Button(action: { self.handleCancelTapped() }) {
      Text("Cancel")
    }
  }
  
  var saveButton: some View {    Button(action: { self.handleDoneTapped() }) {
      Text(mode == .new ? "Done" : "Save")
    }
    .disabled(!viewModel.modified)
  }
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Book")) {
          TextField("Title", text: $viewModel.book.title)
          TextField("Number of pages", value: $viewModel.book.numberOfPages, formatter: NumberFormatter())
        }
        
        Section(header: Text("Author")) {
          TextField("Author", text: $viewModel.book.author)
        }
        
        if mode == .edit {
          Section {
            Button("Delete book") { self.presentActionSheet.toggle() }
              .foregroundColor(.red)
          }
        }
      }
      .navigationTitle(mode == .new ? "New book" : viewModel.book.title)
      .navigationBarTitleDisplayMode(mode == .new ? .inline : .large)
      .navigationBarItems(
        leading: cancelButton,
        trailing: saveButton
      )
      .actionSheet(isPresented: $presentActionSheet) {
        ActionSheet(title: Text("Are you sure?"),
                    buttons: [
                      .destructive(Text("Delete book"),
                                   action: { self.handleDeleteTapped() }),
                      .cancel()
                    ])
      }
    }
  }
  
  
  
  func handleCancelTapped() {
    self.dismiss()
  }
  
  func handleDoneTapped() {
    viewModel.handelDoneTapped()
    self.dismiss()
  }
  
  func handleDeleteTapped() {
    viewModel.handelDeleteTapped()
    self.dismiss()
    self.completionHandler?(.success(.delete))
  }
  
  func dismiss() {
    self.presentationMode.wrappedValue.dismiss()
  }
}

struct BookEditView_Previews: PreviewProvider {
  static var previews: some View {
    let book = Book(title: "Changer", author: "Matt Gemmell", numberOfPages: 474)
    let bookViewModel = BookViewModel(book: book)
    return BookEditView(viewModel: bookViewModel, mode: .edit)
  }
}
