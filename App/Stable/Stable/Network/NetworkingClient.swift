//
//  NetworkingClient.swift
//  Stable
//
//  Created by Lee Burrows on 24/04/2025.
//

import Foundation

final class NetworkingClient {

    private let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func getProfile() async throws -> Profile {
        let urlString = "https://fintechtitans-fastapi.azurewebsites.net/users/b2c-object-id-456"

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let (data, response) = try await urlSession.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(Profile.self, from: data)
    }
}
