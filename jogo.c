#include <stdio.h>
#include <time.h>

int myrand (){
	return rand ()%10;
}

int main(){
	srand(time (NULL));
	jogo();
	exit(0);
}
