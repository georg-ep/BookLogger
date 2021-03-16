//
//  RatingReview.swift
//  BookwormProject
//
//  Created by George Patterson on 15/03/2021.
//

import SwiftUI

struct RatingReview: View {
    
    @Binding var rating: Int
    //this binding will report back the users selection to whatever the star rating is
    
    var label = ""
    var maxRating = 5
    var offImage: Image?
    var onImage = Image(systemName: "star")
    
    var offColour = Color.gray
    var onColour = Color.yellow
    
    var body: some View {
        
        HStack {
            if label.isEmpty == false {
                Text(label)
            }
            
            ForEach(1..<maxRating + 1) { number in
                self.image(for: number)
                    .foregroundColor(number > self.rating ? self.offColour : self.onColour)
                    .onTapGesture {
                        self.rating = number
                    }
            }
        }
        
    }
    
    func image(for number: Int) -> Image {
        if number > rating {
            //if number greater than current rating return offImage
            //optional so if that fails just return the on image
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
}

struct RatingReview_Previews: PreviewProvider {
    static var previews: some View {
        //this is a constant binding, and they have fixed values, perfect for previews and filling in @Binding variables
        RatingReview(rating: .constant(4))
    }
}
