//
//  MoviesViewModel.swift
//  MovieApp
//

protocol MoviesViewModelDelegate: AnyObject {
    func didEncounterError(_ error: Error)
    func didRetrieveMovies()
}

final class MoviesViewModel {
    weak var delegate: MoviesViewModelDelegate?

    var movies: [Movie] = []

    private let movieService: MovieService

    init(movieService: MovieService = MovieService.shared) {
        self.movieService = movieService
    }

    func getMovies(type: MovieListType) {
        movieService.getMovies(type: type) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                self?.delegate?.didRetrieveMovies()
            case .failure(let error):
                self?.delegate?.didEncounterError(error)
            }
        }
    }
}
