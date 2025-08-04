//
//  ExpCalculatorView.swift
//  Lolz's DnD Helper
//
//  Created by Alberto Halim Limantoro on 04/08/25.
//

import SwiftUI

public struct ExpCalculatorView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var players: [Player] = []
    @State private var tasks: [ExpTask] = []
    @State private var currentPlayerIndex: Int = 0
    
    public var body: some View {
        NavigationView {
            VStack {
                if players.isEmpty {
                    Text("No players found. Please add a character first.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    playerHeader
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
    
    private func taskRow(for task: ExpTask) -> some View {
        HStack {
            let isCompletedBinding = Binding<Bool>(
                get: {
                    return players[currentPlayerIndex].completedTasks[task.id, default: false]
                },
                set: { isCompleted in
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
