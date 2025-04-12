@MainActor
class Interpreter {
    func interpret(_ expression: Expr) {
    }

    func evaluate(_ root: Expr) -> Value? {
        switch root {
        case .literal(let value):
            guard let value = value else {
                return nil
            }
            return value
        case .grouping(let expr):
            return evaluate(expr)
        case .unary(let op, let right):
            let right = evaluate(right)

            switch op.type {
            case .MINUS:
                return -(right as! Float)
            case .BANG:
                return !isTruthy(right)
            default:
                fatalError("Invalid unary expression...")
            }
        case .binary(let left, let op, let right):
            let left = evaluate(left)
            let right = evaluate(right)

            switch op.type {
            case .GREATER:
                return (left as! Float) > (right as! Float)
            case .GREATER_EQUAL:
                return (left as! Float) >= (right as! Float)
            case .LESS:
                return (left as! Float) < (right as! Float)
            case .LESS_EQUAL:
                return (left as! Float) <= (right as! Float)
            case .EQUAL:
                return isEqual(left, right)
            case .BANG_EQUAL:
                return !isEqual(left, right)
            case .MINUS:
                return (left as! Float) - (right as! Float)
            case .SLASH:
                return (left as! Float) / (right as! Float)
            case .STAR:
                return (left as! Float) * (right as! Float)
            case .PLUS:
                if left is Float && right is Float {
                    return (left as! Float) + (right as! Float)
                }

                if left is String && right is String {
                    return (left as! String) + (right as! String)
                }
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
