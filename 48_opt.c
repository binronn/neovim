#include <memory.h>
#include <stdio.h>
#include <stdlib.h>

#define DWORD unsigned int
#define BYTE unsigned char

BYTE g_byte_20000048[16];

/*char status[] = {0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0};*/
char status[] = {0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,1,1,1,1,0,1,0,0,0,0,1,1,0,1,0,1,0,1,0,1,0,1,0,1,1,0,0,1,1,1,1,1,0,1,1,1,0,0,0,0};
char status_count = 0;

int Chip48_CsCodeAlg_sub_802F280(DWORD *a1_cscode, DWORD *a2_random)
{
	char v2;		  // r3@1
	int v3;			  // r4@1
	char v4;		  // r2@1
	int v5;			  // r4@5
	unsigned int v6;  // r2@5
	int v7;			  // r3@5
	int v8;			  // r3@7
	int v9;			  // r4@7
	int v10;		  // r0@9
	int v11;		  // r3@9

	v2 = 0;
	v4 = 0;
	if (a1_cscode[2] & 0x80000000)
		v2 = 1;
	if (a2_random[1] & 0x800000)
		v4 = 1;
	v6				   = (unsigned char)(v4 + v2 + g_byte_20000048[6]);
	g_byte_20000048[6] = (v6 >> 1) & 1;

	/*printf("%02x,", v6);*/

	a1_cscode[2] = 2 * a1_cscode[2];
	if (a1_cscode[1] & 0x80000000)
		a1_cscode[2] = a1_cscode[2] | 1;

	a1_cscode[1] = 2 * a1_cscode[1];
	if (a1_cscode[0] & 0x80000000)
		a1_cscode[1] = a1_cscode[1] | 1;

	a1_cscode[0] = 2 * a1_cscode[0];

	a2_random[1] = 2 * a2_random[1];
	if (a2_random[0] & 0x80000000)
		a2_random[1] = a2_random[1] | 1;

	a2_random[0] = 2 * a2_random[0];

	int result = status[status_count++];;
	/*if(status_count < 52)*/
		/*result = (~v6 & 1);*/
	printf("%x,", result);
	return result;
}
int Chip48_CsCodeAlg_sub_802F0DE()
{
	char v0;  // r0@1

	v0 = 0;
	if (g_byte_20000048[8] & 4)
		v0 = 1;
	if (g_byte_20000048[9] & 0x1)
		v0 = ~v0;
	if (g_byte_20000048[9] & 0x10)
		v0 = ~v0;
	return v0 & 1;
}
int Chip48_CsCodeAlg_sub_802F24C()
{
	signed int v0;	// r0@1
	BYTE bAddr_0x806374E[] = {0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 1};

	v0 = 0;
	if (g_byte_20000048[8] & 2)
		v0 = 1;
	if (g_byte_20000048[9] & 1)
		v0 |= 2u;
	if (g_byte_20000048[9] & 2)
		v0 |= 4u;
	if (g_byte_20000048[9] & 8)
		v0 |= 8u;
	if (g_byte_20000048[9] & 0x10)
		v0 |= 0x10u;
	return bAddr_0x806374E[v0];
}
int Chip48_CsCodeAlg_sub_802EE9C()
{
	signed int v0;	 // r1@1
	int v1;			 // r0@1
	int v2;			 // r3@13
	signed int v3;	 // r1@13
	int v4;			 // r5@25
	signed int v5;	 // r1@25
	int v6;			 // r6@37
	signed int v7;	 // r0@43
	char v8;		 // r3@53
	signed int v9;	 // r0@59
	signed int v10;	 // r0@77
	signed int v11;	 // r0@89
	signed int v12;	 // r0@101
	BYTE bAddr_0x806354E[] = {0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1,
							  1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 0, 1,
							  0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 0,
							  0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0};
	BYTE bAddr_0x806358E[] = {1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 1, 1,
							  0, 1, 1, 0, 0, 1, 1, 1, 0, 1, 1, 0, 0, 1, 1, 1, 1,
							  0, 1, 0, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0,
							  1, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0};
	BYTE bAddr_0x80635CE[] = {0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0,
							  0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 1, 0,
							  1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0, 1,
							  0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0};
	BYTE bAddr_0x806372E[] = {1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 1};
	BYTE bAddr_0x806370E[] = {1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 0, 1, 1, 0};
	BYTE bAddr_0x806352E[] = {1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1};
	BYTE bAddr_0x806360E[] = {0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1,
							  1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 0,
							  1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1,
							  0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0,
							  0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1,
							  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0,
							  0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1,
							  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1,
							  0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
							  1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0,
							  1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1,
							  0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 0,
							  0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0,
							  0, 0, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0,
							  0, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0};

	v0 = 0;
	v1 = *(DWORD *)&g_byte_20000048[12];
	if (g_byte_20000048[12] & 1)
		v0 = 1;
	if (g_byte_20000048[12] & 0x10)
		v0 |= 2u;
	if (g_byte_20000048[14] & 0x04)
		v0 |= 4u;
	if (g_byte_20000048[8] & 8)
		v0 |= 8u;
	if (g_byte_20000048[13] & 0x20)
		v0 |= 0x10u;
	if (g_byte_20000048[12] & 0x40)
		v0 |= 0x20u;
	v2				   = bAddr_0x806354E[v0];
	v3				   = 0;
	g_byte_20000048[3] = v2;
	if (g_byte_20000048[8] & 1)
		v3 = 1;
	if (g_byte_20000048[8] & 0x80)
		v3 |= 2u;
	if (g_byte_20000048[12] & 2)
		v3 |= 4u;
	if (g_byte_20000048[13] & 0x4)
		v3 |= 8u;
	if (g_byte_20000048[13] & 0x80)
		v3 |= 0x10u;
	if (g_byte_20000048[12] & 0x20)
		v3 |= 0x20u;
	v4				   = bAddr_0x806358E[v3];
	v5				   = 0;
	g_byte_20000048[4] = v4;
	if (g_byte_20000048[12] & 4)
		v5 = 1;
	if (g_byte_20000048[12] & 8)
		v5 |= 2u;
	if (v1 & 0x10000)
		v5 |= 4u;
	if (g_byte_20000048[13] & 0x02)
		v5 |= 8u;
	if (g_byte_20000048[13] & 0x40)
		v5 |= 0x10u;
	if (g_byte_20000048[8] & 2)
		v5 |= 0x20u;
	v6				   = bAddr_0x80635CE[v5];
	g_byte_20000048[5] = v6;
	if (v1 & 0x400000)
		v2 = 1 ^ v2;
	if (g_byte_20000048[2] & 4)
		v2 = 1 ^ v2;
	if (g_byte_20000048[2] & 0x40)
		v2 = 1 ^ v2;
	v7 = 0;
	if (g_byte_20000048[0] & 8)
		v7 = 1;
	if (g_byte_20000048[0] & 4)
		v7 |= 2u;
	if (v2 & 1)
		v7 |= 4u;
	if (g_byte_20000048[0] & 0x40)
		v7 |= 8u;
	if (g_byte_20000048[0] & 1)
		v7 |= 0x10u;
	v8 = bAddr_0x806370E[v7];
	if (g_byte_20000048[0] & 0x40)
		v4 = 1 ^ v4;
	if (g_byte_20000048[0] & 1)
		v4 = 1 ^ v4;
	if (g_byte_20000048[0] & 8)
		v4 = 1 ^ v4;
	v9 = 0;
	if (g_byte_20000048[1] & 1)
		v9 = 1;
	if (v4 & 1)
		v9 |= 2u;
	if (g_byte_20000048[0] & 0x20)
		v9 |= 4u;
	if (g_byte_20000048[1] & 2)
		v9 |= 8u;
	if (g_byte_20000048[0] & 0x10)
		v9 |= 0x10u;
	if (bAddr_0x806372E[v9])
		v8 = 1 ^ v8;
	if (g_byte_20000048[1] & 0x40)
		v6 = 1 ^ v6;
	if (g_byte_20000048[1] & 1)
		v6 = 1 ^ v6;
	if (g_byte_20000048[1] & 8)
		v6 = 1 ^ v6;
	v10 = 0;
	if (g_byte_20000048[2] & 2)
		v10 = 1;
	if (v6 & 1)
		v10 |= 2u;
	if (g_byte_20000048[1] & 0x20)
		v10 |= 4u;
	if (g_byte_20000048[1] & 8)
		v10 |= 8u;
	if (g_byte_20000048[2] & 8)
		v10 |= 0x10u;
	if (bAddr_0x806372E[v10])
		v8 = 1 ^ v8;
	v11 = 0;
	if (g_byte_20000048[2] & 1)
		v11 = 1;
	if (g_byte_20000048[2] & 0x20)
		v11 |= 2u;
	if (g_byte_20000048[2] & 0x10)
		v11 |= 4u;
	if (g_byte_20000048[2] & 0x40)
		v11 |= 8u;
	if (g_byte_20000048[2] & 4)
		v11 |= 0x10u;
	if (bAddr_0x806352E[v11])
		v8 = 1 ^ v8;
	v12 = 0;
	if (g_byte_20000048[0] & 0x40)
		v12 = 1;
	if (g_byte_20000048[1] & 2)
		v12 |= 2u;
	if (g_byte_20000048[2] & 1)
		v12 |= 4u;
	if (g_byte_20000048[0] & 1)
		v12 |= 8u;
	if (g_byte_20000048[2] & 8)
		v12 |= 0x10u;
	if (g_byte_20000048[2] & 0x20)
		v12 |= 0x20u;
	if (g_byte_20000048[0] & 0x10)
		v12 |= 0x40u;
	if (g_byte_20000048[1] & 8)
		v12 |= 0x80u;
	if (bAddr_0x806360E[v12])
		v8 = 1 ^ v8;
	return v8 & 1;
}
signed int Chip48_CsCodeAlg_sub_802F21A(DWORD *a1_cscode)
{
	int v1;			// r2@1
	signed int v2;	// r1@1
	int v3;			// r2@3
	int v4;			// r3@3
	int v5;			// r3@5
	int v6;			// r2@5

	v2 = 0;
	if (a1_cscode[2] & 0x80000000)
		v2 = 1;
	a1_cscode[2] = 2 * a1_cscode[2];
	if (a1_cscode[1] & 0x80000000)
		a1_cscode[2] = a1_cscode[2] | 1;
	a1_cscode[1] = 2 * a1_cscode[1];
	if (a1_cscode[0] & 0x80000000)
		a1_cscode[1] = a1_cscode[1] | 1;
	a1_cscode[0] = 2 * a1_cscode[0];
	return v2;
}
int Chip48_CsCodeAlg_sub_802F100(int a1, int a2, int a3, int a4)
{
	signed int v5;	 // r4@1
	signed int v8;	 // r6@1
	int v9;			 // r0@3
	signed int v10;	 // r3@3
	int v12;		 // r1@8
	int v13;		 // r0@10
	signed int v14;	 // r5@12
	int v15;		 // r2@35
	int v16;		 // r0@37
	int result;		 // r0@39

	v5	= 0;
	v10 = 0;
	v8	= 0;
	if (g_byte_20000048[14] & 0x40)	 // 109
		v8 = 1;
	v9 = Chip48_CsCodeAlg_sub_802F0DE();
	if (a3)
	{
		if (g_byte_20000048[0] & 2)	 // 2
			v9 = 1 ^ v9;
		if (g_byte_20000048[1] & 0x40)	// 5
			v9 = 1 ^ v9;
	}
	v12 = 2 * *(DWORD *)&g_byte_20000048[12];
	*(DWORD *)&g_byte_20000048[12] *= 2;
	if (v9 & 1)
		*(DWORD *)&g_byte_20000048[12] = v12 | 1;
	v13							  = 2 * *(DWORD *)&g_byte_20000048[8] ^ 2;	// 58
	*(DWORD *)&g_byte_20000048[8] = 2 * *(DWORD *)&g_byte_20000048[8] ^ 2;
	if (a1 & 1)
		*(DWORD *)&g_byte_20000048[8] = v13 | 1;
	v14 = v8;
	if (g_byte_20000048[0] & 0x40)	// 5
		v5 = 1;
	if (g_byte_20000048[1] & 0x40)	// 15
		v10 = 1;
	if (a3)
	{
		if (g_byte_20000048[3] & 1)	 // 17
			v14 = 1 ^ v8;
		if (g_byte_20000048[2] & 4)	 // 11
			v14 = 1 ^ v14;
		if (g_byte_20000048[2] & 0x40)	// 15
			v14 = 1 ^ v14;
		if (g_byte_20000048[4] & 1)	 // 25
			v5 = 1 ^ v5;
		if (g_byte_20000048[0] & 1)	 // 1
			v5 = 1 ^ v5;
		if (g_byte_20000048[0] & 8)	 // 8
			v5 = 1 ^ v5;
		if (g_byte_20000048[5] & 1)	 // 33
			v10 = 1 ^ v10;
		if (g_byte_20000048[1] & 1)	 // 9
			v10 = 1 ^ v10;
		if (g_byte_20000048[1] & 8)	 // 16
			v10 = 1 ^ v10;
	}
	v15 = 2 * g_byte_20000048[2] & 0xFF;
	g_byte_20000048[2] *= 2;
	if (v10 & 1)
		g_byte_20000048[2] = v15 | 1;
	v16 = 2 * g_byte_20000048[1] & 0xFF;
	g_byte_20000048[1] *= 2;
	if (v5 & 1)
		g_byte_20000048[1] = v16 | 1;
	result = 2 * g_byte_20000048[0] & 0xFF;
	g_byte_20000048[0] *= 2;
	if (v14 & 1)
	{
		result |= 1u;
		g_byte_20000048[0] = result;
	}
	if (v8 & a2)
	{
		result = *(DWORD *)&g_byte_20000048[12] ^ 0x12069;
		*(DWORD *)&g_byte_20000048[12] ^= 0x12069u;
	}
	if (a4)
	{
		result = *(DWORD *)&g_byte_20000048[12] ^ 8;
		*(DWORD *)&g_byte_20000048[12] ^= 8u;
	}
	return result;
}

