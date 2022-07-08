//
//  Flow.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-07.
//

import SwiftUI

struct Flow<Content>: View where Content: View {
    @Binding var next: Bool
    
    var content: Content
    
    var body: some View {
        NavigationLink(
            destination: VStack() { content },
                          isActive: $next
        )
        {
            EmptyView()
        }
        
    }
    init(next: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._next = next
        self.content = content()
    }
}
