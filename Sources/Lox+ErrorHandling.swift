import Foundation

extension Lox {
    static func error(line: Int, message: String) {
        report(line: line, location: "", message: message)
    }

    static func error(token: Token, message: String) {
        if token.type == .EOF {
            report(line: token.line, location: " at end", message: message)
        } else {
            report(line: token.line, location: " at '", message: "\(token.lexeme)'\(message)")
        }
    }

    private static func report(line: Int, location: String, message: String) {
        Swift.print("[line \(line)] Error \(location): \(message)")
        Lox.hadError = true
    }
}