int Chip48_CsCodeAlg_0(DWORD *a1_cscode, DWORD *a2_random, DWORD *a3_out)
{
	DWORD *v3_random;  // r6@1
	DWORD *v4_cscode;  // r7@1
	DWORD *v5_out;	   // r4@1
	unsigned int v6;   // r5@1
	int v7_ret;		   // r0@2
	unsigned int v8;   // r5@3
	int v9;			   // r0@4
	int v10;		   // r0@5
	unsigned int v11;  // r5@5
	int v12;		   // r6@6
	int v13;		   // r0@6
	unsigned int v14;  // r5@7
	int v15;		   // r6@8
	int v16;		   // r0@8
	unsigned int v17;  // r5@11
	int v18;		   // r6@12
	int v19;		   // r0@12
	int result;		   // r0@12

	char tmp[] = {0x83,0x1f,0x01,0x01,0xFE,0x00,0xFF,0xFF,0x3e,0x00,0xFF,0xFF,0x07,0x00,0x00,0xFF};
	v3_random		   = a2_random;
	v4_cscode		   = a1_cscode;
	v5_out			   = a3_out;
	g_byte_20000048[6] = 0;
	v6				   = 0;

#if 1
	printf("status: ");
	do
	{
		v7_ret = Chip48_CsCodeAlg_sub_802F280(v4_cscode, v3_random);
		Chip48_CsCodeAlg_sub_802F100(v7_ret, 0, 0, 0);
		++v6;
	} while (v6 < 0x25);

	/*printf("g_b:");*/
	/*for (int i = 0; i < 0x10; i++)*/
	/*{*/
		/*printf("%02x,", g_byte_20000048[i]);*/
	/*}*/
	/*printf("\n");*/

	v8 = 0;
	do
	{
		v9 = Chip48_CsCodeAlg_sub_802F280(v4_cscode, v3_random);
		Chip48_CsCodeAlg_sub_802F100(v9, 1, 0, 0);
		++v8;
	} while (v8 < 0x13);

	printf("\n");

	/*printf("g_b:");*/
	/*for (int i = 0; i < 0x10; i++)*/
	/*{*/
		/*printf("%02x,", g_byte_20000048[i]);*/
	/*}*/
	/*printf("\n");*/

	v10 = Chip48_CsCodeAlg_sub_802F21A(v4_cscode);
	Chip48_CsCodeAlg_sub_802F100(1, 1, 0, v10);
	Chip48_CsCodeAlg_sub_802EE9C();
	v11 = 0;

	do
	{
		v12 = Chip48_CsCodeAlg_sub_802F24C();
		v13 = Chip48_CsCodeAlg_sub_802F21A(v4_cscode);
		Chip48_CsCodeAlg_sub_802F100(v12, 1, 1, v13);
		Chip48_CsCodeAlg_sub_802EE9C();
		++v11;
	} while (v11 < 6);
#endif


	printf("g_b:");
	for (int i = 0; i < 0x10; i++)
	{
		printf("%02x,", g_byte_20000048[i]);
	}
	printf("\n");


#if 1
	v14 = 0;
	do
	{
		v15 = Chip48_CsCodeAlg_sub_802F24C();
		v16 = Chip48_CsCodeAlg_sub_802F21A(v4_cscode);
		Chip48_CsCodeAlg_sub_802F100(v15, 1, 1, v16);
		v5_out[1] *= 2;
		if (Chip48_CsCodeAlg_sub_802EE9C())
			v5_out[1] |= 1u;
		++v14;
	} while (v14 < 0x1C);
	v17 = 0;

	v10 = Chip48_CsCodeAlg_sub_802F21A(v4_cscode);
	Chip48_CsCodeAlg_sub_802F100(1, 1, 0, v10);
	Chip48_CsCodeAlg_sub_802EE9C();
	v11 = 0;
#endif

#if 1

	do
	{
		v18 = Chip48_CsCodeAlg_sub_802F24C();
		v19 = Chip48_CsCodeAlg_sub_802F21A(v4_cscode);
		Chip48_CsCodeAlg_sub_802F100(v18, 1, 1, v19);
		v5_out[0] *= 2;
		result = Chip48_CsCodeAlg_sub_802EE9C();
		if (result)
		{
			result	  = v5_out[0] | 1;
			v5_out[0] = result;
		}
		++v17;
	} while (v17 < 0x14);
#else
	result = 6;
#endif

	/*printf("g_b:");*/
	/*for (int i = 0; i < 0x10; i++)*/
	/*{*/
	/*printf("%02x,", g_byte_20000048[i]);*/
	/*}*/
	printf("\n");
	return result;
}

