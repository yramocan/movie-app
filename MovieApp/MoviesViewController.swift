//
//  MoviesViewController.swift
//  MovieApp
//

import UIKit

final class MoviesViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet private var movieCategoryTabBar: UITabBar!

    // MARK: Properties
    private let viewModel = MoviesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        movieCategoryTabBar.delegate = self
        viewModel.delegate = self
        viewModel.getNowPlaying()
    }
}

extension MoviesViewController: MoviesViewModelDelegate {
    func didEncounterError(_ error: Error) {
        let alertController = UIAlertController(title: "MovieApp Error",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)

        self.present(alertController, animated: true, completion: nil)
    }

    func didRetrieveMovies() {
        DispatchQueue.main.async { [unowned self] in
            print("Success")
            print("Movie Count: \(self.viewModel.movies.count)")
        }
    }
}

extension MoviesViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let tabBarItemIndex = tabBar.items?.index(of: item) else { return }

        switch tabBarItemIndex {
        case 0:
            print("Now Playing")
        case 1:
            print("Popular")
        case 2:
            print("Top Rated")
        case 3:
            print("Upcoming")
        default:
            return
        }
    }
}
