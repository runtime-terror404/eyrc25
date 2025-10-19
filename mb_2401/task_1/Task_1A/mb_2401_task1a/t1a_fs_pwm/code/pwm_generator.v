
module pwm_generator(
    input clk_3125KHz,
    input [3:0] duty_cycle,
    output reg clk_195KHz, pwm_signal
);

	initial begin
    clk_195KHz = 0; pwm_signal = 1;
	end
//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE //////////////////

	reg [2:0] clk_cnt = 0;   
   reg [3:0] pwm_cnt = 0;   

    
    always @(posedge clk_3125KHz) begin
        if (!clk_cnt) 
            clk_195KHz <= ~clk_195KHz; 
        clk_cnt <= clk_cnt + 1'b1; 
    end

    
    always @(posedge clk_3125KHz) begin
        if (pwm_cnt == 4'd15)
            pwm_cnt <= 0;
        else
            pwm_cnt <= pwm_cnt + 1;

        pwm_signal <= (pwm_cnt < duty_cycle) ? 1'b1 : 1'b0;
    end

/*
Add your logic here
*/

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////

endmodule
