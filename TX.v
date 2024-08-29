module UART_TX 
  #(parameter TICK_PER_BIT )
  (
   input        i_enable, 
   input        i_Clock, 
   input        i_reset,  
   input        i_start,
   input        sample_tick, 
	input			 data_we,
   input [7:0]  i_data, 
   output reg   o_TX_Active,
   output reg   o_TX,
   output reg   o_TX_Done
   );
 
   localparam IDLE         = 3'b000;
   localparam TX_START_BIT = 3'b001;
   localparam TX_DATA_BITS = 3'b010;
   localparam TX_STOP_BIT  = 3'b011;
  
   reg [2:0] currentstate;
   reg [3:0] bit_counter;
   reg [2:0] bit_index;
   reg [7:0] r_TX_Data;

  always @(posedge i_Clock or negedge i_reset) begin
    if (~i_reset) begin
      o_TX         <= 1'b1;
      o_TX_Active  <= 1'b0;
      o_TX_Done    <= 1'b0;
      bit_counter  <= 0;
      bit_index    <= 0;
      r_TX_Data    <= 0;
      currentstate <= IDLE;
    end 
	 else if (i_enable) begin
      o_TX_Done <= 1'b0;

      case (currentstate)
        IDLE : begin
          o_TX        <= 1'b1;       
          bit_counter <= 0;
          bit_index   <= 0;
          
          if (i_start == 1'b0) begin
            o_TX_Active    <= 1'b1;
            r_TX_Data      <= i_data;
            currentstate   <= TX_START_BIT;
          end
        end

        TX_START_BIT : begin
          o_TX <= 1'b0;
	if(sample_tick)
        begin
            if (bit_counter < TICK_PER_BIT-1) begin
              bit_counter <= bit_counter + 1;
            end else begin
              bit_counter  <= 0;
              currentstate <= TX_DATA_BITS;
            end
         end
        end

        TX_DATA_BITS : begin
          o_TX <= r_TX_Data[bit_index];
	if(sample_tick)
       begin
            if (bit_counter < TICK_PER_BIT-1) begin
              bit_counter <= bit_counter + 1;
            end else begin
              bit_counter <= 0;
              if (bit_index < 7) begin
                bit_index <= bit_index + 1;
              end else begin
                bit_index  <= 0;
                currentstate <= TX_STOP_BIT;
              end
            end
         end
        end

        TX_STOP_BIT : begin
          o_TX <= 1'b1;
	if(sample_tick)
        begin
            if (bit_counter < TICK_PER_BIT-1) begin
              bit_counter <= bit_counter + 1;
            end else begin
              o_TX_Done    <= 1'b1;
              bit_counter  <= 0;
              o_TX_Active  <= 1'b0;
			   if(~data_we) begin
				  currentstate <= IDLE;
	            end
            end
          end
       end 

        default : currentstate <= IDLE;
      endcase
    end 
  end
endmodule
