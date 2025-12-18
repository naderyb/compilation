%{
/* include standard libraries for input/output, memory allocation, and string manipulation */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* function prototypes */
int yylex();
int yywrap(void) { return 1; }
void yyerror(const char *s);

/* Global variables */
int result; // final result
int step_count; // step numbering for evaluation
int depth; // indentation for nested expressions
#define MAX_HISTORY 5
int history[MAX_HISTORY]; // last 5 results
int history_index = 0; // index for history tracking

/* Function to print evaluation steps with indentation and color */
void print_step(const char *op, int left, int right) {
    for(int i=0;i<depth;i++) printf("  "); // indentation
    printf("\033[1;36m%d) %d %s %d = %d\033[0m\n", step_count++, left, op, right,
           (strcmp(op,"+") == 0) ? left+right :
           (strcmp(op,"-") == 0) ? left-right :
           (strcmp(op,"*") == 0) ? left*right :
           (strcmp(op,"/") == 0) ? left/right : 0 );
}
%}

%union {
    int num;
}

%token <num> NUMBER
%token PLUS MINUS MULT DIV LEFTPAREN RIGHTPAREN END
%type <num> expr term factor

%%

input:
    | input line
    ;

line:
    expr END {
        printf("\n\033[1;32mResultat final: %d\033[0m\n\n", $1);
        result = $1;
        // save to history
        history[history_index % MAX_HISTORY] = $1;
        history_index++;
    }
    ;

expr:
      expr PLUS term   { depth++; print_step("+",$1,$3); depth--; $$ = $1+$3; step_count++; }
    | expr MINUS term  { depth++; print_step("-",$1,$3); depth--; $$ = $1-$3; step_count++; }
    | term             { $$ = $1; }
    ;

term:
      term MULT factor  { depth++; print_step("*",$1,$3); depth--; $$ = $1*$3; step_count++; }
    | term DIV factor   { 
            if($3==0) { yyerror("division par zero"); $$=0; } 
            else { depth++; print_step("/",$1,$3); depth--; $$ = $1/$3; step_count++; }
        }
    | factor           { $$ = $1; }
    ;

factor:
      NUMBER          { $$ = $1; }
    | LEFTPAREN expr RIGHTPAREN { $$ = $2; }
    ;

%%

void yyerror(const char *s) {
    printf("\033[1;31mErreur syntaxique: %s\033[0m\n", s);
}

// Evaluate a single expression string
int evaluate_expression(const char *expr) {
    FILE *f = tmpfile();
    fputs(expr, f);
    fputs("\n", f);
    rewind(f);

    extern FILE *yyin;
    yyin = f;

    step_count = 1; // reset step number
    depth = 0;
    yyparse();
    fclose(f);

    return result;
}

// Helper: print centered text
void print_centered(const char *text, int width, const char *color) {
    int len = strlen(text);
    int pad = (width - len)/2;
    printf("%s", color);
    for(int i=0;i<pad;i++) printf(" ");
    printf("%s\033[0m\n", text);
}

// Print history
void print_history() {
    if(history_index == 0) return;
    printf("\033[1;35mDerniers resultats: ");
    int count = history_index < MAX_HISTORY ? history_index : MAX_HISTORY;
    for(int i=0;i<count;i++) {
        int idx = (history_index - count + i) % MAX_HISTORY;
        printf("%d ", history[idx]);
    }
    printf("\033[0m\n");
}

// Main REPL
int main() {
    char input[256];
    int term_width = 80;

    print_centered("=================================", term_width, "\033[1;34m");
    print_centered("CALCULATRICE TRADUCTEUR", term_width, "\033[1;34m");
    print_centered("=================================", term_width, "\033[1;34m");
    printf("\n");
    print_centered("Tapez une expression arithmetique", term_width, "\033[1;37m");
    print_centered("Exemple: (5 + 3) * 2", term_width, "\033[1;37m");
    print_centered("Tapez 'quit' ou 'exit' pour quitter", term_width, "\033[1;37m");
    printf("\n");

    while(1) {
        print_history();
        printf("\033[1;36m> \033[0m");
        if (!fgets(input,sizeof(input),stdin)) break;

        if(input[strlen(input)-1]=='\n') input[strlen(input)-1]='\0';
        if(strcmp(input,"quit")==0 || strcmp(input,"exit")==0) {
            print_centered("Au revoir !", term_width, "\033[1;32m");
            break;
        }

        evaluate_expression(input);
        printf("\n");
    }

    return 0;
}
