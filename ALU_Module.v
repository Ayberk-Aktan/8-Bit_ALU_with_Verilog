//8-Bit ALU with Verilog (Date : 16.10.2026) 

// 8x1 Multiplexer (MUX)
module mux_element #(parameter N = 8,parameter M = 3)(
			input wire[N-1:0] Adder_Result, 
			input wire[N-1:0] And_Result, 
			input wire[N-1:0] Or_Result, 
			input wire[N-1:0] Not_Result, 
			input wire[N-1:0] XOR_Result, 
			input wire[N-1:0] Substractor_Result, 
			input wire[N-1:0] Increment, 
			input wire[N-1:0] Decrement, 
			
			input wire[M-1:0] Opcode, 
			
			output reg[N-1:0] Output
	);  
	
	//Opcode Commands
	localparam ADD = 3'b000; 
	localparam AND = 3'b001; 
	localparam OR = 3'b010; 
	localparam NOT = 3'b011; 
	localparam XOR = 3'b100; 
	localparam SUB = 3'b101; 
	localparam INC = 3'b110; 
	localparam DEC = 3'b111; 
	
	always@(*) begin 
		case(Opcode)
			ADD : Output = Adder_Result; 
			AND : Output = And_Result; 
			OR : Output = Or_Result; 
			NOT : Output = Not_Result; 
			XOR : Output = XOR_Result; 
			SUB : Output = Substractor_Result; 
			INC : Output = Increment; 
			DEC : Output = Decrement;
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

//Increment and Decrement Unit
module inc_dec_unit #(parameter N = 8)(
		input wire[N-1:0] Input_A,
		output wire[N-1:0] Increment_A, Decrement_A
	);  
	
	assign Increment_A = Input_A + 1; 
	assign Decrement_A = Input_A - 1;
endmodule 

// Main ALU Module
module ALU_Module #(parameter N = 8,parameter M = 3)(
		input wire[N-1:0] Main_Input_A, 
		input wire[N-1:0] Main_Input_B, 
		input wire[M-1:0] Main_Opcode, 
		input wire Main_Cin, Main_Bin,
		
		output wire[N-1:0] Main_Result,
		output wire Main_Cout,Main_Bout
	);   
	
	wire[N-1:0] mfa_wire; //Adder Block to MUX wire  
	wire[N-1:0] and_wire, or_wire, not_wire, xor_wire; //Logical Unit to MUX wires
	wire[N-1:0] mfs_wire; // Subtractor Block to MUX wire
	wire[N-1:0] inc_wire, dec_wire; //Increment_Decrement Block to MUX wires
	
	//connect main full adder unit
	main_full_adder mfa_cell(
		.Main_Cin(Main_Cin),
		.Input_A(Main_Input_A), 
		.Input_B(Main_Input_B), 
		.Adder_Result(mfa_wire), 
		.Main_Cout(Main_Cout)
	); 
	
	//connect logic unit 
	logical_unit lu_cell(
		.Input_A(Main_Input_A), 
		.Input_B(Main_Input_B), 
		.And_Output(and_wire), 
		.Or_Output(or_wire), 
		.Not_Output(not_wire), 
		.XOR_Output(xor_wire)
	);  
	
	//connect main full subtractor unit 
	 main_full_subs mfs_cell(
		.Bin(Main_Bin),
		.Input_A(Main_Input_A), 
		.Input_B(Main_Input_B), 
		.Main_Subs_Result(mfs_wire), 
		.Bout(Main_Bout)
	 );  
	 
	 //connect increment_decrement (inc_dec) unit  
	 inc_dec_unit id_cell(
		.Input_A(Main_Input_A), 
		.Increment_A(inc_wire), 
		.Decrement_A(dec_wire)
	 );
	 
	 //connect all of the units to main MUX 
	 mux_element main_mux(
		.Adder_Result(mfa_wire),
		.And_Result(and_wire),
		.Or_Result(or_wire),
		.Not_Result(not_wire),
		.XOR_Result(xor_wire),
		.Substractor_Result(mfs_wire),
		.Increment(inc_wire),
		.Decrement(dec_wire),
		.Opcode(Main_Opcode),
		.Output(Main_Result)
	 ); 
endmodule
