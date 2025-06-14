enum Literal {
    case Float(Float)
    case String(String)
    case Bool(Bool)
}

indirect enum Stmt {
    case Block(stmts: [Stmt])
    case Expr(expr: Expr)
    case If(condition: Expr, then: Stmt, else: Stmt?)
    case Print(expr: Expr)
    case VarDecl(name: Token, initializer: Expr?)
}

indirect enum Expr: Sendable {
    case Assignment(name: Token, value: Expr)
    case Binary(left: Expr, op: Token, right: Expr)
    case Grouping(expr: Expr)
    case Literal(value: Literal?)
    case Logical(left: Expr, op: Token, right: Expr)
    case Unary(op: Token, right: Expr)
    case Variable(name: Token)
}
