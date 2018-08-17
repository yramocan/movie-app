//
//  ViewController.swift
//  MovieApp
//

import UIKit

final class ViewController: UIViewController {
    private let viewModel = MoviesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        viewModel.getNowPlaying()
    }
}

extension ViewController: MoviesViewModelDelegate {
    func didEncounterError(_ error: Error) {
        let alertController = UIAlertController(title: "MovieApp Error",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)

        self.present(alertController, animated: true, completion: nil)
    }

    func didRetrieveMovies() {
        print("Success")
        print("Movie Count: \(viewModel.movies.count)")
    }
}
