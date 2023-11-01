//
//  SectionHeaderView.swift
//  Kofi
//
//  Created by Geovana Contine on 31/10/23.
//

import SwiftUI

public struct SectionHeaderView<Content: View>: View {
    
    let title: String
    let content: () -> Content
    
    public init(_ title: String, content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }
    
    public var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(title)
                        .style(.headline, weight: .bold)
                    
                    Spacer()
                }
            }
            .padding(.horizontal, size: .xxxs)
            
            content()
        }
    }
}
