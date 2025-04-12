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

@MainActor
class Parser {
    final var tokens: [Token] = []
    var current = 0

    init(_ tokens: [Token]) {
        self.tokens = tokens
    }

    func parse() throws(ParserError) -> Expr? {
        return try expression()
    }

    private func expression() throws(ParserError) -> Expr {
        return try equality()
    }

    private func equality() throws(ParserError) -> Expr {
        var expr = try comparison()

        while match(.BANG_EQUAL, .EQUAL_EQUAL) {
            let op = previous()
            let right = try comparison()
            expr = Expr.binary(left: expr, op: op, right: right)
        }

        return expr
    }

    private func comparison() throws(ParserError) -> Expr {
        var expr = try term()

        while match(.GREATER, .GREATER_EQUAL, .LESS, .LESS_EQUAL) {
            let op = previous()
            let right = try term()
            expr = Expr.binary(left: expr, op: op, right: right)
        }

        return expr
    }

    private func term() throws(ParserError) -> Expr {
        var expr = try factor()

        while match(.MINUS, .PLUS) {
            let op = previous()
            let right = try factor()
            expr = Expr.binary(left: expr, op: op, right: right)
        }

        return expr
    }

    private func factor() throws(ParserError) -> Expr {
        var expr = try unary()

        while match(.SLASH, .STAR) {
            let op = previous()
            let right = try unary()
            expr = Expr.binary(left: expr, op: op, right: right)
        }

        return expr
    }

    private func unary() throws(ParserError) -> Expr {
        if match(.BANG, .MINUS) {
            let op = previous()
            let unary = try unary()
            return Expr.unary(op: op, right: unary)
        }

        return try primary()
    }

    private func primary() throws(ParserError) -> Expr {
        if match(.FALSE) {
            return Expr.literal(value: false)
        }
        if match(.TRUE) {
            return Expr.literal(value: true)
        }
        if match(.NIL) {
            return Expr.literal(value: nil)
        }

        if match(.NUMBER, .STRING) {
            return Expr.literal(value: previous().literal)
        }

        if match(.LEFT_PAREN) {
            let expr = try expression()
            guard check(.RIGHT_PAREN) else {
                throw ParserError(message: "Expect ')' after expression.", token: peek())
            }
            let _ = advance()
            return Expr.grouping(expr: expr)
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
