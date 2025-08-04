//
//  ExpCalculatorView.swift
//  Lolz's DnD Helper
//
//  Created by Alberto Halim Limantoro on 04/08/25.
//

import SwiftUI

public struct ExpCalculatorView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    // All players and all available tasks
    @State private var players: [Player] = []
    @State private var tasks: [ExpTask] = []
    
    // Index to track the currently displayed player
    @State private var currentPlayerIndex: Int = 0
    
    public var body: some View {
        NavigationView {
            VStack {
                if players.isEmpty {
                    Text("No players found. Please add a character first.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    // Player navigation header
                    playerHeader
                    
                    // List of tasks for the current player
                    List {
                        Section(header: Text("Available Tasks")) {
                            if tasks.isEmpty {
                                Text("No tasks found. Please add tasks in the Exp Setter.")
                            } else {
                                ForEach(tasks) { task in
                                    taskRow(for: task)
                                }
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("EXP Calculator")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        // Save changes before going back
                        saveAndExit()
                    }
                }
            }
            .onAppear(perform: loadData)
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
                 saveAndExit()
            }
        }
    }
    
    // View for the player name and navigation buttons
    private var playerHeader: some View {
        VStack {
            Text(players[currentPlayerIndex].name)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("\(players[currentPlayerIndex].exp) Total EXP")
                .font(.headline)
                .foregroundColor(.secondary)
            
            HStack {
                Button(action: showPreviousPlayer) {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.largeTitle)
                }
                .disabled(players.count < 2)
                
                Spacer()
                
                Button(action: showNextPlayer) {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.largeTitle)
                }
                .disabled(players.count < 2)
            }
            .padding()
        }
        .padding(.vertical)
        .background(Color(.systemGroupedBackground))
    }
    
    // View for a single task row with a toggle
    private func taskRow(for task: ExpTask) -> some View {
        HStack {
            // Binding to control the toggle
            let isCompletedBinding = Binding<Bool>(
                get: {
                    // Get the completion status from the player's dictionary
                    return players[currentPlayerIndex].completedTasks[task.id, default: false]
                },
                set: { isCompleted in
                    // Update the completion status and recalculate EXP
                    players[currentPlayerIndex].completedTasks[task.id] = isCompleted
                    recalculateTotalExp()
                }
            )
            
            Toggle(isOn: isCompletedBinding) {
                Text(task.name)
            }
            .toggleStyle(SwitchToggleStyle(tint: .blue))
            
            Spacer()
            
            Text("\(task.expValue) EXP")
                .foregroundColor(.gray)
        }
    }
    
    // MARK: - Functions
    
    private func loadData() {
        self.players = SaveManager.shared.loadPlayers()
        self.tasks = SaveManager.shared.loadTasks()
        if players.isEmpty {
            currentPlayerIndex = 0
        }
    }
    
    private func showPreviousPlayer() {
        currentPlayerIndex = (currentPlayerIndex - 1 + players.count) % players.count
    }
    
    private func showNextPlayer() {
        currentPlayerIndex = (currentPlayerIndex + 1) % players.count
    }
    
    private func recalculateTotalExp() {
        let totalExp = tasks.reduce(0) { sum, task in
            // If the task is completed for the current player, add its value to the sum
            if players[currentPlayerIndex].completedTasks[task.id, default: false] {
                return sum + task.expValue
            }
            return sum
        }
        players[currentPlayerIndex].exp = totalExp
    }
    
    private func saveAndExit() {
        SaveManager.shared.save(players: players)
        viewRouter.currentPage = "menu"
    }
}

struct ExpCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        ExpCalculatorView()
            .environmentObject(ViewRouter())
    }
}


#Preview {
    ExpCalculatorView()
}
