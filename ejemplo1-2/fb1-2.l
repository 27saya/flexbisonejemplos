%option noyywrap
%{
#include <stdio.h>
%}

%%
"colour" { printf("color"); }
"flavour" { printf("flavor"); }
"clever" { printf("smart"); }
"smart" { printf("elegant"); }
"conservative" { printf("liberal"); }
. { printf("%s", yytext); }
%%

int main(int argc, char **argv)
{
    yylex();
    return 0;
}
