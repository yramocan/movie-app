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

                guard let movies = moviesResponse.results else {
                    let userInfo: [String: Any] = [
                        NSLocalizedDescriptionKey: NSLocalizedString("No Movies", value: "Movies not found", comment: "")
                    ]

                    let error = NSError(domain: "movieDB", code: -1, userInfo: userInfo)
                    completion(.failure(error))

                    return
                }

                completion(.success(movies))
            } catch let error {
                completion(.failure(error))
            }
        }
    }

    func imageURL(for posterPath: String) -> URL? {
        return URL(string: "https://image.tmdb.org/t/p/w500" + posterPath)
    }
}

enum MovieListType {
    case nowPlaying, popular, topRated, upcoming
}

enum MovieServiceResult<T> {
    case success(T)
    case failure(Error)
}
