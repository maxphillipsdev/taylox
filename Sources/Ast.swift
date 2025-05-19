enum Literal {
    case float (Float)
    case string (String)
    case bool (Bool)
}

enum Stmt {
    case expr(expr: Expr)
    case print(expr: Expr)
    case varDecl(name: Token, initializer: Expr?)
}

indirect enum Expr: Sendable {
    // case assignment(name: Token, value: Expr)
    case binary(left: Expr, op: Token, right: Expr)
    case grouping(expr: Expr)
    case literal(value: Literal?)
    case unary(op: Token, right: Expr)
    case variable(name: Token)
}

