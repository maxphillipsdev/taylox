typealias Value = CustomStringConvertible

indirect enum Expr {
    case binary(left: Expr, op: Token, right: Expr)
    case grouping(expr: Expr)
    case literal(value: Value?)
    case unary(op: Token, right: Expr)
}

