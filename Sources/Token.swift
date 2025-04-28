import Foundation

struct Token: CustomStringConvertible {
   let type: TokenType
   let lexeme: String
   let literal: Any?
   let line: Int
   var description: String {
        "\(type) \(lexeme) \(literal ?? "")"
    }
}

