const std = @import("std");
const token = @import("token");
const Token = token.Token;
const TokenType = token.TokenType;

pub const Lexer = struct {
    input: []const u8,
    position: usize,
    readPosition: usize,
    ch: u8,
    pub fn init(input: []const u8) @This() {
        var lexer = @This(){
            .input = input,
        };
        lexer.readChar();
        return lexer;
    }

    pub fn readChar(self: *@This()) void {
        if (self.readPosition >= self.input.len) {
            self.ch = 0;
        } else {
            self.ch = self.input[self.readPosition];
        }
        self.position = self.readPosition;
        self.readPosition += 1;
    }

    pub fn nextToken(self: *@This()) Token {
        var _token: Token = undefined;
        self.skipWhitespace();
        switch (self.ch) {
            '=' => _token = Token.init(TokenType.ASSIGN, self.ch),
            ';' => _token = Token.init(TokenType.SEMICOLON, self.ch),
            '(' => _token = Token.init(TokenType.LPAREN, self.ch),
            ')' => _token = Token.init(TokenType.RPAREN, self.ch),
            ',' => _token = Token.init(TokenType.COMMA, self.ch),
            '+' => _token = Token.init(TokenType.PLUS, self.ch),
            '{' => _token = Token.init(TokenType.LBRACE, self.ch),
            '}' => _token = Token.init(TokenType.RBRACE, self.ch),
            0 => _token = Token.init(TokenType.EOF, ""),
            else => {
                if (std.ascii.isAlphabetic(self.ch) or self.ch == '_') {
                    var _literal = self.readIdentifier();
                    return Token.init(Token.keyword(_literal), _literal);
                } else if (std.ascii.isDigit(self.ch)) {
                    return Token.init(TokenType.INT, self.readNumber());
                } else {
                    _token = Token.init(TokenType.ILLEGAL, self.ch);
                }
            },
        }
        self.readChar();
        return _token;
    }

    fn readIdentifier(self: *@This()) []const u8 {
        var position = self.position;
        while (std.ascii.isAlphabetic(self.ch) or self.ch == '_') {
            self.readChar();
        }
        return self.input[position..self.position];
    }

    fn readNumber(self: *@This()) []const u8 {
        var position = self.position;
        while (std.ascii.isDigit(self.ch)) {
            self.readChar();
        }
        return self.input[position..self.position];
    }

    fn skipWhitespace(self: *@This()) void {
        while (std.ascii.isWhitespace(self.ch)) {
            self.readChar();
        }
    }
};
