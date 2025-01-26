enum TokenType {
    case leftParen
    case rightParen
    case leftBrace
    case rightBrace
    case comma
    case dot
    case minus
    case plus
    case semicolon
    case slash
    case star

    case bang
    case bangEqual
    case equal
    case equalEqual
    case greater
    case greaterequal
    case less
    case lessEqual

    case identifier
    case string
    case number

    // todo: figure out the keywords
    // AND, CLASS, ELSE, FALSE, FUN, FOR, IF, NIL, OR,
    // PRINT, RETURN, SUPER, THIS, TRUE, VAR, WHILE,

    case EOF
}