/**********************************************************************
bRandomData: ?7??????
bCsCode: ?12???CS?
bRet: ????7???
**********************************************************************/
int Chip48_CsCodeAlg(BYTE *bRandomData, BYTE *bCsCode, BYTE *bRet)
{
	BYTE *v3;
	BYTE *v4;
	int v5;
	unsigned int v6;
	unsigned int v7;
	signed int result;
	int i;
	DWORD v9_out[2] = {0};
	DWORD v11_cscode[3];
	DWORD v12_random[2];

	for (i = 0; i < 16; i++)
	{
		g_byte_20000048[i] = 0;
	}
	v3			  = bRandomData;
	v9_out[0]	  = 0;
	v4			  = bRet;
	v11_cscode[2] = bCsCode[0] * 0x1000000 | bCsCode[1] * 0x10000 | bCsCode[2] * 0x100 | bCsCode[3];
	v11_cscode[1] = bCsCode[4] * 0x1000000 | bCsCode[5] * 0x10000 | bCsCode[6] * 0x100 | bCsCode[7];
	v11_cscode[0] = bCsCode[8] * 0x1000000 | bCsCode[9] * 0x10000 | bCsCode[10] * 0x100 | bCsCode[11];
	v12_random[1] = (*bRandomData << 16) | (v3[1] << 8) | v3[2];
	v12_random[0] = bRandomData[3] * 0x1000000 | bRandomData[4] * 0x10000 | bRandomData[5] * 0x100 | bRandomData[6];
	Chip48_CsCodeAlg_0(v11_cscode, v12_random, v9_out);
	v5	   = v9_out[1] >> 24;
	v3[7]  = v9_out[1] >> 24;
	v3[8]  = v9_out[1] >> 16;
	v3[9]  = v9_out[1] >> 8;
	v3[10] = v9_out[1];
	v3[7]  = 16 * v5;
	v6	   = (BYTE)(v9_out[0] >> 8);
	v7	   = v9_out[0];
	v3[11] = (v6 >> 4) | 16 * (v9_out[0] >> 16);
	v3[12] = (v7 >> 4) | 16 * v6;
	v3[13] = 16 * v7;
	result = 0;
	do
	{
		v4[result] = v3[result + 7];
		result	   = result + 1;
	} while (result < 7);
	return result;
}

