package br.maua.cic303;

import java_cup.runtime.Symbol;

%%

%class Lexer
%public
%unicode
%cup
%line
%column

%{
    /* Cria um símbolo sem valor semântico associado */
    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }
    
    /* Cria um símbolo com valor semântico (ex: o texto do ID ou do Número) */
    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
%}

LineTerminator = \r|\n|\r\n
WhiteSpace     = {LineTerminator} | [ \t\f]

/* Definições Regulares */
Number              = [0-9]+(\.[0-9]+)?([Ee][+-]?[0-9]+)?
Letter              = [a-zA-Z]
Digit               = [0-9]
Identifier          = {Letter}({Letter}|{Digit}|_){0,31}
OversizedIdentifier = {Letter}({Letter}|{Digit}|_){32,}

%%

<YYINITIAL> {
    /* Ignorar espaços em branco e quebras de linha */
    {WhiteSpace}    { /* Ignorar */ }

    /* Palavras Reservadas */
    "if"            { return symbol(sym.IF); }
    "then"          { return symbol(sym.THEN); }
    "else"          { return symbol(sym.ELSE); }
    "while"         { return symbol(sym.WHILE); }

    /* Delimitadores e Símbolos Especiais */
    "("              { return symbol(sym.LPAREN); }
    ")"              { return symbol(sym.RPAREN); }
    "{"              { return symbol(sym.LBRACE); }
    "}"              { return symbol(sym.RBRACE); }
    ";"              { return symbol(sym.SEMI); }

    /* Operadores Relacionais e Atribuição */
    "=="            { return symbol(sym.REL_OP, yytext()); }
    "!="            { return symbol(sym.REL_OP, yytext()); }
    "<="            { return symbol(sym.REL_OP, yytext()); }
    ">="            { return symbol(sym.REL_OP, yytext()); }
    "="             { return symbol(sym.ASSIGN); }
    "<"             { return symbol(sym.REL_OP, yytext()); }
    ">"             { return symbol(sym.REL_OP, yytext()); }

    /* Operadores Aritméticos */
    "+"             { return symbol(sym.ADD_OP, yytext()); }
    "-"             { return symbol(sym.ADD_OP, yytext()); }
    "*"             { return symbol(sym.MUL_OP, yytext()); }
    "/"             { return symbol(sym.MUL_OP, yytext()); }
    "%"             { return symbol(sym.MUL_OP, yytext()); }

    /* Identificadores e Números (Passando yytext() como valor) */
    {Identifier}    { return symbol(sym.ID, yytext()); }
    {Number}        { return symbol(sym.NUMBER, yytext()); }

    /* Tratamento de Erros Léxicos */
    {OversizedIdentifier} { throw new RuntimeException("Erro Léxico: Identificador gigante -> " + yytext()); }
    .                     { throw new RuntimeException("Erro Léxico: Caractere Ilegal -> " + yytext()); }
}

/* Fim do Arquivo */
<<EOF>>             { return symbol(sym.EOF); }