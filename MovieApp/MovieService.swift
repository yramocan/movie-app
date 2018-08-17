//
//  MovieService.swift
//  MovieApp
//

import Alamofire

final class MovieService {
    static let shared = MovieService()

    func getNowPlaying(completion: @escaping (MovieServiceResult<[Movie]>) -> Void) {
        let request = Alamofire.request(MovieRouter.getNowPlaying)

        request.responseData { response in
            guard let data = response.result.value else {
                let error = NSError(domain: "movieDB", code: -1, userInfo: nil)
                completion(.failure(error))

                return
            }

            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

                let moviesResponse = try jsonDecoder.decode(MoviesResponse.self, from: data)

                completion(.success(moviesResponse.results))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
}

enum MovieServiceResult<T> {
    case success(T)
    case failure(Error)
}