unsigned short Chip48_CS_KEY_C_C(BYTE *bcs, unsigned short wLen)
{
	BYTE bMsk1[8] = {1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80};
	BYTE bMsk2[8] = {0x80, 0x40, 0x20, 0x10, 8, 4, 2, 1};
	int i, j;
	BYTE bTemp;
	for (i = 0; i < wLen; i++)
	{
		bTemp  = bcs[i];
		bcs[i] = 0;
		j	   = 0;
		do
		{
			if (bTemp & bMsk1[j])
			{
				bcs[i] |= bMsk2[j];
			}
		} while (++j < 8);
	}
	return wLen;
}

unsigned int cscode_make(unsigned char *cscode, unsigned int mode)
{
	switch (mode)
	{
		case 7:
			*(unsigned short *)&cscode[6] = 0x0;
			break;
		case 8:
			*(unsigned short *)&cscode[8] = 0x0;
			break;
		case 9:
			*(unsigned short *)&cscode[10] = 0x0;
			break;
		default:
			return 1;
	}

	return 0;
}

unsigned char *sub_8028880(unsigned char *result)
{
	unsigned int v1;  // r1

	v1		= *result;
	*result = (v1 << 7) | (32 * (v1 & 2)) | (8 * (v1 & 4)) | (2 * (v1 & 8)) | (v1 >> 1) & 8 | (v1 >> 3) & 4 | (v1 >> 5) & 2 | (v1 >> 7);
	return result;
}

