//
//  Food.swift
//  icalories
//
//  Created by Alexandr Bahno on 29.06.2023.
//

import Foundation

struct Food_Json: Codable, Identifiable {
    let id = UUID()
    var name: String
    var calories: Double
    var serving_size_g: Double
}

class Api: ObservableObject {
    @Published var foods = [Food_Json]()
    
    func loadData(query: String, completion: @escaping ([Food_Json]) -> ()) {
        print(query)
        let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: "https://api.api-ninjas.com/v1/nutrition?query=" + query!)!
        var request = URLRequest(url: url)
        request.setValue("HOGVKyhddr9RrBFPzFQEaA==rge8aeRulUiVjmaj", forHTTPHeaderField: "X-Api-Key")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to load data from API: \(error.localizedDescription)")
            }
            guard let data = data else { return }
            let foods = try! JSONDecoder().decode([Food_Json].self, from: data)
            print(foods)
            DispatchQueue.main.async {
                completion(foods)
            }
        }.resume()
    }
}
