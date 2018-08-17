//
//  MovieRouter.swift
//  MovieApp
//

enum MovieRouter: EndpointRouter {
    case getNowPlaying

    var components: RequestComponents {
        switch self {
        case .getNowPlaying:
            return (.get, "/movie/now_playing", nil)
        }
    }
}