unsigned int random_make(unsigned char *random, unsigned int i, unsigned int mode)
{
	unsigned short v8;	   // r6
	unsigned short v9;	   // r5
	unsigned short v10;	   // r12
	unsigned short v11;	   // r0
	unsigned int j;		   // r5
	unsigned int *result;  // r0

	sub_8028880(random);
	sub_8028880((unsigned char *)random + 1);
	sub_8028880((unsigned char *)random + 2);
	sub_8028880((unsigned char *)random + 3);
	sub_8028880((unsigned char *)random + 4);
	sub_8028880((unsigned char *)random + 5);
	sub_8028880((unsigned char *)random + 6);

	v10 = *((unsigned short *)random);
	v8	= *((unsigned short *)random + 1);
	v9	= *((unsigned short *)random + 2);
	v11 = *((unsigned char *)random + 6);

	if (mode == 7)
	{
		v9 += i;
	}
	else
	{
		if (mode == 8)
		{
			v8 += i;
		}
		else
		{
			if (mode != 9)
			{
				// todo
			}
			v10 += i;
			if ((v10 & 0x10000) != 0)
				++v8;
		}
		if ((v8 & 0x10000) != 0)
			++v9;
	}
	if ((v9 & 0x10000) != 0)
		++v11;

	*(unsigned short *)random		= v10;
	*((unsigned short *)random + 1) = v8;
	*((unsigned short *)random + 2) = v9;
	*((unsigned char *)random + 6)	= v11;

	for (j = 0; j < 7; j = (j + 1))
		sub_8028880(random + j);

	return 0;
}

