%{
#include "calc.tab.h"   /* include parser header for token definitions */
#include <stdio.h>      
#include <stdlib.h> 
%}

/* rules section: Pattern matching and token recognition */
%%

[0-9]+          { yylval.num = atoi(yytext); printf("\033[1;33m[NUMBER:%s]\033[0m ", yytext); return NUMBER; }

"+"             { printf("\033[1;33m[PLUS]\033[0m "); return PLUS; }      /* addition operator */
"-"             { printf("\033[1;33m[MINUS]\033[0m "); return MINUS; }    /* subtraction operator */
"*"             { printf("\033[1;33m[MULT]\033[0m "); return MULT; }      /* multiplication operator */
"/"             { printf("\033[1;33m[DIV]\033[0m "); return DIV; }        /* division operator */

"("             { printf("\033[1;33m[LEFTPAREN]\033[0m "); return LEFTPAREN; }   /* left parenthesis */
")"             { printf("\033[1;33m[RIGHTPAREN]\033[0m "); return RIGHTPAREN; } /* right parenthesis */

\n              { return END; }

[ \t]+          { /* ignore whitespace */ }

.               { printf("\033[1;31mCaractère invalide: %s\033[0m\n", yytext); }
%%
