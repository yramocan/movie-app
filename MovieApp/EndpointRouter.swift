//
//  EndpointRouter.swift
//  MovieApp
//

import Alamofire

protocol EndpointRouter: URLRequestConvertible {
    typealias RequestComponents = (method: HTTPMethod, path: String, params: Parameters?)

    var components: RequestComponents { get }
}

extension EndpointRouter {
    func asURLRequest() throws -> URLRequest {
        let url = try "https://api.themoviedb.org/3".asURL()

        // TODO: Enter your API key for TheMovieDB
        let apiKey = ""

        var urlRequest = URLRequest(url: url.appendingPathComponent(components.path + "?api_key=" + apiKey))

        urlRequest.httpMethod = components.method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        let requestEncoder: ParameterEncoding = URLEncoding.queryString

        return try requestEncoder.encode(urlRequest, with: components.params)
    }
}
