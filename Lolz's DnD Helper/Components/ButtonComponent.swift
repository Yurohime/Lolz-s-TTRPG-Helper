//
//  ButtonComponent.swift
//  Lolz's DnD Helper
//
//  Created by Alberto Halim Limantoro on 04/08/25.
//

import SwiftUI

struct MenuButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .foregroundColor(.black)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 2)
            )
            .padding(.horizontal,80)
            .padding(.vertical,10)
    }
}

#Preview {
    MenuView()
}
