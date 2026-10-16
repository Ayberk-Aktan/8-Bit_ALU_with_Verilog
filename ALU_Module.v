//8-Bit ALU with Verilog (Date : 16.10.2026) 

// 8x1 Multiplexer (MUX)
module mux_element #(parameter N = 8,parameter M = 3)(
			input wire[N-1:0] Adder_Result, 
			input wire[N-1:0] And_Result, 
			input wire[N-1:0] Or_Result, 
			input wire[N-1:0] Not_Result, 
			input wire[N-1:0] XOR_Result, 
			input wire[N-1:0] Substractor_Result, 
			input wire[N-1:0] Left_Shiftter, 
			input wire[N-1:0] Right_Shiftter, 
			
			input wire[M-1:0] Opcode, 
			
			output reg[N-1:0] Output
	);  
	
	always@(*) begin 
		case(Opcode)
			3'b000 : Output = Adder_Result; 
			3'b001 : Output = And_Result; 
			3'b010 : Output = Or_Result; 
			3'b011 : Output = Not_Result; 
			3'b100 : Output = XOR_Result; 
			3'b101 : Output = Substractor_Result; 
			3'b110 : Output = Left_Shiftter; 
			3'b111 : Output = Right_Shiftter;
		endcase
	end
endmodule

//* Logical Unit (AND,OR,NAND,XOR Gates)
module logical_unit #(parameter N=8)(
		input wire[N-1:0] Input_A, 
		input wire[N-1:0] Input_B, 
		
		output wire[N-1:0] And_Output, 
		output wire[N-1:0] Or_Output, 
		output wire[N-1:0] Not_Output, 
		output wire[N-1:0] XOR_Output
	);  
	
	assign And_Output = Input_A & Input_B; 
	assign Or_Output = Input_A | Input_B; 
	assign Not_Output = ~(Input_A); 
	assign XOR_Output = Input_A ^ Input_B;
endmodule 

//Full Adder Unit 
module full_adder_unit(
		input wire A,B,Cin, 
		output wire Add_Result,Cout 
	); 
	
	wire C = A ^ B; 
	wire D = A & B; 
	wire E = Cin & C; 
	
	assign Add_Result = C ^ Cin; 
	assign Cout = E | D;
endmodule 

//Main Full Adder Unit 
module main_full_adder #(parameter N=8)(
		input wire Main_Cin, 
		input wire[N-1:0] Input_A,Input_B, 
		
		output wire[N-1:0] Adder_Result, 
		output wire Main_Cout
	);  
	
	genvar i; 
	wire[N:0] Result_Space; 
	assign Result_Space[0] = Main_Cin; 
	
	generate
		for(i = 0; i<N; i = i + 1) begin:main_adder 
			full_adder_unit add_cell(
				.A(Input_A[i]), 
				.B(Input_B[i]), 
				.Cin(Result_Space[i]), 
				.Add_Result(Adder_Result[i]), 
				.Cout(Result_Space[i+1])
			);
		end
	endgenerate
	assign Main_Cout = Result_Space[N];
endmodule

//Full Substractor Unit 
module full_subs_unit(
		input wire A,B,Bin,
		output wire Subs_Result,Bout
	); 
	
	wire C = A ^ B; 
	wire F = (~A) & B; 
	wire E = Bin & (~C); 
	
	assign Subs_Result = C ^ Bin; 
	assign Bout = F | E;
endmodule 

//Main Full Substractor Unit 
module main_full_subs #(parameter N = 8)(
		input wire Bin, 
		input wire[N-1:0] Input_A,Input_B, 
		
		output wire[N-1:0] Main_Subs_Result, 
		output wire Bout
	); 
	
	wire[N:0] Subs_Space; 
	assign Subs_Space[0] = Bin;
	
	genvar i; 
	generate 
		for(i=0; i<N; i = i + 1) begin:main_subs
			full_subs_unit subs_cell(
					.A(Input_A[i]),
					.B(Input_B[i]), 
					.Bin(Subs_Space[i]), 
					.Subs_Result(Main_Subs_Result[i]), 
					.Bout(Subs_Space[i+1])
				);
		end
	endgenerate
	
	assign Bout = Subs_Space[N];
endmodule

//Shifter Unit 
module shifter_unit #(parameter N = 8)(
		input wire[N-1:0] Input_A,
		output wire[N-1:0] Left_Shift_A, Right_Shift_A
	);  
	
	assign Left_Shift_A = Input_A << 1; 
	assign Right_Shift_A = Input_A >> 1;
endmodule 

module ALU_Module #(parameter N = 8,parameter M = 3)(
		input wire[N-1:0] Main_Input_A, 
		input wire[N-1:0] Main_Input_B, 
		
		output wire[M-1:0] Main_Opcode, 
		output wire[N-1:0] Main Result
	);  
endmodule