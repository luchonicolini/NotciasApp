//
//  NetworkError.swift
//  NotciasApp
//
//  Created by Luciano Nicolini on 04/07/2024.
//

import Foundation

enum NetworkError: String, Error {
    case invalidURL = "The URL provided was invalid."
    case invalidResponse = "The response from the server was invalid."
    case invalidData = "The data received from the server was invalid."
}
