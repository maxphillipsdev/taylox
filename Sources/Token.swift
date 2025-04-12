import Foundation

struct Token: Value {
    var type: TokenType
    var lexeme: String
    var literal: Value?
    var line: Int
    var description: String {
        "\(type) \(lexeme) \(literal ?? "null")"
    }
}

