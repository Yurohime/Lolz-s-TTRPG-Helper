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
        // NavigationView provides the top bar for a title and buttons.
        NavigationView {
            VStack(spacing: 0) {
                // The form to add a new player.
                // This view will slide down from the top when isAddingPlayer is true.
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
                
                // The main list of players.
                List {
                    ForEach(players) { player in
                        // Row for each player
                        HStack {
                            Text(player.name)
                                .font(.headline)
                            
                            Spacer() // Pushes content to the sides
                            
                            // Display the experience points
                            Text("\(player.exp) EXP")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            // Explicit delete button for each player
                            Button(action: {
                                deletePlayer(player: player)
                            }) {
                                Image(systemName: "trash.fill")
                                    .foregroundColor(.red)
                            }
                            // Use BorderlessButtonStyle to ensure the button tap is recognized inside a List row.
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
                // Button to go back to the menu
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        viewRouter.currentPage = "menu"
                    }
                }
                
                // Button to show/hide the "add player" form
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
                // Load the players from storage when the view first appears.
                self.players = SaveManager.shared.loadPlayers()
            }
        }
    }
    
    // MARK: - Functions
    
    private func addPlayer() {
        guard !newPlayerName.isEmpty else { return }
        
        // Create a new player and add it to our array.
        // The completedTasks dictionary is initialized as an empty dictionary.
        let newPlayer = Player(id: UUID(), name: newPlayerName, exp: 0, completedTasks: [:])
        players.append(newPlayer)
        
        // Save the updated array to disk.
        SaveManager.shared.save(players: players)
        
        // Clear the text field and hide the form.
        newPlayerName = ""
        withAnimation {
            isAddingPlayer = false
        }
    }
    
    // Updated delete function to handle deletion from the button tap.
    private func deletePlayer(player: Player) {
        // Find the player in the array by their unique ID and remove them.
        if let index = players.firstIndex(where: { $0.id == player.id }) {
            players.remove(at: index)
            // Save the updated array to disk.
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
