#include <stdlib.h>
#include <stdio.h>
#include <string.h>

char *mat[102] ={
"000000", "ADD",        //0
"000001", "ADDI",       //1
"000010", "ADDIU",      //2
"000011", "ADDU",       //3
"000100", "AND",        //4
"000101", "ANDI",       //5
"000110", "BEQ",        //6
"000111", "BGEZ",       //7
"100011", "BGEZAL",     //8
"001001", "BGTZ",       //9
"001010", "BLEZ",       //10
"001011", "BLTZ",       //11
"101000", "BLTZAL",     //12
"001101", "BNE",        //13
"001110", "BREAK",      //14
"001111", "COP0",       //15
"010000", "J",          //16
"010001", "JAL",        //17
"010010", "JALR",       //18
"010011", "JR",         //19
"010100", "LUI",        //20
"010101", "LW",         //21
"010110", "LWC0",       //22
"010111", "MFC0",       //23
"011000", "MFHI",       //24
"011001", "MFLO",       //25
"011010", "MTC0",       //26
"011011", "MTHI",       //27
"011100", "MTLO",       //28
"011101", "MULT",       //29
"011110", "MULTU",      //30
"011111", "NOR",        //31
"100000", "OR",         //32
"100001", "ORI",        //33
"100010", "SLL",        //34
"100011", "SLLV",       //35
"100100", "SLT",        //36
"100101", "SLTI",       //37
"100110", "SLTIU",      //38
"100111", "SLTU",       //39
"101000", "SRA",        //40
"101001", "SRAV",       //41
"101010", "SRL",        //42
"101011", "SRLV",       //43
"101100", "SUB",        //44
"101101", "SUBU",       //45
"101110", "SW",         //46
"101111", "SWC0",       //47
"110000", "SYSC",       //48
"110001", "XOR",        //49
"110010", "XORI"        //50
};

int main(int argc, char ** argv)
{
	int i ;

	printf("instructions = {\n");

	for(i = 0; i < 102; i += 2)
		printf("'%s'\t\t: '%s',\t\t#%d\n", mat[i+1], mat[i], i/2);

	printf("}\n");
	return 0;
}
