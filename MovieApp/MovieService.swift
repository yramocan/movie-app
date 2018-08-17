//
//  MovieService.swift
//  MovieApp
//

import Alamofire

final class MovieService {
    static let shared = MovieService()

    func getMovies(type: MovieListType, completion: @escaping (MovieServiceResult<[Movie]>) -> Void) {
        var urlRequestConvertible: URLRequestConvertible {
            switch type {
            case .nowPlaying:
                return MovieRouter.getNowPlaying
            case .popular:
                return MovieRouter.getPopular
            case .topRated:
                return MovieRouter.getTopRated
            case .upcoming:
                return MovieRouter.getUpcoming
            }
        }

        let request = Alamofire.request(urlRequestConvertible)

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

enum MovieListType {
    case nowPlaying, popular, topRated, upcoming
}

enum MovieServiceResult<T> {
    case success(T)
    case failure(Error)
}
