module UART_RX
  #(parameter TICK_PER_BIT )
  (
   input        i_Clock,
   input        i_reset, 
   input        i_RX,
   input        sample_tick, 
   output reg   o_RX_DV,
   output reg [7:0] o_RX_Data
   );
   
   parameter IDLE         = 3'b000;
   parameter RX_START_BIT = 3'b001;
   parameter RX_DATA_BITS = 3'b010;
   parameter RX_STOP_BIT  = 3'b011;
   parameter DONE         = 3'b100;
   
   reg [3:0] bit_counter;
   reg [2:0] bit_index; 
   reg [2:0] currentstate;

  always @(posedge i_Clock or negedge i_reset) begin
    if (~i_reset) begin
      o_RX_DV      <= 1'b0;
      bit_counter  <= 0;
      bit_index    <= 0;
      o_RX_Data    <= 0;
      currentstate <= IDLE;
    end else begin
      case (currentstate)
        IDLE : begin
          o_RX_DV       <= 1'b0;
          bit_counter   <= 0;
          bit_index     <= 0;
          if (i_RX == 1'b0)
            currentstate <= RX_START_BIT;
          else
            currentstate <= IDLE;
        end

        RX_START_BIT : begin
	if(sample_tick)
           begin
            if (bit_counter  == 7) begin
              if (i_RX == 1'b0) begin
                bit_counter  <= 0;  
                currentstate <= RX_DATA_BITS;
              end else begin
                currentstate <= IDLE;
              end
            end else begin
              bit_counter  <= bit_counter + 1;
            end
          end
        end
        
        RX_DATA_BITS : begin
		if(sample_tick)	           
		begin
            if (bit_counter  < TICK_PER_BIT-1) begin
              bit_counter    <= bit_counter  + 1;
            end else begin
              bit_counter          <= 0;
              o_RX_Data[bit_index] <= i_RX;
              if (bit_index < 7) begin
                bit_index <= bit_index + 1;
              end else begin
                bit_index <= 0;
                currentstate <= RX_STOP_BIT;
              end
            end
          end
        end

        RX_STOP_BIT : begin
        if(sample_tick)   
	  begin
            if (bit_counter  < TICK_PER_BIT-1) begin
              bit_counter  <= bit_counter  + 1;
            end else begin
              o_RX_DV <= 1'b1;
              bit_counter  <= 0;
              currentstate <= DONE;
            end
          end
        end

        DONE : begin
          currentstate <= IDLE;
          o_RX_DV <= 1'b0;
        end

        default : currentstate <= IDLE;
      endcase
    end
  end
endmodule
