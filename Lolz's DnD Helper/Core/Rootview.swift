//
//  Rootview.swift
//  RoboGame
//
//  Created by Alberto Halim Limantoro on 09/07/25.
//

import SwiftUI

struct RootView: View {
    @StateObject var viewRouter = ViewRouter()
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        VStack {
            switch viewRouter.currentPage {
            case "menu":
                MenuView()
                    .environmentObject(viewRouter)
            case "playerCharacter":
                PlayerCharacterView()
                    .environmentObject(viewRouter)
            case "expCalculator":
                ExpCalculatorView()
                    .environmentObject(viewRouter)
            case "totalExp":
                TotalExpView()
                    .environmentObject(viewRouter)
            case "expSetter":
                ExpSetterView()
                    .environmentObject(viewRouter)
            default:
                MenuView()
                    .environmentObject(viewRouter)
            }
        }
    }
}

#Preview {
    RootView()
}
