/**
# NOTES

Grammar notation	Code representation
Terminal	        Code to match and consume a token
Nonterminal	        Call to that rule’s function
|	                if or switch statement
* or +	                while or for loop
?	                if statement

# GRAMMAR

expression     → equality ;
equality       → comparison ( ( "!=" | "==" ) comparison )* ;
comparison     → term ( ( ">" | ">=" | "<" | "<=" ) term )* ;
term           → factor ( ( "-" | "+" ) factor )* ;
factor         → unary ( ( "/" | "*" ) unary )* ;
unary          → ( "!" | "-" ) unary
               | primary ;
primary        → NUMBER | STRING | "true" | "false" | "nil"
               | "(" expression ")" ;
*/

class Parser {
    final var tokens: [Token] = []
    var current = 0

    init(_ tokens: [Token]) {
        self.tokens = tokens
    }

    func parse() throws(ParserError) -> [Stmt]? {
        var stmts: [Stmt] = []
        while !isAtEnd() {
            stmts.append(try declaration())
        }
        return stmts
    }

    private func declaration() throws(ParserError) -> Stmt {
        if match(.VAR) {
            return try varDeclaration()
        }

        return try statement()
    }

    private func varDeclaration() throws(ParserError) -> Stmt {
        guard check(.IDENTIFIER) else {
            throw ParserError(message: "Expect variable name.", token: peek())
        }
        let token = advance()

        var initializer: Expr?
        if match(.EQUAL) {
            initializer = try expression()
        }

        guard match(.SEMICOLON) else {
            throw ParserError(message: "Expect ';' after expression.", token: peek())
        }

        return Stmt.VarDecl(name: token, initializer: initializer)
    }

    private func statement() throws(ParserError) -> Stmt {
        if match(.IF) {
            return try ifStatement()
        }

        if match(.PRINT) {
            return try printStatement()
        }

        if match(.LEFT_BRACE) {
            return Stmt.Block(stmts: try block())
        }

        return try expressionStatement()
    }

    private func ifStatement() throws(ParserError) -> Stmt {
        guard match(.LEFT_PAREN) else {
            throw ParserError(message: "Expect '(' after 'if'.", token: peek())
        }
        let condition = try expression()
        guard match(.RIGHT_PAREN) else {
            throw ParserError(message: "Expect ')' after if condition.", token: peek())
        }

        let thenBranch = try statement()
        var elseBranch: Stmt? = nil

        if match(.ELSE) {
            elseBranch = try statement()
        }

        return Stmt.If(condition: condition, then: thenBranch, else: elseBranch)
    }

    private func printStatement() throws(ParserError) -> Stmt {
        let value = try expression()
        guard match(.SEMICOLON) else {
            throw ParserError(message: "Expect ';' after value.", token: peek())
        }

        return Stmt.Print(expr: value)
    }

    private func block() throws(ParserError) -> [Stmt] {
        var stmts: [Stmt] = []

        while !check(.RIGHT_BRACE) && !isAtEnd() {
            stmts.append(try declaration())
        }

        if !match(.RIGHT_BRACE) {
            throw ParserError(message: "Expect '}' after block.", token: peek())
        }
        return stmts
    }

    private func expressionStatement() throws(ParserError) -> Stmt {
        let value = try expression()
        guard match(.SEMICOLON) else {
            throw ParserError(message: "Expect ';' after expression.", token: peek())
        }

        return Stmt.Expr(expr: value)
    }

    private func expression() throws(ParserError) -> Expr {
        return try assignment()
    }

    private func assignment() throws(ParserError) -> Expr {
        let expr = try equality()

        if match(.EQUAL) {
            let equals = previous()
            let value = try assignment()

            if case .Variable(let name) = expr {
                return Expr.Assignment(name: name, value: value)
            }

            Lox.parserError(token: equals, message: "Invalid assignment target.")
        }

        return expr
    }

    private func equality() throws(ParserError) -> Expr {
        var expr = try comparison()

        while match(.BANG_EQUAL, .EQUAL_EQUAL) {
            let op = previous()
            let right = try comparison()
            expr = Expr.Binary(left: expr, op: op, right: right)
        }

        return expr
    }

    private func comparison() throws(ParserError) -> Expr {
        var expr = try term()

        while match(.GREATER, .GREATER_EQUAL, .LESS, .LESS_EQUAL) {
            let op = previous()
            let right = try term()
            expr = Expr.Binary(left: expr, op: op, right: right)
        }

        return expr
    }

    private func term() throws(ParserError) -> Expr {
        var expr = try factor()

        while match(.MINUS, .PLUS) {
            let op = previous()
            let right = try factor()
            expr = Expr.Binary(left: expr, op: op, right: right)
        }

        return expr
    }

    private func factor() throws(ParserError) -> Expr {
        var expr = try unary()

        while match(.SLASH, .STAR) {
            let op = previous()
            let right = try unary()
            expr = Expr.Binary(left: expr, op: op, right: right)
        }

        return expr
    }

    private func unary() throws(ParserError) -> Expr {
        if match(.BANG, .MINUS) {
            let op = previous()
            let unary = try unary()
            return Expr.Unary(op: op, right: unary)
        }

        return try primary()
    }

    private func primary() throws(ParserError) -> Expr {
        if match(.FALSE) {
            return Expr.Literal(value: Literal.Bool(false))
        }
        if match(.TRUE) {
            return Expr.Literal(value: Literal.Bool(true))
        }
        if match(.NIL) {
            return Expr.Literal(value: nil)
        }

        if match(.NUMBER, .STRING) {
            return Expr.Literal(value: previous().literal)
        }

        if match(.IDENTIFIER) {
            return Expr.Variable(name: previous())
        }

        if match(.LEFT_PAREN) {
            let expr = try expression()
            guard check(.RIGHT_PAREN) else {
                throw ParserError(message: "Expect ')' after expression.", token: peek())
            }
            _ = advance()
            return Expr.Grouping(expr: expr)
        }

        throw ParserError(message: "Expect expression.", token: peek())
    }

    private func advance() -> Token {
        if !isAtEnd() {
            current += 1
        }

        return previous()
    }

    private func match(_ terms: TokenType...) -> Bool {
        for term in terms {
            if check(term) {
                _ = advance()
                return true
            }
        }

        return false
    }

    private func check(_ type: TokenType) -> Bool {
        if isAtEnd() {
            return false
        }

        return peek().type == type
    }

    private func peek() -> Token {
        return tokens[current]
    }

    private func isAtEnd() -> Bool {
        return peek().type == TokenType.EOF
    }

    private func previous() -> Token {
        // TODO: NPE?
        return tokens[current - 1]
    }
}
