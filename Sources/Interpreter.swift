class Interpreter {
    func interpret(_ statements: [Stmt]) throws(RuntimeError) {
        for statement in statements {
            try execute(statement)
        }
    }

    private func execute(_ root: Stmt) throws(RuntimeError) {
        switch root {
        case .expr(let expr):
            try evaluate(expr)
        case .print(let expr):
            let value = try evaluate(expr)
            Swift.print(stringify(value))
        }
    }

    private func stringify(_ value: Literal?) -> String {
        guard let value = value else { return "nil" }
        if case .float(let numericValue) = value {
            let text = String(numericValue)
            // print integral values as integers
            return text.hasSuffix(".0") ? String(text.dropLast(2)) : text
        }
        if case .string(let stringValue) = value {
            return stringValue
        }
        return String(describing: value)
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
