%option noyywrap

%{

#define YY_DECL int yylex()

#include "viper.tab.h"

%}

%%

.   { fprintf(stderr, "Unexpected character: \'%s\'\n", yytext); exit(-1); }

%%
