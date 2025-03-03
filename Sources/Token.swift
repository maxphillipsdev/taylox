import Foundation

struct Token: CustomStringConvertible {
    var type: TokenType
    var lexeme: String
    var literal: Any?
    var line: Int
    var description: String {
        "\(type) \(lexeme) \(literal ?? "null")"
    }
}

