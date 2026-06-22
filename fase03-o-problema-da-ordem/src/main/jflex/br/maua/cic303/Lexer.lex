package br.maua.cic303;

import java_cup.runtime.Symbol; // Importação necessária para o CUP

%%

%class Lexer
%public
%unicode
%cup       // <-- CRÍTICO: Esta diretiva ativa a integração com o CUP
%line
%column

%{
    // Funções auxiliares para gerar objetos Symbol para o CUP
    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }
    
    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
%}

/* ========================================================================= */
/* MACROS (Expressões Regulares Auxiliares)                                  */
/* ========================================================================= */
LineTerminator = \r|\n|\r\n
WhiteSpace     = {LineTerminator} | [ \t\f]

Number = [0-9]+(\.[0-9]+)?([Ee][+-]?[0-9]+)?

Letter = [a-zA-Z]
Digit  = [0-9]
Identifier = {Letter}({Letter}|{Digit}|_){0,31}
OversizedIdentifier = {Letter}({Letter}|{Digit}|_){32}

%%
/* ========================================================================= */
/* REGRAS LÉXICAS (Altere para retornar sym.XXX)                             */
/* ========================================================================= */

<YYINITIAL> {
    
    {WhiteSpace}    { /* Não faz nada */ }

    "if"            { return symbol(sym.IF); }
    "then"          { return symbol(sym.THEN); }
    "else"          { return symbol(sym.ELSE); }
    "while"         { return symbol(sym.WHILE); }

    \(              { return symbol(sym.LPAREN); }
    \)              { return symbol(sym.RPAREN); }
    \{              { return symbol(sym.LBRACE); }
    \}              { return symbol(sym.RBRACE); }
    ";"             { return symbol(sym.SEMI); }

    "=="            { return symbol(sym.REL_OP, yytext()); }
    "!="            { return symbol(sym.REL_OP, yytext()); }
    "<="            { return symbol(sym.REL_OP, yytext()); }
    ">="            { return symbol(sym.REL_OP, yytext()); }
    "<"             { return symbol(sym.REL_OP, yytext()); }
    ">"             { return symbol(sym.REL_OP, yytext()); }
    "="             { return symbol(sym.ASSIGN); }

    "+" | "-"       { return symbol(sym.ADD_OP, yytext()); }
    "*" | "/" | "%" { return symbol(sym.MUL_OP, yytext()); }

    {OversizedIdentifier} { throw new RuntimeException("Erro Léxico: Identificador gigante -> " + yytext()); }
    {Identifier}    { return symbol(sym.ID, yytext()); }
    {Number}        { return symbol(sym.NUMBER, yytext()); }

    .               { throw new RuntimeException("Erro Léxico: Caractere Ilegal -> " + yytext()); }
}

<<EOF>>             { return symbol(sym.EOF, ""); }
