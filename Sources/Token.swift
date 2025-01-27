import Foundation

class Token: CustomStringConvertible {
    final var type: TokenType
    final var lexeme: String
    final var literal: Any?
    final var line: Int

    init(type: TokenType, lexeme: String, literal: Any?, line: Int) {
        self.type = type
        self.lexeme = lexeme
        self.literal = literal
        self.line = line
    }

    var description: String {
        "\(type) \(lexeme) \(literal ?? "null")"
    }
}

