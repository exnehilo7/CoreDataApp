//
//  ContentView.swift
//  CoreDataApp
//
//  Created by Hopp, Dan on 11/13/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    // For add-a-trip popup
    @State private var showingAlert = false
    @State private var name = ""
    
    
    @Environment(\.managedObjectContext) private var viewContext

    // Default app example
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Item>

    // Try my own fetch request and data
    @FetchRequest(sortDescriptors: []) private var trips: FetchedResults<Trip>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(trips) { item in
                    NavigationLink {
                        Text("\(item.name!)")
                        // Go to camera instead?
                    } label: {
                        HStack{
                            if item.complete {
                                Image(systemName: "checkmark")
                            }
                            Text(item.name!)
                        }.onTapGesture{ // Toggle complete(?)
                            if (item.complete == false) {
                                item.complete = true
                            } else {item.complete = false}
                        }
                    }
                }
                //.onDelete(perform: deleteItems) // Disable slide-to-delete
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    // Pop up a text field to add a Trip name
                    Button(action: showAlert) {
                        Label("Add Item", systemImage: "plus")
                    }
                    .alert("Enter a trip name", isPresented: $showingAlert) {
                        TextField("Trip Name", text: $name) .textInputAutocapitalization(.never)
                        Button("OK", action: addItem)
                        Button("Cancel", role: .cancel){}
                    } message: {
                        Text("The name must be unique.")
                    }
                }
            }
            Text("Select an item") // From app example code. Where does this show up?
        }
    }

    private func showAlert(){
        showingAlert.toggle()
    }
    
    private func addItem() {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.count > 0 {
            withAnimation {
                let newItem = Trip(context: viewContext)
                newItem.name = name
                
                if viewContext.hasChanges{
                    do {
                        try viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        print(nsError.userInfo)
                        print("private func addItem error \(error), \(error.localizedDescription)")
                    }
                    name = ""
                }
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { trips[$0] }.forEach(viewContext.delete)

            if viewContext.hasChanges{
                do {
                    try viewContext.save()
                } catch {
                    let nsError = error as NSError
                    print(nsError.userInfo)
                    print("private func deleteItems error \(error), \(error.localizedDescription)")
                }
            }
        }
    }
}

// Default app example
//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .short
//    formatter.timeStyle = .medium
//    return formatter
//}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
