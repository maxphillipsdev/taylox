@MainActor
class Interpreter {
    func interpret(_ expression: Expr) {
    }

    func evaluate(_ root: Expr) throws(RuntimeError) -> Value? {
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
                guard let right = right as? Float else {
                    throw RuntimeError(message: "Operand must be a number.", token: op)
                }
                return -(right)
            case .BANG:
                return !isTruthy(right)
            default:
                fatalError("Invalid unary expression...")
            }
        case .binary(let left, let op, let right):
            let left = try evaluate(left)
            let right = try evaluate(right)

            switch op.type {
            case .GREATER:
                guard let left = left as? Float, let right = right as? Float else {
                    throw RuntimeError(message: "Operands must be a number.", token: op)
                }
                return left > right
            case .GREATER_EQUAL:
                guard let left = left as? Float, let right = right as? Float else {
                    throw RuntimeError(message: "Operands must be a number.", token: op)
                }
                return left >= right
            case .LESS:
                guard let left = left as? Float, let right = right as? Float else {
                    throw RuntimeError(message: "Operands must be a number.", token: op)
                }
                return left < right
            case .LESS_EQUAL:
                guard let left = left as? Float, let right = right as? Float else {
                    throw RuntimeError(message: "Operands must be a number.", token: op)
                }
                return left <= right
            case .EQUAL:
                return isEqual(left, right)
            case .BANG_EQUAL:
                return !isEqual(left, right)
            case .MINUS:
                guard let left = left as? Float, let right = right as? Float else {
                    throw RuntimeError(message: "Operands must be a number.", token: op)
                }
                return left - right
            case .SLASH:
                guard let left = left as? Float, let right = right as? Float else {
                    throw RuntimeError(message: "Operands must be a number.", token: op)
                }
                return left / right
            case .STAR:
                guard let left = left as? Float, let right = right as? Float else {
                    throw RuntimeError(message: "Operands must be a number.", token: op)
                }
                return left * right
            case .PLUS:
                if let left = left as? Float, let right = right as? Float {
                    return left + right
                }

                if let left = left as? String, let right = right as? String {
                    return left + right
                }

                throw RuntimeError(
                    message: "Operands must be two numbers or two strings.", token: op)
            default:
                fatalError("Invalid binary expression...")
            }
        }
        return nil
    }

    private func isTruthy(_ value: Value?) -> Bool {
        guard let value = value else { return false }
        guard value is Bool else { return false }
        return true
    }

    private func isEqual(_ left: Value?, _ right: Value?) -> Bool {
        guard let left = left, let right = right else { return true }

        return left.description == right.description
    }
}
