`ifndef _case_000_svh_
`define _case_000_svh_

task case_000();


automatic integer i = 0;
automatic integer j = 0;

$display("Running case 000");
$display("Transmitting a proper packet to RGMII port 0 with the MAC destination of RGMII port 1");

testbench.ethernet_message_0[0]   = 8'h55;
testbench.ethernet_message_0[1]   = 8'h55;
testbench.ethernet_message_0[2]   = 8'h55;
testbench.ethernet_message_0[3]   = 8'h55;
testbench.ethernet_message_0[4]   = 8'h55;
testbench.ethernet_message_0[5]   = 8'h55;
testbench.ethernet_message_0[6]   = 8'h55;

testbench.ethernet_message_0[7]   = 8'hD5;

testbench.ethernet_message_0[8]   = 8'hF6;
testbench.ethernet_message_0[9]   = 8'h90;
testbench.ethernet_message_0[10]  = 8'h2A;
testbench.ethernet_message_0[11]  = 8'h94;
testbench.ethernet_message_0[12]  = 8'h2D;
testbench.ethernet_message_0[13]  = 8'h5E;

testbench.ethernet_message_0[14]  = 8'hB8;
testbench.ethernet_message_0[15]  = 8'h27;
testbench.ethernet_message_0[16]  = 8'hEB;
testbench.ethernet_message_0[17]  = 8'hBA;
testbench.ethernet_message_0[18]  = 8'h99;
testbench.ethernet_message_0[19]  = 8'hD6;
//type
testbench.ethernet_message_0[20]  = 8'h08;
testbench.ethernet_message_0[21]  = 8'h00;
//ipv4 version header len
testbench.ethernet_message_0[22]  = 8'h45;
//ipv4 tos
testbench.ethernet_message_0[23]  = 8'h00;
//ipv4 total length
testbench.ethernet_message_0[24]  = 8'h00;
testbench.ethernet_message_0[25]  = 8'h2A;
//ipv4 id
testbench.ethernet_message_0[26]  = 8'h83;
testbench.ethernet_message_0[27]  = 8'h4F;
//ipv4 flags
testbench.ethernet_message_0[28]  = 8'h40;
testbench.ethernet_message_0[29]  = 8'h00;
//ipv4 tl
testbench.ethernet_message_0[30]  = 8'h40;
//ipv4 protocol
testbench.ethernet_message_0[31]  = 8'h11;
//ipv4 header checksum
testbench.ethernet_message_0[32]  = 8'h66;
testbench.ethernet_message_0[33]  = 8'h76;
//ipv4 source ip
testbench.ethernet_message_0[34]  = 8'hAC;
testbench.ethernet_message_0[35]  = 8'h10;
testbench.ethernet_message_0[36]  = 8'h7C;
testbench.ethernet_message_0[37]  = 8'h6B;
//ipv4 destination ip
testbench.ethernet_message_0[38]  = 8'hAC;
testbench.ethernet_message_0[39]  = 8'h10;
testbench.ethernet_message_0[40]  = 8'h7C;
testbench.ethernet_message_0[41]  = 8'h71;
//udp source port
testbench.ethernet_message_0[42]  = 8'h44;
testbench.ethernet_message_0[43]  = 8'h44;
//udp destination port
testbench.ethernet_message_0[44]  = 8'h44;
testbench.ethernet_message_0[45]  = 8'h44;
//udp length
testbench.ethernet_message_0[46]  = 8'h00;
testbench.ethernet_message_0[47]  = 8'h16;
//udp checksum
testbench.ethernet_message_0[48]  = 8'h4E;
testbench.ethernet_message_0[49]  = 8'h59;
//udp payload
testbench.ethernet_message_0[50]  = 8'hAB;
testbench.ethernet_message_0[51]  = 8'hCD;
testbench.ethernet_message_0[52]  = 8'h61;
testbench.ethernet_message_0[53]  = 8'h97;
testbench.ethernet_message_0[54]  = 8'hE1;
testbench.ethernet_message_0[55]  = 8'hC2;
testbench.ethernet_message_0[56]  = 8'h04;
testbench.ethernet_message_0[57]  = 8'hA6;
testbench.ethernet_message_0[58]  = 8'hE3;
testbench.ethernet_message_0[59]  = 8'h12;
testbench.ethernet_message_0[60]  = 8'h01;
testbench.ethernet_message_0[61]  = 8'h00;
testbench.ethernet_message_0[62]  = 8'h00;
testbench.ethernet_message_0[63]  = 8'h02;
//pad
testbench.ethernet_message_0[64]  = 8'h00;
testbench.ethernet_message_0[65]  = 8'h00;
testbench.ethernet_message_0[66]  = 8'h00;
testbench.ethernet_message_0[67]  = 8'h00;
//crc32
testbench.ethernet_message_0[68]  = 8'h0E;
testbench.ethernet_message_0[69]  = 8'h23;
testbench.ethernet_message_0[70]  = 8'h35;
testbench.ethernet_message_0[71]  = 8'h94;


for (i=0;i<72;i=i+1) begin
    @(negedge testbench.rgmii_clock_0);
    #2ns;
    testbench.rgmii_data_control_0        = 1;
    testbench.rgmii_data_0                  = testbench.ethernet_message_0[i][3:0];
    @(posedge testbench.rgmii_clock_0);
    #2ns;
    testbench.rgmii_data_0                  = testbench.ethernet_message_0[i][7:4];
end
@(negedge testbench.rgmii_clock_0);
#2ns;
testbench.rgmii_data_control_0    = 0;
testbench.rgmii_data_0              = 0;

fork : f0
    begin
        #1ms;
        $fatal(0, "%t : timeout while waiting for checksum valid", $time);
        disable f0;
    end
    begin
        wait (testbench.passe_passe_example_top.switch_core.genblk3[0].rgmii_port.ethernet_packet_parser_checksum_result_enable == 1);
        disable f0;
    end
join
@(posedge testbench.passe_passe_example_top.switch_core.genblk3[0].rgmii_port.phy_receive_clock);
@(posedge testbench.passe_passe_example_top.switch_core.genblk3[0].rgmii_port.phy_receive_clock);
assert (testbench.passe_passe_example_top.switch_core.genblk3[0].rgmii_port.ethernet_packet_parser_good_packet != 0) $display ("Good packet detected correctly on RGMII port 0");
    else $fatal(0, "Packet was detected as bad when it should have been good");

fork : f1
    begin
        #1ms;
        $fatal(0, "%t : timeout while waiting for RGMII port 1 to transmit routed data", $time);
        disable f1;
    end
    begin
        wait (testbench.passe_passe_example_top.switch_core.genblk3[1].rgmii_port.phy_transmit_data_valid == 1);
        $display("Packet was routed correctly from RGMII port 0 out to RGMII port 1");
        disable f1;
    end
join


endtask: case_000

`endif