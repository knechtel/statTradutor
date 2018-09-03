%option noyywrap

%{

#include <stdio.h>
#include <string.h>
#include <math.h>



int numlines = 0;
int numchars = 0;
int ctlInteiro = 0;
int NUMBER_OF_STRINGS = 50000;
int STRING_LENGTH = 50000;
char swap[4000];
char strs[50000][50000];

int variableNumberOfElements   = 10;
int indexPalavreaDiferente     = 0;
char **arrayPalavras           = NULL;
char **arrayPalavrasDiferentes = NULL;

int palavrasDiferentes = 0;

int frasesCnt          = 0;
int palavraCnt         = 0;
int cntPa              = 0;


void palavrasDiferenteFree(){
    for(int i=0 ;i<indexPalavreaDiferente;i++){
       free(arrayPalavrasDiferentes[i]);
    }
}

void palavraDiferenteArrayFree(){
    free(arrayPalavrasDiferentes);
}
void addPalavraDiferente(char * palavra){
    indexPalavreaDiferente++;
    if(arrayPalavrasDiferentes==NULL)
        arrayPalavrasDiferentes = (char**) malloc(sizeof(char*) * 200);
    
    arrayPalavrasDiferentes[indexPalavreaDiferente-1] = (char*) malloc(sizeof(char)  * 20);
    strcpy(arrayPalavrasDiferentes[indexPalavreaDiferente-1], palavra);
}
int containsPalavraDiferente(char * palavra){
    
    for(int i =0; i < indexPalavreaDiferente; i++){
        if (strcmp (palavra,arrayPalavrasDiferentes[i] ) == 0){
            return 1;
        }
    }
    return 0;
}
void contPalavrasDiferentes(){
    int cnt = 0;
    for(int i =0;i< palavraCnt;i++){
        char* string  =arrayPalavras[i];
        
        for(int j =0;j< palavraCnt;j++){
            
            if (strcmp (string,arrayPalavras[j] ) == 0){
                if(containsPalavraDiferente(string)==0){
                    cnt++;
                    addPalavraDiferente(string);
                }
            }
            
        }
        if(cnt==1){
            palavrasDiferentes++;
        }
        cnt=0;
    }
    
    
}


void addPalavra(char * palavra){
    cntPa++;
    if(arrayPalavras==NULL)
        arrayPalavras = (char**) malloc(sizeof(char*) * 200);
    
    arrayPalavras[palavraCnt-1] = (char*) malloc(sizeof(char)  * 20);
    strcpy(arrayPalavras[palavraCnt-1], palavra);
}


void palavrasArrayFree(){
    free(arrayPalavras);
}

void palavrasFree(){
    for(int i =0;i< palavraCnt-1;i++){
        
        free(arrayPalavras[i]);
        
    }
}

%}




%s test

nomeInicioFrase [A-z]*
palavra [a-z]+
%%



"\."                       { frasesCnt++;                   }
{palavra}                  { palavraCnt++; addPalavra(yytext);   }
{nomeInicioFrase}          { palavraCnt++;   }



%%


int main(int argc, char *argv[]){
    yyin = fopen(argv[1], "r");

	yylex();
	fclose(yyin);
    contPalavrasDiferentes();
    printf("   <<     text.stat         >>\n");
    printf("cnt palavras = %d \n",palavraCnt);
    printf("cnt frases  = %d\n",frasesCnt);
    printf("cnt palavras  diferentes = %d\n",palavrasDiferentes);
    float media =(float)frasesCnt/palavraCnt;
    float densidade =(float)(palavrasDiferentes/palavraCnt)*100;
    printf("Palavras por frase = %.2f\n",media);
    printf("Densidade léxica = %.2f\n",densidade);
    palavrasFree();
    palavrasArrayFree();
    printf(" <<   fim   >>\n");

    palavrasDiferenteFree();
    palavraDiferenteArrayFree();
 
    
    return 0;
}
	
