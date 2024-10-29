/*** Definition Section ***/
%{
#include <string.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char token[257];
    int symbolTableCode;
}PIF;

typedef struct{
    char token[257];
    int index;
}ST;

ST SymbolTable[100];
int stLength = 0;

PIF ProgramInternalForm[300];
int pifLength = 0;

int errorFound = 0;
int lineNumber = 1;


int addToST(char* token) {
	for(int i = 0; i < stLength; i++) {
		
		if(strcmp(SymbolTable[i].token, token) == 0) {
		  return SymbolTable[i].index;
		}
	}
	strcpy(SymbolTable[stLength].token, token);
	SymbolTable[stLength].index = stLength;
	stLength++;
	
	return stLength - 1;
}

void addToPIF(char* token, int stCode) {
	strcpy(ProgramInternalForm[pifLength].token, token);
	ProgramInternalForm[pifLength].symbolTableCode = stCode;
	
	pifLength++;
}

void showSymbolTable() {
    printf("~~~~~~~ Symbol table ~~~~~~~\n");
    
    for(int i = 0 ; i < stLength; i++) {
        printf(" %s  %d\n", SymbolTable[i].token, SymbolTable[i].index);
    }
    
    printf("~~~~~~~ End ST ~~~~~~~\n\n");
}

void showProgramInternalForm() {
    printf("~~~~~~~ Program internal form ~~~~~~~\n");
    
    for(int i = 0; i < pifLength; i++) {
    
        printf(" %s  %d\n ", ProgramInternalForm[i].token, ProgramInternalForm[i].symbolTableCode);
    }
    
    printf("~~~~~~~ End PIF ~~~~~~~\n\n");
}

%}

ALPHA       [a-zA-Z]
DIGIT       [0-9]
REAL_NUMBER [+-]?(0|[1-9][0-9]*)(\.[0-9]+)?
IDENTIFIER  {ALPHA}({ALPHA}|{DIGIT}|_)*
INTEGER     [+-]?{DIGIT}+
FLOAT       [+-]?{DIGIT}+\.{DIGIT}+
CHAR        '{ALPHA}'|'{DIGIT}'
STRING      \"({ALPHA}|{DIGIT})+\"
OPERATOR    [+\-*/%^=<>!]=?|&&|\|\|
SEPARATOR   [\[\]{}();, ]
RESERVED    if|else|int|float|char|const|while|bool|for|string|cin|cout|struct

/*** Rule Section ***/
%%
					/* yytext is the text in the buffer */

if                                    	{ addToPIF(yytext, -1); }
while                                   { addToPIF(yytext, -1); }
float                                   { addToPIF(yytext, -1); }
for                                    	{ addToPIF(yytext, -1); }
else                                    { addToPIF(yytext, -1); }
int                                    	{ addToPIF(yytext, -1); }
char                                    { addToPIF(yytext, -1); }
bool                                    { addToPIF(yytext, -1); }
const                                   { addToPIF(yytext, -1); }
struct                                  { addToPIF(yytext, -1); }
cin                                     { addToPIF(yytext, -1); }
cout                                    { addToPIF(yytext, -1); }
\;                                    	{ addToPIF(yytext, -1); }
\(                                    	{ addToPIF(yytext, -1); }
\)                                    	{ addToPIF(yytext, -1); }
\,                                    	{ addToPIF(yytext, -1); }
\+                                    	{ addToPIF(yytext, -1); }
\-                                    	{ addToPIF(yytext, -1); }
\*                                    	{ addToPIF(yytext, -1); }
\/                                    	{ addToPIF(yytext, -1); }
\%                                    	{ addToPIF(yytext, -1); }
\>                                    	{ addToPIF(yytext, -1); }
\<                                    	{ addToPIF(yytext, -1); }
\>=                                    	{ addToPIF(yytext, -1); }
\<=                                    	{ addToPIF(yytext, -1); }
\=                                    	{ addToPIF(yytext, -1); }
\==                                    	{ addToPIF(yytext, -1); }
\and                                    { addToPIF(yytext, -1); }
\or                                    	{ addToPIF(yytext, -1); }
\.                                    	{ addToPIF(yytext, -1); }
\!=                                    	{ addToPIF(yytext, -1); }
{RESERVED}             			{ addToPIF(yytext, -1); }
{IDENTIFIER}				{ int stCode = addToST(yytext); addToPIF(yytext, stCode); }
{INTEGER}             			{ int stCode = addToST(yytext); addToPIF(yytext, stCode); }
{FLOAT}               			{ int stCode = addToST(yytext); addToPIF(yytext, stCode); }
{CHAR}                			{ int stCode = addToST(yytext); addToPIF(yytext, stCode); }
{STRING}              			{ int stCode = addToST(yytext); addToPIF(yytext, stCode); }
{SEPARATOR}           			{ addToPIF(yytext, -1); }
[\n]					{ ++lineNumber; }
[ \t\n]+             			{ ; /* eat up whitespace */ }
.                			{ errorFound = 1; printf("Illegal token %s at line %d !", yytext, lineNumber); printf("\n"); }
%%

/* yywrap() - wraps the above rule section */
int yywrap() {}

int main(int argc, char** argv) {

	FILE *fp;
	fp = fopen(argv[1], "r");
	
	/* yyin - takes the file pointer which contains the input*/
	yyin = fp;

	/* yylex() - this is the main flex function which runs the Rule Section*/ 
	yylex();
	
	if (errorFound == 0) {
    		showSymbolTable();
    		showProgramInternalForm();
	}
  
	return 0;
}
