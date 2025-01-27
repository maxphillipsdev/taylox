import Foundation

@MainActor
class Lox {
    static var hadError: Bool = false

    public static func runFile(file: String) {
        // todo: error handlign
        let contents = try! String(contentsOfFile: file, encoding: .utf8)
        run(input: contents)
    }

    public static func runPrompt() {
        while true {
            Swift.print("> ", terminator: "")
            guard let line = readLine() else {
                exit(0)
            }
            run(input: line)
        }
    }

    static func run(input: String) {
        let scanner = Scanner(input)
        let tokens = scanner.scanTokens()

        for token in tokens {
            Swift.print(token)
        }
    }
}
