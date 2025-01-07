import Foundation
import Combine

class MovieDataServiceViewModel {
    // MARK: - Types
    struct MovieSection: Equatable {
        let movieName: String
        var tickets: [MovieTicket]
    }
    
    
    
    // MARK: - Properties
    private let ticketService: MovieTicketServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // Published properties for UI binding
    let movieSections = CurrentValueSubject<[MovieSection], Never>([])
    let isLoading = CurrentValueSubject<Bool, Never>(false)
    let errorMessage = CurrentValueSubject<String?, Never>(nil)
    
    // MARK: - Initialization
    init(ticketService: MovieTicketServiceProtocol) {
        self.ticketService = ticketService
    }
    
    // MARK: - Public Methods
    func fetchTickets() {
        isLoading.send(true)
        
        Task {
            do {
                let tickets = try await ticketService.fetchTickets()
                await MainActor.run {
                    self.processTickets(tickets)
                    self.isLoading.send(false)
                }
            } catch {
                await MainActor.run {
                    self.errorMessage.send(error.localizedDescription)
                    self.isLoading.send(false)
                }
            }
        }
    }
    
    func deleteTicket(at indexPath: IndexPath) async throws {
        let ticket = movieSections.value[indexPath.section].tickets[indexPath.row]
        try await ticketService.deleteTicket(ticket)
        await fetchTickets()
    }
    
    func updateTicket(_ ticket: MovieTicket, at indexPath: IndexPath) async throws {
        try await ticketService.updateTicket(ticket)
        await fetchTickets()
    }
    
    // MARK: - Private Methods
    private func processTickets(_ tickets: [MovieTicket]) {
        // 按電影名稱分組
        let groupedTickets = Dictionary(grouping: tickets) { $0.movieName }
        
        // 轉換為 MovieSection 數組並排序
        let sections = groupedTickets.map { movieName, tickets in
            let sortedTickets = tickets.sorted { first, second in
                if first.showDate == second.showDate {
                    return first.showTime < second.showTime
                }
                return first.showDate < second.showDate
            }
            return MovieSection(movieName: movieName, tickets: sortedTickets)
        }.sorted { $0.movieName < $1.movieName }
        
        movieSections.send(sections)
    }
}

