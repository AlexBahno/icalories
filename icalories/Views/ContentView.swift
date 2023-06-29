//
//  ContentView.swift
//  icalories
//
//  Created by Alexandr Bahno on 28.06.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: SortOrder.reverse)]) var foods: FetchedResults<Food>
    
    @State private var showingAddView = false
    var body: some View {
        NavigationStack {
            VStack (alignment: .leading) {
                Text("\(Int(totalCaloriesToday())) Kcal (Today)")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                List {
                    ForEach(foods) { food in
                        NavigationLink(destination: EditFoodView(food: food)) {
                            HStack {
                                VStack (alignment: .leading, spacing: 6) {
                                    Text(food.name!)
                                        .bold()
                                    
                                    Text("\(Int(food.calories))") +
                                        Text(" calories")
                                            .foregroundColor(.red)
                                }
                                Spacer()
                                Text((calcTimeSince(date: food.date!)))
                                    .foregroundColor(.gray)
                                    .italic()
                            }
                        }
                    }
                    .onDelete(perform: deleteFood)
                }
                .listStyle(.plain)
            }
            .navigationTitle("iCalories")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Add Food", systemImage: "plus.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddFoodView()
                    .presentationDetents([.fraction(0.35)])
            }
        }
    }
    
    private func totalCaloriesToday() -> Double {
        var caloriesToday: Double = 0
        for food in foods {
            if Calendar.current.isDateInToday(food.date!) {
                caloriesToday += food.calories
            }
        }
        return caloriesToday
    }
    
    private func deleteFood(offsets: IndexSet) {
        withAnimation {
            offsets.map {foods[$0]}.forEach(managedObjContext.delete)
            
            DataController().save(context: managedObjContext)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
