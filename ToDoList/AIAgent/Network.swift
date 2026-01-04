//
//  Network.swift
//  ToDoList
//
//  Created by Александр Анамагулов on 04.01.2026.
//

import UIKit

class Network{
    
    func sendReq(questions: String,completion: @escaping(String?) -> Void){
        guard let url = URL(string: "https://bothub.chat/api/v2/openai/v1/responses") else
        {
            print (URLError.badURL)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImFjNGQ0OTg3LTEyYzYtNGY0ZC04ZDY0LWQyODY4MmZjM2M2NyIsImlzRGV2ZWxvcGVyIjp0cnVlLCJpYXQiOjE3NjQ2OTExMzQsImV4cCI6MjA4MDI2NzEzNH0.zLNfYjn69apAN0f2kMq4LGOe-VLw77cjxqvTySivFCs", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = RequestBody(model: "gpt-4.1-mini",
                                  input: questions,
                                  maxOutputTokens: 9000)
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else{
                print("Ошибка")
                return
            }
            
            guard let data,
                  let response = try? JSONDecoder().decode(AnswerAI.self, from: data),
                  let answer = response.outputText else {
                    completion(nil)
                    return
            }
            DispatchQueue.main.async{
                completion(answer)
            }
            
        }.resume()
        
    }
}
