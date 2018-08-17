//
//  MoviesResponse.swift
//  MovieApp
//

struct MoviesResponse: Decodable {
    let results: [Movie]?
}

struct Movie: Decodable {
    let adult: Bool?
    let backdropPath: String?
    let id: Int?
    let overview: String?
    let posterPath: String?
    let releaseDate: String?
    let title: String?
    let voteAverage: Float?
    let voteCount: Int?
}
