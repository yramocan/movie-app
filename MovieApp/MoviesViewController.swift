//
//  MoviesViewController.swift
//  MovieApp
//

import UIKit

final class MoviesViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet private var headerTextLabel: UILabel!
    @IBOutlet private var subHeaderTextLabel: UILabel!
    @IBOutlet private var movieCategoryTabBar: UITabBar!

    // MARK: Properties
    private let viewModel = MoviesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self

        setUpMovieCategoryTabBar()

        viewModel.getNowPlaying()
    }

    private func setUpMovieCategoryTabBar() {
        movieCategoryTabBar.delegate = self
        movieCategoryTabBar.selectedItem = movieCategoryTabBar.items?.first

        headerTextLabel.text = "Now Playing"
        subHeaderTextLabel.text = "Movies Out Currently"
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
        DispatchQueue.main.async { [unowned self] in
            guard let tabBarItemIndex = tabBar.items?.index(of: item) else { return }

            switch tabBarItemIndex {
            case 0:
                self.headerTextLabel.text = "Now Playing"
                self.subHeaderTextLabel.text = "Current Flicks"
            case 1:
                self.headerTextLabel.text = "Popular Movies"
                self.subHeaderTextLabel.text = "In the Spotlight"
            case 2:
                self.headerTextLabel.text = "Top Rated"
                self.subHeaderTextLabel.text = "Critically Acclaimed"
            case 3:
                self.headerTextLabel.text = "Upcoming"
                self.subHeaderTextLabel.text = "Hitting Theaters Soon"
            default:
                return
            }
        }
    }
}
