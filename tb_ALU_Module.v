`timescale 1ns / 1ps 

module tb_ALU_Module;
	//parameters 
	parameter N = 8; 
	parameter M = 3; 
	
	//testbench signals (I/O)
	//Input Signals
	reg[N-1:0] Main_Input_A; 
	reg[N-1:0] Main_Input_B; 
	reg[M-1:0] Main_Opcode; 
	reg Main_Cin; 
	reg Main_Bin; 
	
	//Output Signals 
	wire[N-1:0] Main_Result; 
	wire Main_Cout; 
	wire Main_Bout; 
	
	//Module Connection 
	ALU_Module #(.N(N), .M(M)) uut(
		.Main_Input_A(Main_Input_A), 
		.Main_Input_B(Main_Input_B), 
		.Main_Opcode(Main_Opcode),
		.Main_Cin(Main_Cin), 
		.Main_Bin(Main_Bin), 
		.Main_Result(Main_Result),
		.Main_Cout(Main_Cout),
		.Main_Bout(Main_Bout)
	);
	
	// Main Testbenches 
	initial begin 
		//İnitial Values 
		Main_Input_A = 8'd0;
      Main_Input_B = 8'd0;
      Main_Opcode  = 3'b000;
      Main_Cin     = 1'b0;
      Main_Bin     = 1'b0; 
		
		//Automatic Random Test
		repeat (20) begin
            Main_Input_A = $urandom_range(0, 255);
            Main_Input_B = $urandom_range(0, 255);
            Main_Opcode  = $urandom_range(0, 7);
            Main_Cin     = $urandom_range(0, 1);
            Main_Bin     = $urandom_range(0, 1);
				#10;
        end
	end 
	
	//Write Values Display 
	initial begin
		$monitor("Zaman=%0t | Opcode=%b | A=%d | B=%d | Sonuc=%d | Cin=%b | Bin=%b |Cout=%b | Bout=%b", 
                 $time, Main_Opcode, Main_Input_A, Main_Input_B, Main_Result, Main_Cin, Main_Bin ,Main_Cout, Main_Bout);
	end
endmodule