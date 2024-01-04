const std = @import("std");

pub const TokenType = enum { ILLEGAL, EOF, IDENT, INT, ASSIGN, PLUS, COMMA, SEMICOLON, LPAREN, RPAREN, LBRACE, RBRACE, FUNCTION, LET };

pub const Token = struct {
    tokenType: TokenType,
    literal: []const u8,

    pub fn init(tokenType: TokenType, literal: []const u8) @This() {
        var token = @This(){ .tokenType = tokenType, .literal = literal };
        return token;
    }

    pub fn keyword(identifier: []const u8) TokenType {
        const map = std.ComptimeStringMap(TokenType, .{
            .{ "let", .LET },
            .{ "fn", .FUNCTION },
            .{ "true", .TRUE },
            .{ "false", .FALSE },
            .{ "if", .IF },
            .{ "else", .ELSE },
            .{ "return", .RETURN },
        });
        const _tokenType = map.get(identifier);
        if (_tokenType) {
            return _tokenType;
        }
        return TokenType.IDENT;
    }
};
