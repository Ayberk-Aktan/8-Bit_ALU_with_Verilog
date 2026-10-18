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
	
	//Expected Values 
	reg[N:0] expected; 
	
	//Test Counter 
	integer success= 0; 
	integer failed = 0; 
	
	integer i; //iteration variable 
	
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
		
		
		//Testing all opcodes sequentially. 
		for(i = 0; i<50; i = i + 1) begin
			Main_Opcode = i[2:0];
			Main_Input_A = $urandom_range(0,255); 
			Main_Input_B = $urandom_range(0,255); 
			
			//Checking the Carry and Borrow status according to the opcode.
			if(Main_Opcode == 3'b101) begin 
				Main_Bin = $urandom_range(0,1); 
			end 
			else begin 
				Main_Bin = 1'b0; 
			end
			
			if(Main_Opcode == 3'b000) begin 
					Main_Cin = $urandom_range(0,1);  
			end 
			else begin 
					Main_Cin = 1'b0;
			end 
			
			//Calculating Expected Values 
			case(Main_Opcode)
				3'b000 : expected =  {1'b0,Main_Input_A} + {1'b0,Main_Input_B} + Main_Cin; 
				3'b001 : expected = Main_Input_A & Main_Input_B; 
				3'b010 : expected = Main_Input_A | Main_Input_B; 
				3'b011 : expected = ~(Main_Input_A); 
				3'b100 : expected = Main_Input_A ^ Main_Input_B; 
				3'b101 : expected = {1'b0,Main_Input_A} - {1'b0,Main_Input_B} - Main_Bin; 
				3'b110 : expected = Main_Input_A + 1; 
				3'b111 : expected = Main_Input_A - 1; 
				default : expected = 8'd0;
			endcase  
			
			#10;
			
			//Examination of the Expected Situation versus the Calculated Situation.
			if(expected[N-1:0] == Main_Result) begin
				success = success + 1; 
			end 
			else begin 
				failed = failed + 1;
				$display("FAIL op=%b A=%0d B=%0d Cin=%b Bin=%b | Result=%0d exp=%0d Cout=%b Bout=%b",
             Main_Opcode, Main_Input_A, Main_Input_B, Main_Cin, Main_Bin,
             Main_Result, expected[N-1:0], Main_Cout, Main_Bout);
			end 
		end 
		
		//Write Console Test Results.
		$display("/-----------TEST SONUCLARI---------/"); 
		$display("Toplam Test: %d",success + failed); 
		$display("Basarili Test: %d",success); 
		$display("Basarisiz Test: %d\n",failed);
	end 
	
	//Write Values Display 
	initial begin
		$monitor("Zaman=%0t | Opcode=%b | A=%d | B=%d | Sonuc=%d | Cin=%b | Bin=%b |Cout=%b | Bout=%b", 
                 $time, Main_Opcode, Main_Input_A, Main_Input_B, Main_Result, Main_Cin, Main_Bin ,Main_Cout, Main_Bout);
	end
endmodule