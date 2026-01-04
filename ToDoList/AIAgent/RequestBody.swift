//
//  RequestBody.swift
//  ToDoList
//
//  Created by Александр Анамагулов on 04.01.2026.
//

import Foundation

struct RequestBody: Codable{
    let model: String
    let input: String
    let maxOutputTokens: Int
}
enum CodingKeys: String,CodingKey{
    case model
    case input
    case maxOutputTokens = "max_output_tokens"
}

struct AnswerAI: Decodable{
    let outputText: String?
    
    private enum CodingKeys: String, CodingKey {
        case outputText = "output_text"
    }
    
}


