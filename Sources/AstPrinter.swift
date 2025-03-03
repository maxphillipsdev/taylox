@MainActor
class AstPrinter {
    func print(_ root: Expr) -> String {
        switch root {
        case .unary(let op, let right):
            return parenthesize(op.lexeme, right)
        case .binary(let left, let op, let right):
            return parenthesize(op.lexeme, left, right)
        case .grouping(let expr):
            return parenthesize("group", expr)
        case .literal(let value):
            guard let value = value else {
                return "nil"
            }
            return value.description
        }
    }

    private func parenthesize(_ name: String, _ exprs: Expr...) -> String {
        var result = "("
        result.append(name)

        for expr in exprs {
            result.append(" ")
            result.append(print(expr))
        }

        result.append(")")
        return result
    }
}