unsigned long long bins2long(unsigned char bins[], unsigned int size)
{
	unsigned long long result = 0;

	for (int i = size - 1, j = 0; i >= 0 && j <= 63; i--, j++)
	{
		unsigned long long bit = 1;
		if (bins[i] == 1)
			result |= bit << j;
	}

	return result;
}

void get_ints()
{
	// 0x4073eaea4f734f40
	BYTE bAddr_0x806354E[] = {0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1,
							  1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 0, 1,
							  0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 0,
							  0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0};
	// 0x808fb3b3d58fd580
	BYTE bAddr_0x806358E[] = {1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 1, 1,
							  0, 1, 1, 0, 0, 1, 1, 1, 0, 1, 1, 0, 0, 1, 1, 1, 1,
							  0, 1, 0, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0,
							  1, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0};
	// 0x4f43737aef4ae04
	BYTE bAddr_0x80635CE[] = {0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0,
							  0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 1, 0,
							  1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0, 1,
							  0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0};
	// 0x99a596c3
	BYTE bAddr_0x806372E[] = {1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 1};
	// 0x99a5c396
	BYTE bAddr_0x806370E[] = {1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 0, 1, 1, 0};
	// 0xf41a29c7
	BYTE bAddr_0x806352E[] = {1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1};
	// 0xec20ff20ec20ec20
	BYTE bAddr_0x806360E[] = {0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1,
							  1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 0,
							  1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1,
							  0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0,
							  0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1,
							  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0,
							  0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1,
							  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1,
							  0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
							  1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0,
							  1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1,
							  0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 0,
							  0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0,
							  0, 0, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0,
							  0, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0};

	unsigned long long result = bins2long(bAddr_0x806354E, sizeof(bAddr_0x806354E));
	printf("0x%llx\n", result);
	result = bins2long(bAddr_0x806358E, sizeof(bAddr_0x806358E));
	printf("0x%llx\n", result);
	result = bins2long(bAddr_0x80635CE, sizeof(bAddr_0x80635CE));
	printf("0x%llx\n", result);
	result = bins2long(bAddr_0x806372E, sizeof(bAddr_0x806372E));
	printf("0x%llx\n", result);
	result = bins2long(bAddr_0x806370E, sizeof(bAddr_0x806370E));
	printf("0x%llx\n", result);
	result = bins2long(bAddr_0x806352E, sizeof(bAddr_0x806352E));
	printf("0x%llx\n", result);
	result = bins2long(bAddr_0x806360E, sizeof(bAddr_0x806360E));
	printf("0x%llx\n", result);
	return;
}

