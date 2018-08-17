//
//  MoviesViewController.swift
//  MovieApp
//

import SDWebImage
import UIKit

final class MoviesViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet private var headerView: UIView!
    @IBOutlet private var headerTextLabel: UILabel!
    @IBOutlet private var subHeaderTextLabel: UILabel!
    @IBOutlet private var movieCategoryTabBar: UITabBar!
    @IBOutlet private var moviesTableView: UITableView!

    // MARK: - Properties

    private let viewModel = MoviesViewModel()

    // MARK: - View Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self

        registerNibs()

        configureHeaderView(with: .moviePurpleColor)

        setUpMoviesTableView()
        setUpMovieCategoryTabBar()

        viewModel.getMovies(type: .nowPlaying)
    }

    // MARK: - Helper Methods

    private func configureHeaderLabels(with headerText: String, and subHeaderText: String) {
        DispatchQueue.main.async { [unowned self] in
            self.headerTextLabel.text = headerText
            self.subHeaderTextLabel.text = subHeaderText
        }
    }

    private func configureHeaderView(with borderColor: UIColor) {
        DispatchQueue.main.async { [unowned self] in
            self.headerView.layer.addBorder(edge: .bottom, color: borderColor, thickness: 8.0)
        }
    }

    private func reloadMovies() {
        moviesTableView.reloadData()
    }

    private func registerNibs() {
        moviesTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
    }

    private func scrollToTopOfTableView() {
        DispatchQueue.main.async { [unowned self] in
            self.moviesTableView.scrollToRow(at: IndexPath(row: 0, section: 0),
                                             at: UITableViewScrollPosition.top,
                                             animated: true)
        }
    }

    private func setUpMovieCategoryTabBar() {
        movieCategoryTabBar.delegate = self
        movieCategoryTabBar.selectedItem = movieCategoryTabBar.items?.first
    }

    private func setUpMoviesTableView() {
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
    }
}

// MARK: - MoviesViewModelDelegate Protocol Conformance

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
            self.reloadMovies()
            self.scrollToTopOfTableView()
        }
    }
}

// MARK: - UITabBarDelegate Protocol Conformance

extension MoviesViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let tabBarItemIndex = tabBar.items?.index(of: item) else { return }

        switch tabBarItemIndex {
        case 0:
            configureHeaderLabels(with: "Now Playing", and: "Current Flicks")
            configureHeaderView(with: .moviePurpleColor)
            viewModel.getMovies(type: .nowPlaying)
        case 1:
            configureHeaderLabels(with: "Popular Movies", and: "In the Spotlight")
            configureHeaderView(with: .movieRedColor)
            viewModel.getMovies(type: .popular)
        case 2:
            configureHeaderLabels(with: "Top Rated", and: "Critically Acclaimed")
            configureHeaderView(with: .movieGreenColor)
            viewModel.getMovies(type: .topRated)
        case 3:
            configureHeaderLabels(with: "Upcoming", and: "Hitting Theaters Soon")
            configureHeaderView(with: .movieOrangeColor)
            viewModel.getMovies(type: .upcoming)
        default:
            return
        }
    }
}

// MARK: - UITableViewDataSource Protocol Conformance

extension MoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell

        let movie = viewModel.movies[indexPath.row]

        cell.movieTitleLabel.text = movie.title
        cell.movieOverviewLabel.text = movie.overview

        let imageURL = viewModel.imageURL(for: movie.posterPath ?? "")

        cell.posterImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder-image.png"))

        return cell
    }
}

extension MoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.00
    }
}
