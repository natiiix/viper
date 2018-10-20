%defines

%define parse.error verbose

%{

#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* const str);

%}

%union
{
    const char* str_val;
}

%start full_source_code

%%

full_source_code
    : %empty { printf("%s", "int main(void) { return 0; }"); }
    ;

%%

int main(void)
{
    yyin = stdin;

	do
	{
		yyparse();
	}
	while(!feof(yyin));

	return 0;
}

void yyerror(const char* const str)
{
	fprintf(stderr, "Parse error: %s\n", str);
	exit(-1);
}