int main()
{
	BYTE random[0x20], out[0x20];
	BYTE compare_1[0x7] = {0x70, 0x8b, 0x45, 0x76, 0x0f, 0x61};
	BYTE compare_2[0x7] = {0x20, 0x89, 0x6e, 0xb1, 0xde, 0xf6};
	int ret				= 0;

	/*BYTE cscode[]	= {0xB9, 0x04, 0x0E, 0xEC, 0xC4, 0x98, 0xDB, 0x08, 0xD3, 0xDD, 0x46, 0x74};*/
	BYTE cscode[]		  = {0xDB, 0x08, 0xD3, 0xDD, 0x46, 0x74, 0xB9, 0x04, 0x0E, 0xEC, 0xC4, 0x98};
	BYTE cscode_reverse[] = {0xdb, 0x10, 0xcb, 0xbb, 0x62, 0x2e, 0x9d, 0x20, 0x70, 0x37, 0x23, 0x19};
	BYTE random_1[]		  = {0x58, 0x22, 0xCD, 0xCE, 0x17, 0x20, 0x92};
	BYTE random_2[]		  = {0x2A, 0xB2, 0xA0, 0x19, 0x4F, 0xEB, 0xD4};

	memset(out, 0, 0x20);
	memset(random, 0, 0x20);
	memcpy(random, random_2, 0x7);
	memcpy(cscode, cscode, 12);
	cscode[11] = 0x01;
	/*cscode[10] = 0x00;*/
	/*cscode[9] = 0x00;*/
	/*cscode[8] = 0x00;*/
	/*cscode[7] = 0x00;*/
	/*cscode[6] = 0x00;*/

#if 0
	for (int i = 0, mode = 7; i < 0x10000; i++)
	{

		/*Chip48_CS_KEY_C_C(cscode, 12);*/
		cscode_make(cscode, mode);

		memcpy(random, random_1, 0x7);
		random_make(random, i, mode);
		ret = Chip48_CsCodeAlg(random, cscode, out);

		if(((out[3] & 0xF) != (compare_1[3] & 0xF)) && (out[4] != compare_1[4]) && (out[5] != compare_1[5]))
			continue;
#if 1
		memcpy(random, random_2, 0x7);
		random_make(random, i, mode);
		ret = Chip48_CsCodeAlg(random, cscode, out);

		if(((out[3] & 0xF) != (compare_2[3] & 0xF)) && (out[4] != compare_2[4]) && (out[5] != compare_2[5]))
			continue;
#endif

		printf("Finded equal i %04x\n", i);

		printf("cscode: ");
		for (int i = 0; i < 12; i++)
		{
			printf("%02x,", cscode[i]);
		}
		printf("\n");

		printf("out: ");
		for (int i = 0; i < 6; i++)
		{
			printf("%02x,", out[i]);
		}
		printf("\n");

		printf("\n");
	}
#else
	/*Chip48_CS_KEY_C_C(cscode, 12);*/

	/*for (int i = 0; i < 8 * 6 ; i++) {*/

		/*printf("---\n");*/

		/*cscode[0] = 0x80;*/
		/*random[0] = 0x80;*/

		/*for (int i = 0; i < 56; i++) {*/
		
		cscode[7] = 0x00;
		ret = Chip48_CsCodeAlg(random, cscode, out);

		printf("RESULT: ");
		for (int i = 0; i < 6; i++)
		{
			printf("%02x,", out[i]);
		}
		printf("\n\n");

		/*}*/


		/*printf("CSCODE: ");*/
		/*for (int i = 0; i < 12; i++)*/
		/*{*/
			/*printf("%02x,", cscode[i]);*/
		/*}*/
		/*printf("\n");*/

		/*printf("RANDOM: ");*/
		/*for (int i = 0; i < 7; i++)*/
		/*{*/
			/*printf("%02x,", random[i]);*/
		/*}*/
		/*printf("\n");*/
	/*}*/
#endif

	return 0;
}
