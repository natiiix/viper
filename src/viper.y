%defines

%define parse.error verbose

%{

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* const str);

const char* strformat(const char* const format, ...);

const char* const strempty = "";

%}

%union
{
    const char* str_val;
}

%token<str_val> LIT_STRING

%token NEWLINE
%token KW_PRINT

%type<str_val> statement_block statement

%start full_source_code

%%

full_source_code
    : statement_block { printf("#include <stdio.h>\nint main(void) { %s return 0; }", $1); }
    ;

statement_block
    : NEWLINE { $$ = strempty; }
    | NEWLINE statement_block { $$ = $2; }
    | statement { $$ = $1; }
    | statement statement_block { strformat("%s%s", $1, $2); }
    ;

statement
    : KW_PRINT LIT_STRING NEWLINE { $$ = strformat("printf(\"%%s\", %s);", $2); }
    ;

%%

extern int row;
extern int column;

void yyparse_loop(void)
{
	do
	{
		yyparse();
	}
	while(!feof(yyin));
}

int main(const int argc, const char* const* const argv)
{
    if (argc == 1)
    {
        // printf("STDIN\n");
	    yyin = stdin;
        yyparse_loop();
    }
    else
    {
        for (int i = 1; i < argc; i++)
        {
            // printf("FILE: %s\n", argv[i]);
            yyin = fopen(argv[i], "r");
            yyparse_loop();
        }
    }

	return 0;
}

void yyerror(const char* const str)
{
	fprintf(stderr, "Parse error at line %i column %i: %s\n", row + 1, column + 1, str);
	exit(-1);
}

const char* strformat(const char* const format, ...)
{
    va_list args;
    va_start(args, format);

    const int len = vsnprintf(NULL, 0, format, args);
    char* const str = (char*)malloc(len + 1);

    if (str == NULL)
    {
        fprintf(stderr, "Unable to allocate memory for string\n");
        exit(-1);
    }

    va_end(args);
    va_start(args, format);

    if (vsnprintf(str, len + 1, format, args) != len)
    {
        fprintf(stderr, "Unexpected string length\n");
        exit(-1);
    }

    va_end(args);

    str[len] = '\0';
    return str;
}
