%{
    #include "calc.tab.h"   // Bison-generated header with token defs and yylval
    #include <stdio.h>
    #include <stdlib.h>
%}

/* ---- Lexer rules ---- */
%%
[0-9]+          {               /* integer literal */
                    yylval.num = atoi(yytext);
                    return NUMBER;
                }
"+"             { return PLUS; }        /* plus operator */
"-"             { return MINUS; }       /* minus operator */
"*"             { return MULT; }        /* multiply operator */
"/"             { return DIV; }         /* divide operator */
"("             { return LEFTPAREN; }   /* left parenthesis */
")"             { return RIGHTPAREN; }  /* right parenthesis */
\n              { return END; }         /* end of line (newline) */
[ \t]+          { /* ignore whitespace */ }
.               {                       /* any other char is invalid */
                    printf("Caractere invalide: %s\n", yytext);
                }
%%
