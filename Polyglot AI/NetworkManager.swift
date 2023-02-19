//
//  NetworkManager.swift
//  Polyglot AI
//
//  Created by Alex Paul on 2/12/23.
//

import Foundation
import OpenAISwift


class NetworkManager{
    static let shared = NetworkManager()
    
    @frozen enum Constants{
        static let key = "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"
    }
    
    
    private var client: OpenAISwift?
    
    private init() {}
    
    func setUp(){
        self.client = OpenAISwift(authToken: Constants.key)
    }
    func getResponse(input: String, completion: @escaping (Result<String, Error>) -> Void) {
        let prompt = """
            translate from English to Nigerian Pidgin:

            \(input)

            Output:
            """

        
        client?.sendCompletion(with: prompt, model: .gpt3(.davinci), maxTokens: 60) { result in
            switch result {
            case .success(let response):
                let output = response.choices.first?.text ?? ""
                print(response)
                completion(.success(output))
            case .failure(let error):
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
    }
    
    
    
}
