
# (Tay)lox

A Swift implementation of the Lox programming language from [Crafting Interpreters.](https://craftinginterpreters.com/)

## Status

In progress, currently functional in REPL and file input form as an expression
evaluater.

## Usage

This is a Swift Package Manager project.

Run the REPL with
```sh
swift run taylox
```

Run a file with
```sh
swift run taylox <path>
```

## Tests

Install dependencies with

```sh
dart pub get
```

Run with

```sh
dart tool/bin/test.dart jlox --interpreter .build/taylox
```

