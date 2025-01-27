import Foundation

extension Lox {
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
}
