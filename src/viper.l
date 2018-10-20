%option noyywrap

%{

#define YY_DECL int yylex()

#include "viper.tab.h"

int row = 0;
int column = 0;
int eof = 0;

void count(void);

%}

%%

<<EOF>>                 { return eof++ == 0 ? NEWLINE : 0; }
[ \t\r]                 { count(); }
\n                      { count(); return NEWLINE; }
\"(\\.|[^"\\])*\"       { count(); yylval.str_val = strdup(yytext); return LIT_STRING; }
"print"                 { count(); return KW_PRINT; }
.                       { fprintf(stderr, "Unexpected character: \'%s\' at line %i column %i\n", yytext, row + 1, column + 1); exit(-1); }

%%

void count(void)
{
    // printf("[%s]\n", yytext);

	for (int i = 0; yytext[i] != '\0'; i++)
    {
        if (yytext[i] == '\n')
        {
			column = 0;
            row++;
        }
		else
        {
			column++;
        }
    }
}
