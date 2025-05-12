class Interpreter {
    let environment: Environment = Environment(nil)

    func interpret(_ statements: [Stmt]) throws(RuntimeError) -> String? {
        var result: String?
        for statement in statements {
            result = try execute(statement)
        }

        return result
    }

    private func execute(_ root: Stmt) throws(RuntimeError) -> String? {
        switch root {
        case .expr(let expr):
            let value = try evaluate(expr)

            // return a string version for use in REPL-mode.
            return stringify(value)
        case .print(let expr):
            let value = try evaluate(expr)
            Swift.print(stringify(value))
            return nil
        case .varDecl(let name, let initializer):
            guard let expr = initializer else {
                environment.define(name.lexeme, nil)
                return nil
            }
            let value = try evaluate(expr)
            environment.define(name.lexeme, value)
            return nil
        }
    }

    private func stringify(_ value: Literal?) -> String {
        guard let value = value else { return "nil" }
        switch value {
        case .float(let value):
            let text = String(value)
            // print integral values as integers
            return text.hasSuffix(".0") ? String(text.dropLast(2)) : text
        case .string(let value):
            return value
        case .bool(let value):
            return value.description
        }
    }

    private func evaluate(_ root: Expr) throws(RuntimeError) -> Literal? {
        switch root {
        case .literal(let value):
            guard let value = value else {
                return nil
            }
            return value
        case .grouping(let expr):
            return try evaluate(expr)
        case .variable(let name):
            return try environment.get(name)
        case .unary(let op, let right):
            let right = try evaluate(right)

            switch op.type {
            case .MINUS:
                guard case .float(let right) = right else {
                    throw RuntimeError(message: "Operand must be a number.", token: op)
                }
                return Literal.float(-(right))
            case .BANG:
                return Literal.bool(!isTruthy(right))
            default:
                fatalError("Invalid unary expression...")
            }
        case .binary(let left, let op, let right):
            let left = try evaluate(left)
            let right = try evaluate(right)

            switch op.type {
            case .GREATER:
                guard case .float(let left) = left, case .float(let right) = right else {
                    throw RuntimeError(message: "Operands must be a number.", token: op)
                }
                return Literal.bool(left > right)
            case .GREATER_EQUAL:
                guard case .float(let left) = left, case .float(let right) = right else {
                    throw RuntimeError(message: "Operands must be a number.", token: op)
                }
                return Literal.bool(left >= right)
            case .LESS:
                guard case .float(let left) = left, case .float(let right) = right else {
                    throw RuntimeError(message: "Operands must be a number.", token: op)
                }
                return Literal.bool(left < right)
            case .LESS_EQUAL:
                guard case .float(let left) = left, case .float(let right) = right else {
                    throw RuntimeError(message: "Operands must be a number.", token: op)
                }
                return Literal.bool(left <= right)
            case .EQUAL:
                return Literal.bool(isEqual(left, right))
            case .BANG_EQUAL:
                return Literal.bool(!isEqual(left, right))
            case .MINUS:
                guard case .float(let left) = left, case .float(let right) = right else {
                    throw RuntimeError(message: "Operands must be a number.", token: op)
                }
                return Literal.float(left - right)
            case .SLASH:
                guard case .float(let left) = left, case .float(let right) = right else {
                    throw RuntimeError(message: "Operands must be a number.", token: op)
                }
                return Literal.float(left / right)
            case .STAR:
                guard case .float(let left) = left, case .float(let right) = right else {
                    throw RuntimeError(message: "Operands must be a number.", token: op)
                }
                return Literal.float(left * right)
            case .PLUS:
                if case .float(let left) = left, case .float(let right) = right {
                    return Literal.float(left + right)
                }

                if case .string(let left) = left, case .string(let right) = right {
                    return Literal.string(left + right)
                }

                throw RuntimeError(
                    message: "Operands must be two numbers or two strings.", token: op)
            default:
                fatalError("Invalid binary expression...")
            }
        }
        return nil
    }

    private func isTruthy(_ value: Literal?) -> Bool {
        guard case .bool = value else { return false }

        return true
    }

    private func isEqual(_ left: Literal?, _ right: Literal?) -> Bool {
        guard left != nil else {
            return right == nil
        }
        if case .float(let left) = left, case .float(let right) = right {
            return left == right
        }
        if case .string(let left) = left, case .string(let right) = right {
            return left == right
        }
        if case .bool(let left) = left, case .bool(let right) = right {
            return left == right
        }
        return false
    }

}

