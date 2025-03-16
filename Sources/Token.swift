import Foundation

struct Token: CustomStringConvertible {
    var type: TokenType
    var lexeme: String
    var literal: CustomStringConvertible?
    var line: Int
    var description: String {
        "\(type) \(lexeme) \(literal ?? "null")"
    }
}

