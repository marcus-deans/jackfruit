//
//  Screen9PhotoView.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-10.
//

import SwiftUI

final class Screen9PhotoVM: ObservableObject, Completeable {
    @Published var photoURL: String?
    
    
    let didComplete = PassthroughSubject<Screen9PhotoVM, Never>()
    
    init(photoURL: String?) {
        self.photoURL = photoURL ?? ""
    }
    
    func didTapNext() {
        //do some network calls etc
        didComplete.send(self)
    }
}

struct Screen9PhotoView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct Screen9PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        Screen9PhotoView()
    }
}
