class AstPrinter {
    func print(_ root: Expr) throws -> String {
        switch root {
        case .Unary(let op, let right):
            return try parenthesize(op.lexeme, right)
        case .Binary(let left, let op, let right):
            return try parenthesize(op.lexeme, left, right)
        case .Grouping(let expr):
            return try parenthesize("group", expr)
        case .Variable(let name):
            return "name"
        case .Assignment(let name, let valueExpr):
            let value = try print(valueExpr)
            return "\(name) = \(value)"
        case .Literal(let value):
            guard let value = value else {
                return "nil"
            }
            guard let value = value as? String else {
                return ""
            }
            return value
        }
    }

    private func parenthesize(_ name: String, _ exprs: Expr...) throws -> String {
        var result = "("
        result.append(name)

        for expr in exprs {
            result.append(" ")
            result.append(try print(expr))
        }

        result.append(")")
        return result
    }
}
