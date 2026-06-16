/* Operadores Relacionais */
    "=="            { return symbol(sym.REL_OP); }
    "!="            { return symbol(sym.REL_OP); }
    "<="            { return symbol(sym.REL_OP); }
    ">="            { return symbol(sym.REL_OP); }
    "<"             { return symbol(sym.REL_OP); }
    ">"             { return symbol(sym.REL_OP); }

    /* Operador de Atribuição */
    "="             { return symbol(sym.ASSIGN); }

    /* Operadores Aditivos */
    "+"             { return symbol(sym.ADD_OP); }
    "-"             { return symbol(sym.ADD_OP); }

    /* Operadores Multiplicativos (incluindo o % se a especificação pedir) */
    "*"             { return symbol(sym.MUL_OP); }
    "/"             { return symbol(sym.MUL_OP); }
    "%"             { return symbol(sym.MUL_OP); }