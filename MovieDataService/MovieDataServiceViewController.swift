import UIKit
import Combine

class MovieDataServiceViewController: UITableViewController {
    // MARK: - Properties
    private let viewModel: MovieDataServiceViewModel
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(ticketService: MovieTicketServiceProtocol) {
        self.viewModel = MovieDataServiceViewModel(ticketService: ticketService)
        super.init(style: .plain)
        tableView.register(MovieTicketCell.self, forCellReuseIdentifier: "MovieTicketCell")
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchTickets()
    }
    
    // MARK: - Setup
    private func setupTableView() {
        tableView.register(MovieTicketCell.self, forCellReuseIdentifier: "MovieTicketCell")
        tableView.rowHeight = 80
    }
    
    private func setupUI() {
        title = "Cinema Admin"
        view.backgroundColor = .systemBackground
        
        setupRefreshControl()
        setupNavigationBar()
        setupActivityIndicator()
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTicket)
        )
    }
    
    private func setupActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.movieSections
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.refreshControl?.endRefreshing()
                }
            }
            .store(in: &cancellables)
        
        viewModel.errorMessage
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] message in
                self?.showAlert(message: message)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    @objc private func refreshData() {
        viewModel.fetchTickets()
    }
    
    @objc private func addNewTicket() {
        // TODO: 實現添加新票券的功能
        showAlert(message: "新增票券功能即將推出")
    }
    
    // MARK: - Helper Methods
    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "提示",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "確定", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - UITableView DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.movieSections.value.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movieSections.value[section].tickets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTicketCell", for: indexPath) as! MovieTicketCell
        let ticket = viewModel.movieSections.value[indexPath.section].tickets[indexPath.row]
        cell.configure(with: ticket)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.movieSections.value[section].movieName
    }
    
    // MARK: - UITableView Delegate
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .systemGray6
        
        let label = UILabel()
        label.text = viewModel.movieSections.value[section].movieName
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 16),
            label.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -16),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let ticket = viewModel.movieSections.value[indexPath.section].tickets[indexPath.row]
        showAlert(message: "選擇了: \(ticket.movieName) - \(ticket.showTime)")
    }
}

