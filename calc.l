%{
#include "calc.tab.h"
#include <stdio.h>
#include <stdlib.h>
%}

%%
[0-9]+          { yylval.num = atoi(yytext); printf("\033[1;33m[NUMBER:%s]\033[0m ", yytext); return NUMBER; }
"+"             { printf("\033[1;33m[PLUS]\033[0m "); return PLUS; }
"-"             { printf("\033[1;33m[MINUS]\033[0m "); return MINUS; }
"*"             { printf("\033[1;33m[MULT]\033[0m "); return MULT; }
"/"             { printf("\033[1;33m[DIV]\033[0m "); return DIV; }
"("             { printf("\033[1;33m[LEFTPAREN]\033[0m "); return LEFTPAREN; }
")"             { printf("\033[1;33m[RIGHTPAREN]\033[0m "); return RIGHTPAREN; }
\n              { return END; }
[ \t]+          { /* ignore whitespace */ }
.               { printf("\033[1;31mCaractère invalide: %s\033[0m\n", yytext); }
%%
