%option noyywrap

%{

#define YY_DECL int yylex()

#include "viper.tab.h"

int row = 0;
int column = 0;

void count(void);

%}

%%

.   { fprintf(stderr, "Unexpected character: \'%s\' at line %i column %i\n", yytext, row + 1, column + 1); exit(-1); }

%%

void count(void)
{
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
