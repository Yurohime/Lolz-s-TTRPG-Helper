//
//  PlayerCharacterView 2.swift
//  Lolz's DnD Helper
//
//  Created by Alberto Halim Limantoro on 04/08/25.
//

import SwiftUI

public struct PlayerCharacterView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var players: [Player] = []
    @State private var isAddingPlayer = false
    @State private var newPlayerName = ""
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if isAddingPlayer {
                    VStack {
                        TextField("Enter player name", text: $newPlayerName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
                        Button(action: addPlayer) {
                            Text("Save Player")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .padding([.horizontal, .bottom])
                        .disabled(newPlayerName.isEmpty) // Disable button if name is empty
                    }
                    .padding(.top)
                    .background(Color(.systemGroupedBackground))
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
                List {
                    ForEach(players) { player in
                        HStack {
                            Text(player.name)
                                .font(.headline)
                            
                            Spacer()
                            
                            Text("\(player.exp) EXP")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Button(action: {
                                deletePlayer(player: player)
                            }) {
                                Image(systemName: "trash.fill")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(InsetGroupedListStyle())
                
            }
            .navigationTitle("Characters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        viewRouter.currentPage = "menu"
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            isAddingPlayer.toggle()
                            newPlayerName = "" // Clear name when toggling
                        }
                    }) {
                        Image(systemName: isAddingPlayer ? "xmark.circle.fill" : "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .onAppear {
                self.players = SaveManager.shared.loadPlayers()
            }
        }
    }
    
    // MARK: - Functions
    
    private func addPlayer() {
        guard !newPlayerName.isEmpty else { return }
    
        let newPlayer = Player(id: UUID(), name: newPlayerName, exp: 0, completedTasks: [:])
        players.append(newPlayer)
        SaveManager.shared.save(players: players)
        
        newPlayerName = ""
        withAnimation {
            isAddingPlayer = false
        }
    }
    
    private func deletePlayer(player: Player) {
        if let index = players.firstIndex(where: { $0.id == player.id }) {
            players.remove(at: index)
            SaveManager.shared.save(players: players)
        }
    }
}

struct PlayerCharacterView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerCharacterView()
            .environmentObject(ViewRouter())
    }
}
