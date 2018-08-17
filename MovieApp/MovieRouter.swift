//
//  MovieRouter.swift
//  MovieApp
//

enum MovieRouter: EndpointRouter {
    case getNowPlaying, getPopular, getTopRated, getUpcoming

    var components: RequestComponents {
        switch self {
        case .getNowPlaying:
            return (.get, "/movie/now_playing")
        case .getPopular:
            return (.get, "/movie/popular")
        case .getTopRated:
            return (.get, "/movie/top_rated")
        case .getUpcoming:
            return (.get, "/movie/upcoming")
        }
    }
}
