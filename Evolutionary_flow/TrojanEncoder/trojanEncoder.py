import sys

instructions = {
'ADD'		: '000000',		#0
'ADDI'		: '000001',		#1
'ADDIU'		: '000010',		#2
'ADDU'		: '000011',		#3
'AND'		: '000100',		#4
'ANDI'		: '000101',		#5
'BEQ'		: '000110',		#6
'BGEZ'		: '000111',		#7
'BGEZAL'	: '100011',		#8
'BGTZ'		: '001001',		#9
'BLEZ'		: '001010',		#10
'BLTZ'		: '001011',		#11
'BLTZAL'	: '101000',		#12
'BNE'		: '001101',		#13
'BREAK'		: '001110',		#14
'COP0'		: '001111',		#15
'J'		    : '010000',		#16
'JAL'		: '010001',		#17
'JALR'		: '010010',		#18
'JR'		: '010011',		#19
'LUI'		: '010100',		#20
'LW'		: '010101',		#21
'LWC0'		: '010110',		#22
'MFC0'		: '010111',		#23
'MFHI'		: '011000',		#24
'MFLO'		: '011001',		#25
'MTC0'		: '011010',		#26
'MTHI'		: '011011',		#27
'MTLO'		: '011100',		#28
'MULT'		: '011101',		#29
'MULTU'		: '011110',		#30
'NOR'		: '011111',		#31
'OR'		: '100000',		#32
'ORI'		: '100001',		#33
'SLL'		: '100010',		#34
'SLLV'		: '100011',		#35
'SLT'		: '100100',		#36
'SLTI'		: '100101',		#37
'SLTIU'		: '100110',		#38
'SLTU'		: '100111',		#39
'SRA'		: '101000',		#40
'SRAV'		: '101001',		#41
'SRL'		: '101010',		#42
'SRLV'		: '101011',		#43
'SUB'		: '101100',		#44
'SUBU'		: '101101',		#45
'SW'		: '101110',		#46
'SWC0'		: '101111',		#47
'SYSC'		: '110000',		#48
'XOR'		: '110001',		#49
'XORI'		: '110010',		#50
}

for instr in sys.argv[1:]:
    print(instr + " : "  + instructions[instr])
