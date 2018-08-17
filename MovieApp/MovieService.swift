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

            guard let moviesResponse = try? JSONDecoder().decode(MoviesResponse.self, from: data) else {
                let error = NSError(domain: "movieDB", code: -1, userInfo: nil)
                completion(.failure(error))

                return
            }

            let movies = moviesResponse.results

            completion(.success(movies))
        }
    }
}

enum MovieServiceResult<T> {
    case success(T)
    case failure(Error)
}
