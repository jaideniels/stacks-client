//
//  StacksService.swift
//  stacks
//
//  Created by jaydan on 12/9/21.
//

import Foundation

class StacksService {
    static func loadData(token: String, completion:@escaping ([Stack]) -> ()) {
        
        let url = URL(string: "https://stacks-tpzmh.ondigitalocean.app/v1/stacks/")
        
        var request = URLRequest(url: url!)
        request.setValue(" Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            var stacks: [Stack]
            
            do
            {
                stacks = try JSONDecoder().decode([Stack].self, from: data!)
            }
            catch {
                stacks = [Stack]();
            }

            DispatchQueue.main.async
            {
                completion(stacks)
            }
        }.resume()
    }
}
