//
//  MoviesViewModel.swift
//  MovieApp
//

protocol MoviesViewModelDelegate: AnyObject {
    func didRetrieveMovies()
}

final class MoviesViewModel {
    weak var delegate: MoviesViewModelDelegate?

    var movies: [Movie]

    private let movieService: MovieService

    init(movieService: MovieService = MovieService.shared) {
        self.movieService = movieService
    }

    func getNowPlaying() {
        movieService.getNowPlaying { [weak self] result in
            if case .success(let movies) = result {
                self?.movies = movies
                self?.delegate?.didRetrieveMovies()
            }
        }
    }
}
