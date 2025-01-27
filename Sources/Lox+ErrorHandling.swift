import Foundation

extension Lox {
    static func error(line: Int, message: String) {
        report(line: line, location: "", message: message)
    }

    private static func report(line: Int, location: String, message: String) {
        Swift.print("[line \(line)] Error \(location): \(message)")
        Lox.hadError = true
    }
}
