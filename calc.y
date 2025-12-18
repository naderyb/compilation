%{
#include <stdio.h>
#include <stdlib.h>

// Forward declarations for lexer and error handler
int yylex();
int yywrap(void) { return 1; }
void yyerror(const char *s);
%}

// Semantic value type: only an int for this simple calculator
%union {
    int num;
}

// Tokens produced by the lexer; NUMBER carries an int value
%token <num> NUMBER
%token PLUS MINUS MULT DIV LEFTPAREN RIGHTPAREN END

// Nonterminal types
%type <num> expr term factor

%%
/* Grammar rules and actions */

// input: zero or more lines
input:
        /* empty */
    |   input line
    ;

// line: one expression ending with END (e.g., newline)
line:
        expr END {
            printf("Resultat = %d\n", $1);
            printf("> ");
        }
    ;

// expr: handles + and -
expr:
        expr PLUS term    { $$ = $1 + $3; }
    |   expr MINUS term   { $$ = $1 - $3; }
    |   term              { $$ = $1; }
    ;

// term: handles * and / with divide-by-zero check
term:
        term MULT factor  { $$ = $1 * $3; }
    |   term DIV factor  {
            if ($3 == 0) {
                yyerror("division par zero");
                $$ = 0;
            } else {
                $$ = $1 / $3;
            }
        }
    |   factor            { $$ = $1; }
    ;

// factor: numbers or parenthesized expressions
factor:
        NUMBER
    |   LEFTPAREN expr RIGHTPAREN { $$ = $2; }
    ;
%%
/* Support code */

void yyerror(const char *s) {
    printf("Erreur syntaxique: %s\n", s);
}

int main() {
    printf("Calculatrice simple (Ctrl+C pour quitter)\n");
    printf("> ");
    yyparse();
    return 0;
}
