//
//  APIResponse.swift
//  CodeLathe-Test
//
//  Created by Alex Marchant on 15/01/2021.
//

import Foundation

struct NetworkRequestError: Error {
    let error: Error?
    
    var localizedDescription: String {
        return error?.localizedDescription ?? "Network request error"
    }
}

struct ApiError: Error {
    let data: Data?
    let httpUrlResponse: HTTPURLResponse
}

struct ApiParseError: Error {
    static let code = 999
    
    let error: Error
    let httpUrlResponse: HTTPURLResponse
    let data: Data?
    
    var localizedDescription: String {
        return error.localizedDescription
    }
}

struct ApiResponse<T: Decodable> {
    let entity: T
    let httpUrlResponse: HTTPURLResponse
    let data: Data?
    
    init(data: Data?, httpUrlResponse: HTTPURLResponse) throws {
        do {
            self.entity = try JSONDecoder().decode(T.self, from: data ?? Data())
            self.httpUrlResponse = httpUrlResponse
            self.data = data
        } catch {
            throw ApiParseError(error: error, httpUrlResponse: httpUrlResponse, data: data)
        }
    }
}

struct VoidResponse: Decodable { }

extension NSError {
    static func createPraseError() -> NSError {
        return NSError(domain: "Alex-Marchant.CodeLathe-Test",
                       code: ApiParseError.code,
                       userInfo: [NSLocalizedDescriptionKey: "Parsing error occured"])
    }
}
