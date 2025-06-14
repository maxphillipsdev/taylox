class Interpreter {
    var environment: Environment = Environment(enclosing: nil)

    func interpret(_ statements: [Stmt]) throws(RuntimeError) -> String? {
        var result: String?
        for statement in statements {
            result = try execute(statement)
        }

        return result
    }

    private func execute(_ root: Stmt) throws(RuntimeError) -> String? {
        switch root {
        case .Expr(let expr):
            let value = try evaluate(expr)

            // return a string version for use in REPL-mode.
            return stringify(value)
        case .Print(let expr):
            let value = try evaluate(expr)
            Swift.print(stringify(value))
            return nil
        case .VarDecl(let name, let initializer):
            guard let expr = initializer else {
                environment.define(name, nil)
                return nil
            }
            let value = try evaluate(expr)
            environment.define(name, value)
            return nil
        case .Block(let stmts):
            try executeBlock(stmts, environment: Environment(enclosing: environment))
            return nil
        case .If(let condition, let thenBranch, let elseBranch):
            if isTruthy(try evaluate(condition)) {
                return try execute(thenBranch)
            } else if let elseBranch = elseBranch {
                return try execute(elseBranch)
            }
            return nil
        }
    }

    private func stringify(_ value: Literal?) -> String {
        guard let value = value else { return "nil" }
        switch value {
        case .Float(let value):
            let text = String(value)
            // print integral values as integers
            return text.hasSuffix(".0") ? String(text.dropLast(2)) : text
        case .String(let value):
            return value
        case .Bool(let value):
            return value.description
        }
    }

    private func executeBlock(_ statements: [Stmt], environment: Environment) throws(RuntimeError) {
        let previous = self.environment

        self.environment = environment

        for statement in statements {
            try execute(statement)
        }

        self.environment = previous
    }

    private func evaluate(_ root: Expr) throws(RuntimeError) -> Literal? {
        switch root {
        case .Literal(let value):
            guard let value = value else {
                return nil
            }
            return value
        case .Grouping(let expr):
            return try evaluate(expr)
        case .Variable(let name):
            return try environment.get(name)
        case .Assignment(let name, let valueExpr):
            let value = try evaluate(valueExpr)
            try environment.assign(name, value)
            return value
        case .Unary(let op, let right):
            let right = try evaluate(right)

            switch op.type {
            case .MINUS:
                guard case .Float(let right) = right else {
                    throw RuntimeError(message: "Operand must be a number.", token: op)
                }
                return Literal.Float(-(right))
            case .BANG:
                return Literal.Bool(!isTruthy(right))
            default:
                fatalError("Invalid unary expression...")
            }
        case .Binary(let left, let op, let right):
            let left = try evaluate(left)
            let right = try evaluate(right)

            switch op.type {
            case .GREATER:
                guard case .Float(let left) = left, case .Float(let right) = right else {
                    throw RuntimeError(message: "Operands must be a number.", token: op)
                }
                return Literal.Bool(left > right)
            case .GREATER_EQUAL:
                guard case .Float(let left) = left, case .Float(let right) = right else {
                    throw RuntimeError(message: "Operands must be a number.", token: op)
                }
                return Literal.Bool(left >= right)
            case .LESS:
                guard case .Float(let left) = left, case .Float(let right) = right else {
                    throw RuntimeError(message: "Operands must be a number.", token: op)
                }
                return Literal.Bool(left < right)
            case .LESS_EQUAL:
                guard case .Float(let left) = left, case .Float(let right) = right else {
                    throw RuntimeError(message: "Operands must be a number.", token: op)
                }
                return Literal.Bool(left <= right)
            case .EQUAL:
                return Literal.Bool(isEqual(left, right))
            case .BANG_EQUAL:
                return Literal.Bool(!isEqual(left, right))
            case .MINUS:
                guard case .Float(let left) = left, case .Float(let right) = right else {
                    throw RuntimeError(message: "Operands must be a number.", token: op)
                }
                return Literal.Float(left - right)
            case .SLASH:
                guard case .Float(let left) = left, case .Float(let right) = right else {
                    throw RuntimeError(message: "Operands must be a number.", token: op)
                }
                return Literal.Float(left / right)
            case .STAR:
                guard case .Float(let left) = left, case .Float(let right) = right else {
                    throw RuntimeError(message: "Operands must be a number.", token: op)
                }
                return Literal.Float(left * right)
            case .PLUS:
                if case .Float(let left) = left, case .Float(let right) = right {
                    return Literal.Float(left + right)
                }

                if case .String(let left) = left, case .String(let right) = right {
                    return Literal.String(left + right)
                }

                throw RuntimeError(
                    message: "Operands must be two numbers or two strings.", token: op)
            default:
                fatalError("Invalid binary expression...")
            }
        }
        return nil
    }

    private func isTruthy(_ literal: Literal?) -> Bool {
        guard case let .Bool(value) = literal else { return false }

        return value
    }

    private func isEqual(_ left: Literal?, _ right: Literal?) -> Bool {
        guard left != nil else {
            return right == nil
        }
        if case .Float(let left) = left, case .Float(let right) = right {
            return left == right
        }
        if case .String(let left) = left, case .String(let right) = right {
            return left == right
        }
        if case .Bool(let left) = left, case .Bool(let right) = right {
            return left == right
        }
        return false
    }

}
