import Foundation

struct Token: Value {
    var type: TokenType
    var lexeme: String
    var literal: Value?
    var line: Int
    var description: String {
        return "foo"
        // "\(type) \(lexeme) \(literal ?? "null")"
        guard let literal = literal else {
            return "nil"
        }

        if let literal = literal as? Float {
            return Int(literal).description
        }

        return literal.description
    }
}
