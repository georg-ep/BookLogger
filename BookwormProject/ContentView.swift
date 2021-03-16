//
//  ContentView.swift
//  BookwormProject
//
//  Created by George Patterson on 15/03/2021.
//

import SwiftUI

struct ContentView: View {
    
    /*
    When we place an object in an environment for that view, it becomes accessible to that view. So if we have VIew A which contains View B, anything in View A will also be in the environment for View B
     
     When we present a new view as a sheet, we need to explicitly pass in a managed object contect for it to use.
     */
    
    //this creates the MOC we can pass into the sheet
    @Environment(\.managedObjectContext) var moc
    

    //fetch request allows us to read and access all the books
    @FetchRequest(entity: Book.entity(), sortDescriptors: [
        //allows us to sort all the books by title and author, using NSSortDescriptor
        NSSortDescriptor(keyPath: \Book.title, ascending: true),
        NSSortDescriptor(keyPath: \Book.author, ascending: true)
        
    ]) var books: FetchedResults<Book>

    @State private var showingAddScreen = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(books, id: \.self) { book in
                    NavigationLink(destination: DetailView(book: book)){
                        EmojiRatingView(rating: book.rating)
                            .font(.largeTitle)

                        VStack(alignment: .leading) {
                            Text(book.title ?? "Unknown Title")
                                .font(.headline)
                            Text(book.author ?? "Unknown Author")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                //calls our closure to locate the book and delete the book from the context
                .onDelete(perform: deleteBooks)
            }
                .navigationBarTitle("Book Logger 📖")
            //the edit button allows us to delete multiple books at once using the ondelete modifier above
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                    self.showingAddScreen.toggle()
                }) {
                    Image(systemName: "plus")
                })
                .sheet(isPresented: $showingAddScreen) {
                    //here we need to write values for the environemnt
                    //this is where we use the .enviornment() modifier
                    //take 2 params, key to write to and value to send in
                    
                    AddBookView().environment(\.managedObjectContext, self.moc)
                }
        }
    }
    
    //remmeber we use index set with offsets to locate the right position of the book in a list/array
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            //find the book in our fetch request
            let book = books[offset]
            //delete from context
            moc.delete(book)
        }
        //save context
        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
