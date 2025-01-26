@MainActor
class Lox {
    static var hadError: Bool = false

    public static func runFile(file: String) {
        // todo: error handlign
        let contents = try! String(contentsOfFile: file, encoding: .utf8)
        run(input: contents)
    }

    public static func runPrompt() {
        // TODO
    }

    private static func run(input: String) {

    }
}
