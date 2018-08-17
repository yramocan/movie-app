//
//  MoviesViewController.swift
//  MovieApp
//

import UIKit

final class MoviesViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet private var headerView: UIView!
    @IBOutlet private var headerTextLabel: UILabel!
    @IBOutlet private var subHeaderTextLabel: UILabel!
    @IBOutlet private var movieCategoryTabBar: UITabBar!
    @IBOutlet private var moviesTableView: UITableView!

    // MARK: Properties
    private let viewModel = MoviesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self

        registerNibs()

        configureHeaderView()

        setUpMoviesTableView()
        setUpMovieCategoryTabBar()

        viewModel.getMovies(type: .nowPlaying)
    }

    private func configureHeaders(with headerText: String, and subHeaderText: String) {
        DispatchQueue.main.async { [unowned self] in
            self.headerTextLabel.text = headerText
            self.subHeaderTextLabel.text = subHeaderText
        }
    }

    private func configureHeaderView() {
        headerView.layer.addBorder(edge: .bottom, color: .purpleColor, thickness: 8.0)
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
            configureHeaders(with: "Now Playing", and: "Current Flicks")
            viewModel.getMovies(type: .nowPlaying)
        case 1:
            configureHeaders(with: "Popular Movies", and: "In the Spotlight")
            viewModel.getMovies(type: .popular)
        case 2:
            configureHeaders(with: "Top Rated", and: "Critically Acclaimed")
            viewModel.getMovies(type: .topRated)
        case 3:
            configureHeaders(with: "Upcoming", and: "Hitting Theaters Soon")
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

        cell.movieTitleLabel.text = viewModel.movies[indexPath.row].title
        cell.movieOverviewLabel.text = viewModel.movies[indexPath.row].overview
//        cell.posterImageView

        return cell
    }
}

extension MoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.00
    }
}
