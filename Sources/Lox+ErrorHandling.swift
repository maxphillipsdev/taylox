import Foundation

struct ScannerError: Error, @unchecked Sendable {
    let message: String
    let line: Int
}

struct ParserError: Error, @unchecked Sendable {
    let message: String
    let token: Token
}

struct RuntimeError: Error, @unchecked Sendable {
    let message: String
    let token: Token?
}

// TODO: These should print to stderr
extension Lox {
    static func scannerError(line: Int, message: String) {
        Swift.print(report(line: line, location: "", message: message))
    }

    static func parserError(token: Token, message: String) {
        var error = ""
        if token.type == .EOF {
            error = report(line: token.line, location: "at end", message: message)
        } else {
            error = report(line: token.line, location: "at '\(token.lexeme)'", message: message)
        }

        Swift.print(error)
    }

    static func runtimeError(_ error: RuntimeError) {
        Swift.print("[\(error.token!.line)] \(error.message)")
    }

    static func report(line: Int, location: String, message: String) -> String {
        "[\(line)] Error \(location): \(message)"
    }
}
