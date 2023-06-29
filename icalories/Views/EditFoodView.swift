//
//  EditFoodView.swift
//  icalories
//
//  Created by Alexandr Bahno on 28.06.2023.
//

import SwiftUI

struct EditFoodView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @Environment (\.dismiss) var dismiss
    
    var food: FetchedResults<Food>.Element
    
    @State private var name = ""
    @State private var grams: Double = 0
    
    @State var food_json: Food_Json = Food_Json(name: "", calories: 0, serving_size_g: 0)
    @State private var query: String = ""
    
    var body: some View {
        Form {
            Section {
                TextField("\(food.name!)", text: $query)
                    .onAppear {
                        query = food.name!
                        grams = food.grams
                    }
                VStack {
                    Text("Grams: \(Int(grams))")
                    Slider(value: $grams, in: 0...1500, step: 5)
                }
                .padding()
                
                HStack {
                    Spacer()
                    Button("Submit") {
                        getNutrition()
                    }
                    Spacer()
                }
            }
        }
    }
    
    func getNutrition() {
        Api().loadData(query: "\(Int(self.grams))g \(self.query)") { foods in
            self.food_json = foods.first!
            DataController().editFood(food: food, name: food_json.name, calories: food_json.calories, grams: food_json.serving_size_g, context: managedObjContext)
            dismiss()
        }
    }
    
}

