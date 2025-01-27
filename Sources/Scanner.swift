import Foundation

@MainActor
class Scanner {
    final var source: String
    final var tokens: [Token] = []
    var start = 0
    var current = 0
    var line = 1

    init(_ source: String) {
        self.source = source
    }

    func scanTokens() -> [Token] {
        while !isAtEnd() {
            start = current
            scanToken()
        }

        tokens.append(Token(type: .EOF, lexeme: "", literal: nil, line: line))
        return tokens
    }

    private func scanToken() {
        let c = advance()

        switch c {
        case "(": addToken(.LEFT_PAREN)
        case ")": addToken(.RIGHT_PAREN)
        case "{": addToken(.LEFT_BRACE)
        case "}": addToken(.RIGHT_BRACE)
        case ",": addToken(.COMMA)
        case ".": addToken(.DOT)
        case "-": addToken(.MINUS)
        case "+": addToken(.PLUS)
        case ";": addToken(.SEMICOLON)
        case "*": addToken(.STAR)
        case "/":
            if match("/") {
                while peek() != "\n" && !isAtEnd() {
                    _ = advance()
                }
            } else {
                addToken(.SLASH)
            }
        case " ":
            break
        case "\r":
            break
        case "\t":
            break
        case "\n":
            line += 1
        default:
            Lox.error(line: line, message: "Unexpected character: \(c)")
        }
    }

    private func advance() -> Character {
        // in jlox, this is done with a post-increment.
        // In swift land we need to index with the old value before incrementing.
        let old = source[current]
        current += 1
        return old
    }

    private func match(_ expected: Character) -> Bool {
        if isAtEnd() { return false }
        if source[current] != expected { return false }

        current += 1
        return true
    }

    private func peek() -> Character {
        if isAtEnd() { return "\0" }
        return source[current]
    }

    private func addToken(_ type: TokenType) { addToken(type, literal: nil) }

    private func addToken(_ type: TokenType, literal: Any?) {
        // todo: this substring sucks
        let text = source[start..<current]
        tokens.append(Token(type: type, lexeme: String(text), literal: literal, line: line))
    }

    private func isAtEnd() -> Bool {
        return current >= source.count
    }
}

// today we are not feeling swifty
// https://stackoverflow.com/questions/39676939/how-does-string-index-work-in-swift
extension StringProtocol {
    subscript(_ offset: Int) -> Element {
        self[index(startIndex, offsetBy: offset)]
    }

    subscript(_ range: Range<Int>) -> SubSequence {
        prefix(range.lowerBound + range.count).suffix(range.count)
    }
}
