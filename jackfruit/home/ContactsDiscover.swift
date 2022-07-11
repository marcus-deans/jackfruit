
//

import SwiftUI
import ToastUI

struct ContactsDiscover: View {
   @State var showingPopup = false // 1
   @State private var presentingToast: Bool = false

   //let words = ["tennis", "working out",  "hiking", "spikeball"]
   let words = ["tennis", "criket", "baseball"]
   @State var isPresented = false
     
   var body: some View {
       ZStack{
           Color.white
               .edgesIgnoringSafeArea(.all)
       VStack{
       
       let data = words.map { " \($0)" }
       let screenWidth = UIScreen.main.bounds.width

           let columns = [
               GridItem(.fixed(screenWidth-200), spacing: 5),
         
               GridItem(.flexible()),
           ]
             
      
       ZStack{
            NavigationView {
                ScrollView {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(data, id: \.self) { item in
                                Button {
                                    presentingToast = true
                                    showingPopup = true // 2
                                    isPresented = true
                                } label: {
                                    VStack {
                                        Text(item).font(Font.custom("CircularStd-Book", size: 25))
                                        Text("9 Contacts").font(Font.custom("CircularStd-Book", size: 15))
                                    }
                                        
                                        .frame(width: screenWidth-220, height: 100)
                                        .background(RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [.init(UIColor.activitiesRight) , .init(UIColor.activitiesLeft)]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )).shadow(radius: 3)
                                        )
                                        .foregroundColor(.black).padding(.top, 20)
                                       .toast(isPresented: $presentingToast) {
                                       ToastView {
                                           VStack {
                                                     Text("Your Friends")
                                                       .padding(.bottom, 20)
                                                       .multilineTextAlignment(.center)
                                                      
                                                           Text("joe")
                                                           Text("Jeff")
                                                           Text("Mark")
                                                           
                                                           
                                                       
                                                     Button {
                                                       presentingToast = false
                                                     } label: {
                                                       Text("Back")
                                                         .bold()
                                                         .foregroundColor(.white)
                                                         .padding(.horizontal)
                                                         .padding(.vertical, 12.0)
                                                         .background(Color.accentColor)
                                                         .cornerRadius(8.0)
                                                     }
                                           }.frame(width: 250.0, height: 250.0)
                                        }
                                    }
                               }
                           }
                           .padding(.horizontal).frame(maxHeight: 700)
                           .navigationBarTitle("Activities",  displayMode: .inline)
                           
                           .navigationBarHidden(false)
                       }
                    }
                }
            }
       }
   }
}



}
