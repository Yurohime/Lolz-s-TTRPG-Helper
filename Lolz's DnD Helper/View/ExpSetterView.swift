//
//  ExpSetter.swift
//  Lolz's DnD Helper
//
//  Created by Alberto Halim Limantoro on 04/08/25.
//

import SwiftUI

public struct ExpSetterView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State private var tasks: [ExpTask] = []
    @State private var isAddingTask = false
    @State private var newTaskName = ""
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if isAddingTask {
                    VStack {
                        TextField("Enter task name", text: $newTaskName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
                        Button(action: addTask) {
                            Text("Save Task")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .padding([.horizontal, .bottom])
                        .disabled(newTaskName.isEmpty)
                    }
                    .padding(.top)
                    .background(Color(.systemGroupedBackground))
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                List {
                    ForEach($tasks) { $task in
                        HStack {
                            Text(task.name)
                            Spacer()
                            // Stepper to easily adjust the EXP value
                            Stepper(value: $task.expValue, in: 0...10000, step: 50) {
                                Text("\(task.expValue) EXP")
                            }
                        }
                    }
                    .onDelete(perform: deleteTask)
                }
                .listStyle(InsetGroupedListStyle())
                
            }
            .navigationTitle("Set Task EXP")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        // Save changes before going back
                        SaveManager.shared.save(tasks: tasks)
                        viewRouter.currentPage = "menu"
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            isAddingTask.toggle()
                            newTaskName = ""
                        }
                    }) {
                        Image(systemName: isAddingTask ? "xmark.circle.fill" : "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .onAppear {
                self.tasks = SaveManager.shared.loadTasks()
            }
            // Save data when the app moves to the background
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
                SaveManager.shared.save(tasks: tasks)
            }
        }
    }
    
    // MARK: - Functions
    
    private func addTask() {
        let newTask = ExpTask(id: UUID(), name: newTaskName, expValue: 100)
        tasks.append(newTask)
        newTaskName = ""
        withAnimation {
            isAddingTask = false
        }
        // No need to save here, will be saved on exit or backgrounding
    }
    
    private func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
}

struct ExpSetterView_Previews: PreviewProvider {
    static var previews: some View {
        ExpSetterView()
            .environmentObject(ViewRouter())
    }
}

