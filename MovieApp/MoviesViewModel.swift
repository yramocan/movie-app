//
//  MoviesViewModel.swift
//  MovieApp
//

protocol MoviesViewModelDelegate: AnyObject {
    func didRetrieveMovies()
}

struct MoviesViewModel {
    weak var delegate: MoviesViewModelDelegate?

    var movies: [Movie]

    private let movieService: MovieService

    init(movieService: MovieService = MovieService.shared) {
        self.movieService = movieService
    }

    func getNowPlaying() {
        movieService.getNowPlaying { result in
            if case .success(let movies) = result {
                self.movies = movies
                delegate?.didRetrieveMovies()
            }
        }
    }
}
