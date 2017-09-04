#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define NO_CHANGES 		0
#define SWAP_WITH_ABOVE 1
#define SWAP_WITH_BELOW 2

void swapLines (char*, char*);


int main(int argc, char ** argv)
{
	int c = 0, i, operation;
	FILE *f1, *f2, *f3;
	char binCode[4];
	char **binFile;
	
	
	if (argc < 3 || argc > 4)
		fprintf(stderr, "Error while passing parameters.\n");
	
	else
	{
		f1 = fopen(argv[1], "rb");
		f2 = fopen(argv[2], "r");
		if (argc == 4)
			f3 = fopen(argv[3], "wb");
		else
			f3 = fopen("out.bin", "wb+");
		
		while (fread(binCode, 4, 1, f1))
			c++;
		rewind(f1);
		
		binFile = malloc(c * sizeof(char*));
		
		for (i = 0; i < c; i++)		
			binFile[i] = malloc(5 * sizeof(char));
		
		for (i = 0; i < c; i++)
			fread(binFile[i], 4, 1, f1);
		
		for (i = 0; i < c; i++)
		{
			fscanf(f2, "%d\n", &operation);
			switch(operation)
			{
				case 0:
					break;
				case 1:
					swapLines(binFile[i], binFile[i+1]);
					break;
				case 2:
					swapLines(binFile[i], binFile[i-1]);
					break;				
				default:					
					break;
			}
		}
		
		for (i = 0; i < c; i++)
			fwrite(binFile[i], 4, 1, f3); 
		
		fclose(f1);
		fclose(f2);
		fclose(f3);					
	}	
	return 0;
}

void swapLines (char* l1, char* l2)
{
	char tmp[4];
	memcpy(tmp, l1, 4);
	memcpy(l1, l2, 4);
	memcpy(l2, tmp, 4);
	}