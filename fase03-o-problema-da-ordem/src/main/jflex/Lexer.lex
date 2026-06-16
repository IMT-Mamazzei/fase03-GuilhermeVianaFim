package br.maua.cic303;

import java_cup.runtime.Symbol; // Importação necessária para o CUP

%%

%class Lexer
%public
%unicode
%cup       // <-- Ativa a integração nativa com as classes do CUP (sym.java)
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
/* MACROS (Expressões Regulares Auxiliares do README)                         */
/* ========================================================================= */
LineTerminator = \r|\n|\r\n
WhiteSpace     = {LineTerminator} | [ \t\f]

/* Número em Notação de Engenharia (Aceita 7, 3.14, 6.02E23, 6.62e-34) */
Number = [0-9]+(\.[0-9]+)?([Ee][+-]?[0-9]+)?

/* Identificador com MÁXIMO de 32 caracteres */
Letter = [a-zA-Z]
Digit  = [0-9]
Identifier = {Letter}({Letter}|{Digit}|_){0,31}

/* Captura identificadores que passam do limite de 32 caracteres para lançar erro */
OversizedIdentifier = {Letter}({Letter}|{Digit}|_){32,}

%%
/* ========================================================================= */
/* REGRAS LÉXICAS                                                           */
/* ========================================================================= */

<YYINITIAL> {
    
    /* Ignorar espaços em branco */
    {WhiteSpace}    { /* Não faz nada */ }

    /* Palavras Reservadas da Linguagem JACA */
    "if"            { return symbol(sym.IF); }
    "then"          { return symbol(sym.THEN); }
    "else"          { return symbol(sym.ELSE); }
    "while"         { return symbol(sym.WHILE); }

    /* Pontuação e Delimitadores */
    "("              { return symbol(sym.LPAREN); }
    ")"              { return symbol(sym.RPAREN); }
    "{"              { return symbol(sym.LBRACE); }
    "}"              { return symbol(sym.RBRACE); }
    ";"              { return symbol(sym.SEMI); }

    /* Operador de Atribuição e Operadores Relacionais */
    "=="            { return symbol(sym.REL_OP, yytext()); }
    "!="            { return symbol(sym.REL_OP, yytext()); }
    "<="            { return symbol(sym.REL_OP, yytext()); }
    ">="            { return symbol(sym.REL_OP, yytext()); }
    "="             { return symbol(sym.ASSIGN); }
    "<"             { return symbol(sym.REL_OP, yytext()); }
    ">"             { return symbol(sym.REL_OP, yytext()); }

    /* Operadores Matemáticos (Agrupados por prioridade do CUP) */
    "+"             { return symbol(sym.ADD_OP, yytext()); }
    "-"             { return symbol(sym.ADD_OP, yytext()); }
    "*"             { return symbol(sym.MUL_OP, yytext()); }
    "/"             { return symbol(sym.MUL_OP, yytext()); }
    "%"             { return symbol(sym.MUL_OP, yytext()); }

    /* Casamento das Macros válidas */
    {Identifier}    { return symbol(sym.ID, yytext()); }
    {Number}        { return symbol(sym.NUMBER, yytext()); }

    /* Captura e lança erro para Identificadores gigantes */
    {OversizedIdentifier} { throw new RuntimeException("Erro Léxico: Identificador gigante -> " + yytext()); }

    /* Fallback para qualquer caractere inválido fora das regras */
    .   { throw new RuntimeException("Erro Léxico: Caractere Ilegal -> " + yytext()); }
}

/* Fim do arquivo (EOF) exigido pelo CUP */
<<EOF>>             { return symbol(sym.EOF, ""); }