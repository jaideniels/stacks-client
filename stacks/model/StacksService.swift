//
//  StacksService.swift
//  stacks
//
//  Created by jaydan on 12/9/21.
//

import Foundation
import Security

let baseUrl = "https://stacks-tpzmh.ondigitalocean.app/v1/"
// let baseUrl = "http://192.168.1.28:5000/v1/"

class StacksService {
    
    static func setToken(token:String) {
        let data = token.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : "com.smashcards.stacks.token",
            kSecValueData as String   : data! ] as [String : Any]

        SecItemDelete(query as CFDictionary)

        SecItemAdd(query as CFDictionary, nil)
    }
    
    private static func getToken() -> String? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : "com.smashcards.stacks.token",
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]

        var data: AnyObject? = nil


        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &data)

        if status == noErr {
            let str = String(decoding: data as! Data, as: UTF8.self)
            return str
        } else {
            return nil
        }
    }
    
    static func loadData(completion:@escaping ([Stack]?) -> ()) {
        
        let url = URL(string: baseUrl + "stacks/")
        
        var request : URLRequest
        
        if let token = getToken()
        {
            request = URLRequest(url: url!)
            request.setValue(" Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "accept")
        }
        else
        {
            completion(nil)
            return
        }
            
        URLSession.shared.dataTask(with: request) { data, response, error in
            var stacks: [Stack]? = nil
            
            do
            {
                if let bangData = data {
                    stacks = try JSONDecoder().decode([Stack].self, from: bangData)
                }
            }
            catch
            {
                print("\(error)")
            }

            DispatchQueue.main.async
            {
                completion(stacks)
            }
        }.resume()
    }
    
    static func addCard(stack: Stack, card: Card, completion:@escaping (Card?) -> ()) {
        let url = URL(string: baseUrl + "stacks/\(stack.id)/cards")
        
        var request : URLRequest
        
        if let token = getToken()
        {
            request = URLRequest(url: url!)
            request.setValue(" Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONEncoder().encode(card)
        }
        else
        {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            var card: Card? = nil
            
            do
            {
                if let bangData = data {
                    card = try JSONDecoder().decode(Card.self, from: bangData)
                }
            }
            catch
            {
            }

            DispatchQueue.main.async
            {
                completion(card)
            }
        }.resume()
    }
    
    static func patchCard(stack: Stack, card: Card, completion:@escaping (Card?) -> ()) {
        let url = URL(string: baseUrl + "stacks/\(stack.id)/cards")
        
        var request : URLRequest
        
        if let token = getToken()
        {
            request = URLRequest(url: url!)
            request.setValue(" Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "PATCH"
            request.addValue("application/json", forHTTPHeaderField: "accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONEncoder().encode(card)
        }
        else
        {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            var card: Card? = nil
            
            do
            {
                if let bangData = data {
                    card = try JSONDecoder().decode(Card.self, from: bangData)
                }
            }
            catch
            {
            }

            DispatchQueue.main.async
            {
                completion(card)
            }
        }.resume()
    }

    static func putScore(score: Score, completion:@escaping (Score?) -> ()) {
        let url = URL(string: baseUrl + "scores")
        
        var request : URLRequest
        
        if let token = getToken()
        {
            request = URLRequest(url: url!)
            request.setValue(" Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONEncoder().encode(score)
        }
        else
        {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            var score: Score? = nil
            
            do
            {
                if let bangData = data {
                    score = try JSONDecoder().decode(Score.self, from: bangData)
                }
            }
            catch
            {
            }

            DispatchQueue.main.async
            {
                completion(score)
            }
        }.resume()
    }

    static func getScores(completion:@escaping ([Score]?) -> ()) {
        
        let url = URL(string: baseUrl + "scores")
        
        var request : URLRequest
        
        if let token = getToken()
        {
            request = URLRequest(url: url!)
            request.setValue(" Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "accept")
        }
        else
        {
            completion(nil)
            return
        }
            
        URLSession.shared.dataTask(with: request) { data, response, error in
            var scores: [Score]? = nil
            
            do
            {
                if let bangData = data {
                    scores = try JSONDecoder().decode([Score].self, from: bangData)
                }
            }
            catch
            {
                print("\(error)")
            }

            DispatchQueue.main.async
            {
                completion(scores)
            }
        }.resume()
    }

}
