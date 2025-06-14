class Environment {
    private var values: [String: Literal?] = [String: Literal?]()
    var enclosing: Environment?

    init(enclosing: Environment?) {
        self.enclosing = enclosing
    }

    func get(_ name: Token) throws(RuntimeError) -> Literal? {
        if let value = values[name.lexeme] {
            return value
        }

        if let enclosing = enclosing {
            return try enclosing.get(name)
        }

        throw RuntimeError(message: "Undefined variable '\(name.lexeme)'.", token: name)
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
