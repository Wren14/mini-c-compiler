%token ID NUM IF ELSE relop
%right '='
%left '+' '-'
%left '*' '/'
%left UMINUS
%left '<' '>'
%nonassoc LOWER_THAN_ELSE

%%

if_statement :	IF '(' E ')' {call1();} '{' A '}'  OPT;

OPT: {call3();} %prec LOWER_THAN_ELSE
   | {call2();} ELSE '{' A '}'{call3();}
   ;

A : ID	{push();} '='	{push();} E {codegen_assign();} ';'
	|TEMP if_statement TEMP
   	;
TEMP: A
	| ;

E : E '+'	{push();} T	{codegen();} 
   |E '-'	{push();} T	{codegen();} 
   |E relop {push();} T	{codegen();}
   |T
   ;

T : T '*'	{push();} F	{codegen();}  
   | T '/'	{push();} F	{codegen();} 
   | F
   ;

F : '(' E ')'
   | '-'	{push();} F	{codegen_umin();} %prec UMINUS
   | ID		{push();}
   | NUM	{push();}
   ;
%%

#include "lex.yy.c"
#include<ctype.h>
char st[100][10];
int top=0;
char temp_number[2]="0";
char temp_name[2]="t";
int label[20];
int lnum=0;
int ltop=0;
int main()
{
	 yyparse();
	 return 0;
}

int push()
{
  	strcpy(st[++top],yytext);
  	return 0;
}

int codegen()
{
	 strcpy(temp_name,"t");
	 strcat(temp_name,temp_number);
	 printf("%s		%s		 %s		 %s\n",st[top-1],st[top-2],st[top],temp_name);
	 top-=2;
	 strcpy(st[top],temp_name);
	 temp_number[0]++;
	 return 0;
}

int codegen_umin()
{
	 strcpy(temp_name,"t");
	 strcat(temp_name,temp_number);
	 printf("UMINUS		%s				 %s\n",st[top],temp_name);
	 top--;
	 strcpy(st[top],temp_name);
	 temp_number[0]++;
	 return 0;
}

int codegen_assign()
{
	 printf("=		%s				 %s\n",st[top],st[top-2]);
	 top-=2;
	 return 0;
}

int call1()
{
	 lnum++;
	 strcpy(temp_name,"t");
	 strcat(temp_name,temp_number);
	 printf("==		%s		FALSE		L%d\n",st[top],lnum);
	 temp_number[0]++;
	 label[++ltop]=lnum;
	 return 0;
}

int call2()
{
	int x=label[ltop--];
	lnum++;
	printf("goto						 L%d\n",lnum);
	printf("L%d: \n",x);
	label[++ltop]=lnum;
	return 0;
}

int call3()
{
	int y=label[ltop--];
	printf("L%d: \n",y);
	return 0;
}
