////
////  LottieView.swift
////  cardView
////
////  Created by Aryan Mahindra on 7/17/22.
////
//
//
//// text and call bith bigger
//// both on the lower end
//// below professional
//// grid like
//
//
//
//import SwiftUI
//
//extension View {
//    func border(_ color: Color, width: CGFloat, cornerRadius: CGFloat) -> some View {
//        overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(color, lineWidth: width))
//    }
//}
//
//
//
//struct ProfileView: View {
//
//    @State var show = false
//
//
//    var body: some View {
//        VStack() {
//
//            //            Text("")
//            //            .padding()
//            //
//            //
//            //            Image("img_jd")
//            //                .resizable()
//            //                .aspectRatio(contentMode: .fill)
//            //                .frame(width: 120, height: 120)
//            //                .cornerRadius(60)
//            //                .shadow(radius: 5)
//            //
//            ZStack{
//                if #available(iOS 15.0, *) {
//                    AsyncImage(url: URL(string: "https://cdn1.sph.harvard.edu/wp-content/uploads/sites/1691/2014/07/Juan.jpg")) { phase in
//                        switch phase {
//                            // dealing w loading up page if needed
//                            //                    case .empty:
//                            //                        ProgressView()
//                            //                            .progressViewStyle(.circular)
//                        case .success(let image):
//                            image
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                            //.transition(.slide)
//                                .frame(width: 150, height: 150)
//                                .cornerRadius(90)
//                                .shadow(radius: 5)
//
//                            //  .offset(x:0.0, y: -140.0)
//                            //                    case .failure:
//                            //                        Text("Failed fetching image. Make sure to check your data connection and try again.")
//                            //                            .foregroundColor(.red)
//                        @unknown default:
//                            Text("") // nothing displaying for now
//                            //                        Text("Unknown error. Please try again.")
//                            //                            .foregroundColor(.red)
//                        }
//                    }
//
//
//                } else {
//                    // Fallback on earlier versions
//                }
//
//
//                //                LottieView(filename: "circle"  )
//                //                    .frame(width: 260, height: 260)}
//
//            }
//
//        }
//
//
//        VStack  {
//            Text("JD")
//                .font(.system(size: 30))
//                .fontWeight(.heavy)
//
//            HStack{
//                Text("iOS Engineer")
//
//            }
//
//            HStack{
//
//                HStack(spacing: 8){
//                    Image("map").resizable().frame(width: 15, height: 20)
//                    Text("San Francisco")
//                }.padding(8)
//                    .background(Color.black.opacity(0.1))
//                    .cornerRadius(10)
//
//                HStack(spacing: 8){
//                    Image(systemName: "suitcase").resizable().frame(width: 20, height: 20)
//                }.padding(8)
//                    .background(Color.black.opacity(0.1))
//                    .cornerRadius(10)
//
//            }
//
//
//            HStack(spacing: 8){
//                Text("+1 123-458-990")
//            }.padding(8)
//                .background(Color.black.opacity(0.1))
//                .cornerRadius(10)
//
//            HStack{
//                Button(action: {//messagesOpener()
//                    sendMessage()
//                }) {
//                    Image(systemName: "message")
//                        .font(.title2)
//                        .frame(width: 110, height: 60)
//                        .modifier(ButtonBG())
//                        .cornerRadius(30)
//                        .border(Color.blue, width: 2, cornerRadius: 25)
//                }
//                .padding()
//
//                .modifier(ThemeShadow())
//                Button(action: {
//                    //                    let phone = "tel:"
//                    //                    var phoneNumber = "(800)555-1212"
//                    //                    let phoneNumberformatted = phone + phoneNumber
//                    //                    guard let url = URL(string: phoneNumberformatted) else { return }
//                    //                    UIApplication.shared.open(url)
//                    //                    let dialer = URL(string: "tel://5028493750")
//                    //                    if let dialerURL = dialer {
//                    //                            UIApplication.shared.open(dialerURL)
//                    //                    }
//
//
//                    var phoneNumber = "(800)555-1212"
//                    guard let number = URL(string: "tel://" + phoneNumber) else { return }
//                    if UIApplication.shared.canOpenURL(number) {
//                        UIApplication.shared.open(number)
//                    } else {
//                        print("Can't open url on this device")
//                    }
//
//                })  {   Image(systemName: "phone")
//                        .font(.title2)
//                        .frame(width: 110, height: 60)
//                        .modifier(ButtonBG())
//                        .cornerRadius(30)
//                        .border(Color.blue, width: 2, cornerRadius: 25)
//
//                }
//                .modifier(ThemeShadow())
//            }
//
//
//        }
//
//        VStack{
//
//
//            let words = ["tennis", "criket", "baseball", "hiking"]
//            ZStack{
//                Color.white
//                    .edgesIgnoringSafeArea(.all)
//                VStack{
//                    let data = words.map { " \($0)" }
//                    let screenWidth = UIScreen.main.bounds.width
//
//                    let columns = [
//                        GridItem(.fixed(screenWidth-200)),
//                        GridItem(.flexible()),
//                        //GridItem(.flexible())
//                    ]
//
//                    ZStack{
//
//                        ScrollView {
//                            LazyVGrid(columns: columns, spacing: 20) {
//                                ForEach(data, id: \.self) { item in
//                                    Button {
//
//                                    } label: {
//                                        Text(item)
//                                            .frame(width: screenWidth-250, height: 50)
//                                        //.padding()
//                                            .background(Color.black)
//                                            .foregroundColor(.white)
//                                            .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
//
//                                    }
//                                }
//
//                                .frame(maxHeight: 50)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//
//    private func messagesOpener(){
//
//
//
//        //            if let url = URL(string: UIApplication.openSettingsURLString) {
//        //                if UIApplication.shared.canOpenURL(url) {
//        //                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        //                }
//        //            }
//
//
//        if UIApplication.shared.canOpenURL(URL(string:"sms:")!) {
//            UIApplication.shared.open(URL(string:"sms:")!, options: [:], completionHandler: nil)
//        }
//    }
//}
//
//
//private func phoneOpener(){
//    if let url = URL(string: UIApplication.openSettingsURLString) {
//        if UIApplication.shared.canOpenURL(url) {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }
//    }
//}
//
//
//
//private func sendMessage(){
//    let sms: String = "sms:+610429326795&body=Hi, it was great meeting you today!"
//    let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//    UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
//}
//
//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//            .preferredColorScheme(.dark)
//    }
//}
//
//struct ProfileCarouselInfo: View {
//    @State private var selectedTab = 0
//    @State var currentDate = Date()
//    let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
//    let info = CarouselInfo.info
//
//    var body: some View {
//        TabView(selection: $selectedTab) {
//            ForEach(0..<info.count) { i in
//                VStack(spacing: 12) {
//                    HStack(spacing: 16) {
//                        Image(systemName: info[i].image)
//                            .font(.system(size: 20))
//                            .foregroundColor(info[i].color)
//                        Text(info[i].title)
//                            .font(.title2)
//                            .bold()
//                    }
//                    Text(info[i].info)
//                        .fontWeight(.light)
//                    Spacer()
//                }
//                .tag(i)
//            }
//        }
//        .frame(width: UIScreen.main.bounds.width, height: 100)
//        .tabViewStyle(PageTabViewStyle())
//        .onReceive(timer) { input in
//            withAnimation(.easeInOut(duration: 1)) {
//                self.selectedTab += 1
//                if selectedTab == info.count {
//                    selectedTab = 0
//                }
//            }
//        }
//    }
//}
//
//struct CarouselInfo {
//    let id: Int
//    let title: String
//    let info: String
//    let image: String
//    let color: Color
//
//    static let info = [
//        CarouselInfo(id: 0,
//                     title: "A",
//                     info: "B",
//                     image: "flame.fill",
//                     color: .white),
//
//        CarouselInfo(id: 1,
//                     title: "C",
//                     info: "D",
//                     image: "bolt.fill",
//                     color: .purple),
//
//
//        CarouselInfo(id: 2,
//                     title: "E",
//                     info: "Fs",
//                     image: "star.fill",
//                     color: .blue),
//        CarouselInfo(id: 3,
//                     title: "G",
//                     info: "H",
//                     image: "location.fill",
//                     color: .blue),
//        CarouselInfo(id: 4,
//                     title: "J",
//                     info: "K",
//                     image: "key.fill",
//                     color: .orange),
//        CarouselInfo(id: 5,
//                     title: "L",
//                     info: "M",
//                     image: "gobackward",
//                     color: .white),
//        CarouselInfo(id: 6,
//                     title: "N",
//                     info: "O",
//                     image: "heart.fill",
//                     color: Color(UIColor(red: 60/255, green: 229/255, blue: 184/255, alpha: 1)))
//    ]
//}
//
//
//struct ButtonBG: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//            .background(Color(UIColor(named: "themeButtonBG") ?? UIColor.secondarySystemBackground))
//    }
//}
//
//struct ThemeShadow: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//            .shadow(color: Color(UIColor.black).opacity(0.1), radius: 8)
//    }
//}
//
//struct RoundedRectangleAroundText: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//            .font(.title)
//            .foregroundColor(.green)
//            .padding(.horizontal, 8)
//            .overlay(
//                RoundedRectangle(cornerRadius: 5)
//                    .stroke(Color.green, lineWidth: 3)
//            )
//            .offset(x: 30)
//    }
//}
//
