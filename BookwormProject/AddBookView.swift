//
//  AddBookView.swift
//  BookwormProject
//
//  Created by George Patterson on 15/03/2021.
//

import SwiftUI

struct AddBookView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    //this environment property manages the presentation mode,
    //allowing us to dismiss the sheet when needed
    @Environment(\.presentationMode) var presentationMode
    
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]

    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of the boook", text: $title)
                    TextField("Name of author", text: $author)
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                Section {
                    RatingReview(rating: $rating)
                    TextField("Write a review", text: $review)
                }
                Section {
                    Button("Save") {
                        
                        let book = Book(context: self.moc)
                        book.title = self.title
                        book.author = self.author
                        book.rating = Int16(self.rating)
                        book.genre = self.genre
                        book.review = self.review
                        
                        try? self.moc.save()
                        self.presentationMode.wrappedValue.dismiss()
                        
                    }
                }
            }
            .navigationBarTitle("Add New Book")
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
