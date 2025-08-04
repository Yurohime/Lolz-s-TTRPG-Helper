//
//  MenuView.swift
//  Lolz's DnD Helper
//
//  Created by Alberto Halim Limantoro on 04/08/25.
//

import SwiftUI


public struct MenuView: View {
    @EnvironmentObject var viewRouter: ViewRouter

    public var body: some View {
        VStack(spacing: 15) {
            Text("Lolz's Totally not Sus Calculator for all things I need to run my damn TTRPG :)")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
            
            // Player Chacter
            /// For Adding and removing player characters
            Button(action: {
                viewRouter.currentPage = "playerCharacter"
            }) {
                Text("Player Character")
            }
            .modifier(MenuButtonStyle())
            
            // Exp Setter
            /// For Adding and removing player characters
            Button(action: {
                viewRouter.currentPage = "expSetter"
            }) {
                Text("Exp Setter")
            }
            .modifier(MenuButtonStyle())

            // Exp for each character
            /// For Adding and removing player characters
            Button(action: {
                viewRouter.currentPage = "expCalculator"
            }) {
                Text("Exp Calculator")
            }
            .modifier(MenuButtonStyle())

            // Total end day
            /// all charqacter end EXP
            Button(action: {
                viewRouter.currentPage = "totalExp"
            }) {
                Text("Total Exp")
            }
            .modifier(MenuButtonStyle())

            // Dice
            /// Cuz why not
            Button(action: {
                viewRouter.currentPage = "diceRoller"
            }) {
                Text("Dice Roller")
            }
            .modifier(MenuButtonStyle())

            // Reset
            /// for resetting
            Button(action: {
                viewRouter.currentPage = "reset"
            }) {
                Text("Reset")
            }
            .modifier(MenuButtonStyle())
            .foregroundColor(.red)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.red, lineWidth: 2)
                    .padding(.horizontal,80)
                    .padding(.vertical,10)
            )
            
        }
        .padding(.top)
        .navigationTitle("Menu") // Optional: Adds a title if used in a NavigationView
    }
}

#Preview {
    RootView()
}
