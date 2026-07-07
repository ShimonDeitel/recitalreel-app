import Foundation

struct Performance: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var venue: String
    var note: String
    var date: Date = Date()
}
