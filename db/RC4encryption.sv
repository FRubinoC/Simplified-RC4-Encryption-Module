localparam NULL_CHAR = 8'h00;
 
module RC4encryption
(
	input clock,
	input rst_n,
	input [127:0] key,
	input valid_key,
	input [7:0] plaintext,
	input valid_din,
    output reg ready_for_key,
    output reg ready_for_plaintext,
	output reg [7:0] ciphertext,
	output reg valid_dout
);
 
// REGISTERS AND PARAMETERS
reg [7:0] permutation_box [0:255];
reg [7:0] i;
reg [3:0] i_mod_sixteen;
reg [7:0] j;
reg [7:0] l;
reg [127:0] used_key;
reg [2:0] status;

parameter S0 = 0;
parameter S1 = 1;
parameter S2_1 = 2;
parameter S2_2 = 3;
parameter S3 = 4;
parameter S4 = 5;
parameter S5 = 6;

//INITIALIZATION WITH A SEQUENTIAL NETWORK
always @(posedge clock or negedge rst_n)
begin
if(!rst_n) 
begin
	ready_for_key <= 1'b0;
	ready_for_plaintext <= 1'b0;
	ciphertext <= NULL_CHAR;
	valid_dout <= 1'b0;
	status <= S0;
end
else
begin
	case(status)
		S0:
    	begin
        	permutation_box[0] <= 8'b00000000;
			permutation_box[1] <= 8'b00000001;
			permutation_box[2] <= 8'b00000010;
			permutation_box[3] <= 8'b00000011;
			permutation_box[4] <= 8'b00000100;
			permutation_box[5] <= 8'b00000101;
			permutation_box[6] <= 8'b00000110;
			permutation_box[7] <= 8'b00000111;
			permutation_box[8] <= 8'b00001000;
			permutation_box[9] <= 8'b00001001;
			permutation_box[10] <= 8'b00001010;
			permutation_box[11] <= 8'b00001011;
			permutation_box[12] <= 8'b00001100;
			permutation_box[13] <= 8'b00001101;
			permutation_box[14] <= 8'b00001110;
			permutation_box[15] <= 8'b00001111;
			permutation_box[16] <= 8'b00010000;
			permutation_box[17] <= 8'b00010001;
			permutation_box[18] <= 8'b00010010;
			permutation_box[19] <= 8'b00010011;
			permutation_box[20] <= 8'b00010100;
			permutation_box[21] <= 8'b00010101;
			permutation_box[22] <= 8'b00010110;
			permutation_box[23] <= 8'b00010111;
			permutation_box[24] <= 8'b00011000;
			permutation_box[25] <= 8'b00011001;
			permutation_box[26] <= 8'b00011010;
			permutation_box[27] <= 8'b00011011;
			permutation_box[28] <= 8'b00011100;
			permutation_box[29] <= 8'b00011101;
			permutation_box[30] <= 8'b00011110;
			permutation_box[31] <= 8'b00011111;
			permutation_box[32] <= 8'b00100000;
			permutation_box[33] <= 8'b00100001;
			permutation_box[34] <= 8'b00100010;
			permutation_box[35] <= 8'b00100011;
			permutation_box[36] <= 8'b00100100;
			permutation_box[37] <= 8'b00100101;
			permutation_box[38] <= 8'b00100110;
			permutation_box[39] <= 8'b00100111;
			permutation_box[40] <= 8'b00101000;
			permutation_box[41] <= 8'b00101001;
			permutation_box[42] <= 8'b00101010;
			permutation_box[43] <= 8'b00101011;
			permutation_box[44] <= 8'b00101100;
			permutation_box[45] <= 8'b00101101;
			permutation_box[46] <= 8'b00101110;
			permutation_box[47] <= 8'b00101111;
			permutation_box[48] <= 8'b00110000;
			permutation_box[49] <= 8'b00110001;
			permutation_box[50] <= 8'b00110010;
			permutation_box[51] <= 8'b00110011;
			permutation_box[52] <= 8'b00110100;
			permutation_box[53] <= 8'b00110101;
			permutation_box[54] <= 8'b00110110;
			permutation_box[55] <= 8'b00110111;
			permutation_box[56] <= 8'b00111000;
			permutation_box[57] <= 8'b00111001;
			permutation_box[58] <= 8'b00111010;
			permutation_box[59] <= 8'b00111011;
			permutation_box[60] <= 8'b00111100;
			permutation_box[61] <= 8'b00111101;
			permutation_box[62] <= 8'b00111110;
			permutation_box[63] <= 8'b00111111;
			permutation_box[64] <= 8'b01000000;
			permutation_box[65] <= 8'b01000001;
			permutation_box[66] <= 8'b01000010;
			permutation_box[67] <= 8'b01000011;
			permutation_box[68] <= 8'b01000100;
			permutation_box[69] <= 8'b01000101;
			permutation_box[70] <= 8'b01000110;
			permutation_box[71] <= 8'b01000111;
			permutation_box[72] <= 8'b01001000;
			permutation_box[73] <= 8'b01001001;
			permutation_box[74] <= 8'b01001010;
			permutation_box[75] <= 8'b01001011;
			permutation_box[76] <= 8'b01001100;
			permutation_box[77] <= 8'b01001101;
			permutation_box[78] <= 8'b01001110;
			permutation_box[79] <= 8'b01001111;
			permutation_box[80] <= 8'b01010000;
			permutation_box[81] <= 8'b01010001;
			permutation_box[82] <= 8'b01010010;
			permutation_box[83] <= 8'b01010011;
			permutation_box[84] <= 8'b01010100;
			permutation_box[85] <= 8'b01010101;
			permutation_box[86] <= 8'b01010110;
			permutation_box[87] <= 8'b01010111;
			permutation_box[88] <= 8'b01011000;
			permutation_box[89] <= 8'b01011001;
			permutation_box[90] <= 8'b01011010;
			permutation_box[91] <= 8'b01011011;
			permutation_box[92] <= 8'b01011100;
			permutation_box[93] <= 8'b01011101;
			permutation_box[94] <= 8'b01011110;
			permutation_box[95] <= 8'b01011111;
			permutation_box[96] <= 8'b01100000;
			permutation_box[97] <= 8'b01100001;
			permutation_box[98] <= 8'b01100010;
			permutation_box[99] <= 8'b01100011;
			permutation_box[100] <= 8'b01100100;
			permutation_box[101] <= 8'b01100101;
			permutation_box[102] <= 8'b01100110;
			permutation_box[103] <= 8'b01100111;
			permutation_box[104] <= 8'b01101000;
			permutation_box[105] <= 8'b01101001;
			permutation_box[106] <= 8'b01101010;
			permutation_box[107] <= 8'b01101011;
			permutation_box[108] <= 8'b01101100;
			permutation_box[109] <= 8'b01101101;
			permutation_box[110] <= 8'b01101110;
			permutation_box[111] <= 8'b01101111;
			permutation_box[112] <= 8'b01110000;
			permutation_box[113] <= 8'b01110001;
			permutation_box[114] <= 8'b01110010;
			permutation_box[115] <= 8'b01110011;
			permutation_box[116] <= 8'b01110100;
			permutation_box[117] <= 8'b01110101;
			permutation_box[118] <= 8'b01110110;
			permutation_box[119] <= 8'b01110111;
			permutation_box[120] <= 8'b01111000;
			permutation_box[121] <= 8'b01111001;
			permutation_box[122] <= 8'b01111010;
			permutation_box[123] <= 8'b01111011;
			permutation_box[124] <= 8'b01111100;
			permutation_box[125] <= 8'b01111101;
			permutation_box[126] <= 8'b01111110;
			permutation_box[127] <= 8'b01111111;
			permutation_box[128] <= 8'b10000000;
			permutation_box[129] <= 8'b10000001;
			permutation_box[130] <= 8'b10000010;
			permutation_box[131] <= 8'b10000011;
			permutation_box[132] <= 8'b10000100;
			permutation_box[133] <= 8'b10000101;
			permutation_box[134] <= 8'b10000110;
			permutation_box[135] <= 8'b10000111;
			permutation_box[136] <= 8'b10001000;
			permutation_box[137] <= 8'b10001001;
			permutation_box[138] <= 8'b10001010;
			permutation_box[139] <= 8'b10001011;
			permutation_box[140] <= 8'b10001100;
			permutation_box[141] <= 8'b10001101;
			permutation_box[142] <= 8'b10001110;
			permutation_box[143] <= 8'b10001111;
			permutation_box[144] <= 8'b10010000;
			permutation_box[145] <= 8'b10010001;
			permutation_box[146] <= 8'b10010010;
			permutation_box[147] <= 8'b10010011;
			permutation_box[148] <= 8'b10010100;
			permutation_box[149] <= 8'b10010101;
			permutation_box[150] <= 8'b10010110;
			permutation_box[151] <= 8'b10010111;
			permutation_box[152] <= 8'b10011000;
			permutation_box[153] <= 8'b10011001;
			permutation_box[154] <= 8'b10011010;
			permutation_box[155] <= 8'b10011011;
			permutation_box[156] <= 8'b10011100;
			permutation_box[157] <= 8'b10011101;
			permutation_box[158] <= 8'b10011110;
			permutation_box[159] <= 8'b10011111;
			permutation_box[160] <= 8'b10100000;
			permutation_box[161] <= 8'b10100001;
			permutation_box[162] <= 8'b10100010;
			permutation_box[163] <= 8'b10100011;
			permutation_box[164] <= 8'b10100100;
			permutation_box[165] <= 8'b10100101;
			permutation_box[166] <= 8'b10100110;
			permutation_box[167] <= 8'b10100111;
			permutation_box[168] <= 8'b10101000;
			permutation_box[169] <= 8'b10101001;
			permutation_box[170] <= 8'b10101010;
			permutation_box[171] <= 8'b10101011;
			permutation_box[172] <= 8'b10101100;
			permutation_box[173] <= 8'b10101101;
			permutation_box[174] <= 8'b10101110;
			permutation_box[175] <= 8'b10101111;
			permutation_box[176] <= 8'b10110000;
			permutation_box[177] <= 8'b10110001;
			permutation_box[178] <= 8'b10110010;
			permutation_box[179] <= 8'b10110011;
			permutation_box[180] <= 8'b10110100;
			permutation_box[181] <= 8'b10110101;
			permutation_box[182] <= 8'b10110110;
			permutation_box[183] <= 8'b10110111;
			permutation_box[184] <= 8'b10111000;
			permutation_box[185] <= 8'b10111001;
			permutation_box[186] <= 8'b10111010;
			permutation_box[187] <= 8'b10111011;
			permutation_box[188] <= 8'b10111100;
			permutation_box[189] <= 8'b10111101;
			permutation_box[190] <= 8'b10111110;
			permutation_box[191] <= 8'b10111111;
			permutation_box[192] <= 8'b11000000;
			permutation_box[193] <= 8'b11000001;
			permutation_box[194] <= 8'b11000010;
			permutation_box[195] <= 8'b11000011;
			permutation_box[196] <= 8'b11000100;
			permutation_box[197] <= 8'b11000101;
			permutation_box[198] <= 8'b11000110;
			permutation_box[199] <= 8'b11000111;
			permutation_box[200] <= 8'b11001000;
			permutation_box[201] <= 8'b11001001;
			permutation_box[202] <= 8'b11001010;
			permutation_box[203] <= 8'b11001011;
			permutation_box[204] <= 8'b11001100;
			permutation_box[205] <= 8'b11001101;
			permutation_box[206] <= 8'b11001110;
			permutation_box[207] <= 8'b11001111;
			permutation_box[208] <= 8'b11010000;
			permutation_box[209] <= 8'b11010001;
			permutation_box[210] <= 8'b11010010;
			permutation_box[211] <= 8'b11010011;
			permutation_box[212] <= 8'b11010100;
			permutation_box[213] <= 8'b11010101;
			permutation_box[214] <= 8'b11010110;
			permutation_box[215] <= 8'b11010111;
			permutation_box[216] <= 8'b11011000;
			permutation_box[217] <= 8'b11011001;
			permutation_box[218] <= 8'b11011010;
			permutation_box[219] <= 8'b11011011;
			permutation_box[220] <= 8'b11011100;
			permutation_box[221] <= 8'b11011101;
			permutation_box[222] <= 8'b11011110;
			permutation_box[223] <= 8'b11011111;
			permutation_box[224] <= 8'b11100000;
			permutation_box[225] <= 8'b11100001;
			permutation_box[226] <= 8'b11100010;
			permutation_box[227] <= 8'b11100011;
			permutation_box[228] <= 8'b11100100;
			permutation_box[229] <= 8'b11100101;
			permutation_box[230] <= 8'b11100110;
			permutation_box[231] <= 8'b11100111;
			permutation_box[232] <= 8'b11101000;
			permutation_box[233] <= 8'b11101001;
			permutation_box[234] <= 8'b11101010;
			permutation_box[235] <= 8'b11101011;
			permutation_box[236] <= 8'b11101100;
			permutation_box[237] <= 8'b11101101;
			permutation_box[238] <= 8'b11101110;
			permutation_box[239] <= 8'b11101111;
			permutation_box[240] <= 8'b11110000;
			permutation_box[241] <= 8'b11110001;
			permutation_box[242] <= 8'b11110010;
			permutation_box[243] <= 8'b11110011;
			permutation_box[244] <= 8'b11110100;
			permutation_box[245] <= 8'b11110101;
			permutation_box[246] <= 8'b11110110;
			permutation_box[247] <= 8'b11110111;
			permutation_box[248] <= 8'b11111000;
			permutation_box[249] <= 8'b11111001;
			permutation_box[250] <= 8'b11111010;
			permutation_box[251] <= 8'b11111011;
			permutation_box[252] <= 8'b11111100;
			permutation_box[253] <= 8'b11111101;
			permutation_box[254] <= 8'b11111110;
			permutation_box[255] <= 8'b11111111;
			status <= S1;
			ready_for_key <= 1'b1;
			ready_for_plaintext <= 1'b0;
		end

		S1:
		begin
			if (valid_key)
			begin
				used_key <= key;
				status <= S2_1;
				i <= 0;
				i_mod_sixteen <= 0;
				ready_for_key <= 0;
				j <= 0;
			end
			else
			begin
				ready_for_key <= 1'b1;
				used_key <= 0;
				status <= S1;
			end
		end

		S2_1:
		begin
			j <= j + permutation_box[i] + used_key[i_mod_sixteen*8 +:8];
			status <= S2_2;
		end

		S2_2:
		begin
			permutation_box[i] <= permutation_box[j];
			permutation_box[j] <= permutation_box[i];
			if (i == 255)
			begin
				status <= S3;
			end
			else
			begin
				status <= S2_1;
				i <= i+1'b1;
				i_mod_sixteen <= i[3:0]+1'b1;
			end
		end

		// Now starts the encryption part
		S3:
		begin
			i <= 1;
			j <= permutation_box[1];
			status <= S4;
		end

		S4:
		begin
			//SWAP
			permutation_box[i] <= permutation_box[j];
			permutation_box[j] <= permutation_box[i];

			// I can do this because: S[i] + S[j] = S[j] + S[i] (Now that I have the l index I could encrypt if it's needed)
			l <= permutation_box[i] + permutation_box[j]; 
			ready_for_plaintext <= 1'b1;

			// I can already initialize the variables for the next round here (crucial to understand the logic and to have 
			// an output at every clock cycle). The condition is necessary because we must consider that the swap is not made yet.
			// For this reason, if we need a part of the permutation box that is not updated yet we must act in advance and
			// choose the right index. 
			i <= i+1'b1;
			if (j == i+1'b1)
			begin
				j <= j + permutation_box[i];
			end
			else
			begin
				j <= j + permutation_box[i+1'b1];
			end

			status <= S5;
		end

		/*After the state S4 the variable l is ready to be used to take the index of the key of
		  the next encryption. The variables i and j are ready to be used for the swap and for
		  the calculation of the l index. */

		S5:
		begin
			if(valid_din)
			begin
				ciphertext <= permutation_box[l] ^ plaintext;
				valid_dout <= 1'b1;
				
				// Now I make the swap operation
				permutation_box[i] <= permutation_box[j];
				permutation_box[j] <= permutation_box[i];

				//i and j have been set properly in the status S4
				l <= permutation_box[i] + permutation_box[j];

				// We set i and j properly for the next calculation of l and
				// for the swap
				i <= i+1'b1;
				if (j == i+1'b1)
				begin
					j <= j + permutation_box[i];
				end
				else
				begin
					j <= j + permutation_box[i+1'b1];
				end

				status <= S5;
			end
			else
			begin
				status <= S5;
				valid_dout <= 1'b0;
			end
		end
		default:
		begin
			status <= S0;
		end
	endcase
end   
end 
endmodule


