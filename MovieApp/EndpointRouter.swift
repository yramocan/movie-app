//
//  EndpointRouter.swift
//  MovieApp
//

import Alamofire

protocol EndpointRouter: URLRequestConvertible {
    typealias RequestComponents = (method: HTTPMethod, path: String)

    var components: RequestComponents { get }
}

extension EndpointRouter {
    // TODO: Enter your API key for TheMovieDB
    var apiKey: String {
        return ""
    }

    func asURLRequest() throws -> URLRequest {
        let url = try "https://api.themoviedb.org/3".asURL()

        var urlRequest = URLRequest(url: url.appendingPathComponent(components.path))

        urlRequest.httpMethod = components.method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        let requestEncoder: ParameterEncoding = URLEncoding.queryString

        return try requestEncoder.encode(urlRequest, with: ["api_key": apiKey])
    }
}
