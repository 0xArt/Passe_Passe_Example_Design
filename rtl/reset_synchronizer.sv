//////////////////////////////////////////////////////////////////////////////////
// Company:     circuitden
// Engineer:    Artin Isagholian
//              artinisagholian@gmail.com
//              www.circuitden.com
// 
// Create Date: 4/11/2026
// Design Name: 
// Module Name: reset_synchronizer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
///
// EDUCATIONAL USE ONLY
//
// This source file is provided solely for educational, research, and non-commercial purposes.
//
// Commercial use, redistribution, sublicensing, modification for commercial products,
// or incorporation into proprietary software or hardware is strictly prohibited without prior
// written permission and a valid commercial license from the original creator.
//
// Unauthorized commercial use violates intellectual property and copyright laws.
//
// For licensing inquiries and commercial permissions, contact the creator directly.
//
//////////////////////////////////////////////////////////////////////////////////
module reset_synchronizer#(
    parameter STAGES        = 5
)(
    input   wire                        clock,
    input   wire                        async_reset_n,

    output  logic                       sync_reset_n
);


reg   [STAGES-1:0] internal_reset_n = '0;


always_comb begin
    sync_reset_n    = internal_reset_n[STAGES-1];
end

always_ff @(posedge clock or negedge async_reset_n) begin
    if (!async_reset_n) begin
        internal_reset_n    <= '0;
    end
    else begin
        internal_reset_n[0]             <= async_reset_n;
        internal_reset_n[STAGES-1:1]    <= internal_reset_n[STAGES-2:0];
    end
end



endmodule