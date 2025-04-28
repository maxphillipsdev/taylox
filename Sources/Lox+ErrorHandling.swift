import Foundation

struct ScannerError: Error, @unchecked Sendable {
    let message: String
    let line: Int
}

struct ParserError: Error, @unchecked Sendable{
    let message: String
    let token: Token
}

struct RuntimeError: Error, @unchecked Sendable {
    let message: String
    let token: Token
}

extension Lox {
    static func scannerError(line: Int, message: String) {
        report(line: line, location: "", message: message)
    }

    static func parserError(token: Token, message: String) {
        if token.type == .EOF {
            report(line: token.line, location: "at end", message: message)
        } else {
            report(line: token.line, location: "at '\(token.lexeme)'", message: message)
        }
    }

    static func runtimeError(_ error: RuntimeError) {
        Swift.print("[line \(error.token.line)] \(error.message)")
    }

    private static func report(line: Int, location: String, message: String) {
        Swift.print("[line \(line)] Error \(location): \(message)")
    }
}

