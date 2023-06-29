//
//  AddFoodView.swift
//  icalories
//
//  Created by Alexandr Bahno on 28.06.2023.
//

import SwiftUI

struct AddFoodView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @Environment (\.dismiss) var dismiss
    
    @State var food: Food_Json = Food_Json(name: "", calories: 0, serving_size_g: 0)
    @State private var grams: Double = 0
    @State private var query: String = ""
    
    var body: some View {
        Form {
            Section {
                TextField("Food", text: $query)
                
                VStack {
                    Text("Gram: \(Int(grams))")
                    Slider(value: $grams, in: 0...1500, step: 5)
                }
                .padding()
                
                HStack {
                    Spacer()
                    Button("Submit") {
                        getNutrition()
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                            dismiss()
                        }
                    }
                    Spacer()
                }
            }
        }
    }
    
    func getNutrition() {
        Api().loadData(query: "\(Int(self.grams))g \(self.query)") { foods in
            self.food = foods.first!
            DataController().addFood(name: food.name.capitalized, calories:food.calories, grams: food.serving_size_g, context: managedObjContext)
        }
    }
}

struct AddFoodView_Previews: PreviewProvider {
    static var previews: some View {
        AddFoodView()
    }
}
