import Foundation

@MainActor
class Lox {
    public static func runFile(file: String) {
        do {
            let contents = try String(contentsOfFile: file, encoding: .utf8)
            run(input: contents)
        } catch {
            Swift.print("Failed to read source file '\(file)': \(error.localizedDescription)")
        }
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
        do {
            let scanner = Scanner(input)
            let tokens = try scanner.scanTokens()

            let parser = Parser(tokens)
            let expression = try parser.parse()

            guard let unwrapped = expression else {
                return
            }

            let interpreter = Interpreter()
            guard let value = try interpreter.evaluate(unwrapped) else { return }
            Swift.print(value)
        } catch let error as ScannerError {
            Lox.scannerError(line: error.line, message: error.message)
        } catch let error as ParserError {
            Lox.parserError(token: error.token, message: error.message)
        } catch let error as RuntimeError {
            Lox.runtimeError(error)
        } catch {
            fatalError("Wtf?")
        }
    }
}
