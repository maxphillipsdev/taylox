class Environment {
    private var values: [String: Literal?] = [String: Literal?]()
    var enclosing: Environment?

    init(_ parent: Environment?) {
        enclosing = parent
    }

    func get(_ name: Token) throws(RuntimeError) -> Literal? {
        guard let value = values[name.lexeme] else {
            throw RuntimeError(message: "Undefined variable '\(name.lexeme)'.", token: name)
        }
        return value
    }

    func define(_ name: Token, _ value: Literal?) {
        values[name.lexeme] = value
    }

    func assign(_ name: Token, _ value: Literal?) throws(RuntimeError) {
        if values[name.lexeme] == nil {
            throw RuntimeError(message: "Undefined variable '\(name.lexeme)'.", token: name)
        }

        values[name.lexeme] = value
    }
}
