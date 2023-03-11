//
//  NetworkManager.swift
//  Polyglot AI
//
//  Created by Alex Paul on 2/12/23.
//

import Foundation
enum HTTPError: Error {
    case invalidURL
    case invalidResponse(Data?, URLResponse?)
}

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://api.openai.com/v1/completions"
    private let apiHeaders = [
        "Content-Type": "application/json",
        "Authorization": "Bearer "
    ]
    private init() {}

    func getTranslation(input: String, completion: @escaping (Result<String, Error>) -> Void) {
        let parameters: [String: Any] = [
            "model": "text-davinci-003",
            "prompt": "Translate this into pidgin english nigeria \n\n\(input)\n",
            "temperature": 0.3,
            "max_tokens": 100,
            "top_p": 1,
            "frequency_penalty": 0,
            "presence_penalty": 0
        ]
        
        let url = URL(string: baseURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = apiHeaders
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let responseData = data else {
                completion(.failure(HTTPError.invalidResponse(data, response)))
                return
            }
            
            do {
                let message = try self.parseTextCompletionResponse(responseData)
                completion(.success(message))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    private func parseTextCompletionResponse(_ data: Data) throws -> String {
        print("Text completion response data: \(String(data: data, encoding: .utf8) ?? "")")
        
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        guard let choices = jsonObject?["choices"] as? [[String: Any]] else {
            throw HTTPError.invalidResponse(data, nil)
        }
        
        if choices.isEmpty {
            throw HTTPError.invalidResponse(data, nil)
        }
        
        guard let text = choices[0]["text"] as? String else {
            throw HTTPError.invalidResponse(data, nil)
        }
        
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
