//
//  DataController.swift
//  icalories
//
//  Created by Alexandr Bahno on 28.06.2023.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "FoodModel")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Failde to load data: \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Data saved")
        } catch {
            print("Couldnt save the data: \(error.localizedDescription)")
        }
    }
    
    func addFood(name: String, calories: Double, grams: Double, context: NSManagedObjectContext) {
        let food = Food(context: context)
        food.id = UUID()
        food.date = Date()
        food.name = name
        food.calories = calories
        food.grams = grams
        
        save(context: context)
    }
    
    func editFood(food: Food, name: String, calories: Double, grams: Double, context: NSManagedObjectContext) {
        food.date = Date()
        food.name = name
        food.calories = calories
        food.grams = grams
        
        save(context: context)
    }
}
