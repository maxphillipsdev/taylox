import Foundation

class Lox {
    private let interpreter: Interpreter

    init() {
        interpreter = Interpreter()
    }

    public func runFile(file: String) {
        do {
            let contents = try String(contentsOfFile: file, encoding: .utf8)
            _ = run(input: contents)
        } catch {
            Swift.print("Failed to read source file '\(file)': \(error.localizedDescription)")
        }
    }

    public func runPrompt() {
        while true {
            Swift.print("> ", terminator: "")
            guard let line = readLine() else {
                exit(0)
            }
            if let expr = run(input: line) {
                Swift.print(expr)
            }
        }
    }

    func run(input: String) -> String? {
        do {
            let scanner = Scanner(input)
            let tokens = try scanner.scanTokens()

            let parser = Parser(tokens)
            let statements = try parser.parse()

            guard let unwrapped = statements else {
                return nil
            }

            return try interpreter.interpret(unwrapped)
        } catch let error as ScannerError {
            Lox.scannerError(line: error.line, message: error.message)
        } catch let error as ParserError {
            Lox.parserError(token: error.token, message: error.message)
        } catch let error as RuntimeError {
            Lox.runtimeError(error)
        } catch {
            fatalError("Wtf?")
        }
        return nil
    }
}
