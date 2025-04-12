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
            hadError = false
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

        let parser = Parser(tokens)
        let expression = parser.parse()

        if hadError {
            return
        }

        guard let unwrapped = expression else {
            return
        }

        let printer = AstPrinter()
        Swift.print(printer.print(unwrapped))

        let interpreter = Interpreter()
        Swift.print(interpreter.evaluate(unwrapped)?.description)
    }
}
