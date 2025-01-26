import Foundation

guard CommandLine.argc <= 2 else {
    Swift.print("Usage: taylox [script]")
    // todo: figure out error codes
    exit(64)
}

if CommandLine.argc == 2 {
    Lox.runFile(file: CommandLine.arguments[1])
} else {
    Lox.runPrompt()
}
