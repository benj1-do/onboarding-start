

module spi_peripheral(
    input clk,
    input rst_n,
    input nCS,
    input SCLK,
    input copi,
    output reg [7:0] en_reg_out_7_0,
    output reg [7:0] en_reg_out_15_8,
    output reg [7:0] en_reg_pwm_7_0,
    output reg [7:0] en_reg_pwm_15_8,
    output reg [7:0] pwm_duty_cycle
);

reg [2:0] copi_sync, nCS_sync, SCLK_sync; // copi, nCS, SCLK passed through 2ff
reg [4:0] bit_counter; // the current bit in the transaction
reg [15:0] transaction_data; // the data used in the transaction
// synced data
wire SCLK_risingedge, nCS_fallingedge;
wire nCS_down, copi_synced;
assign copi_synced = copi_sync[2];
// edge detection
assign SCLK_risingedge = (SCLK_sync[2:1] == 2'b01);
assign nCS_fallingedge = (nCS_sync[2:1] == 2'b10);
assign nCS_down = (nCS_sync[2:1] == 2'b00);
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        copi_sync <= 3'b000;
        nCS_sync <= 3'b000;
        SCLK_sync <= 3'b000;
        en_reg_out_7_0 <= 8'h00;
        en_reg_out_15_8 <= 8'h00;
        en_reg_pwm_7_0 <= 8'h00;
        en_reg_pwm_15_8 <= 8'h00;
        pwm_duty_cycle <= 8'h00;
        bit_counter <= 0;
        transaction_data <= 0;
    end else begin
        copi_sync <= {copi_sync[1:0], copi}; // 2ffs
        nCS_sync <= {nCS_sync[1:0], nCS};
        SCLK_sync <= {SCLK_sync[1:0], SCLK};

        if (nCS_fallingedge) begin // begin data capture
            bit_counter <= 0;
            transaction_data <= 0;
        end else if (nCS_down && SCLK_risingedge) begin // shift transaction data
            if (bit_counter < 5'b10000) begin // while it is running
                transaction_data <= {transaction_data[14:0], copi_synced};
                bit_counter <= bit_counter + 1;
            end
        end

        if ((bit_counter[4] == 1) && (transaction_data[15] == 1)) begin // if write and also transaction finished
            case (transaction_data[14:8])
                7'd0: en_reg_out_7_0 <= transaction_data[7:0];
                7'd1: en_reg_out_15_8 <= transaction_data[7:0];
                7'd2: en_reg_pwm_7_0 <= transaction_data[7:0];
                7'd3: en_reg_pwm_15_8 <= transaction_data[7:0];
                7'd4: pwm_duty_cycle <= transaction_data[7:0];
                default: ;
                // do nothing for the other addresses
            endcase
        end
    end
end

endmodule;