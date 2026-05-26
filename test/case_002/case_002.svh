`ifndef _case_002_svh_
`define _case_002_svh_

task case_002();


automatic integer   i_0                         = 0;
automatic integer   j_0                         = 0;
automatic integer   i_1                         = 0;
automatic integer   j_1                         = 0;
automatic integer   c_0                         = 0;
automatic integer   c_1                         = 0;
automatic integer   number_of_packets           = 100000;
automatic integer   number_of_routed_packets_0  = 0;
automatic integer   number_of_routed_packets_1  = 0;

$display("Running case 002");

testbench.ethernet_message_0[0]   = 8'h55;
testbench.ethernet_message_0[1]   = 8'h55;
testbench.ethernet_message_0[2]   = 8'h55;
testbench.ethernet_message_0[3]   = 8'h55;
testbench.ethernet_message_0[4]   = 8'h55;
testbench.ethernet_message_0[5]   = 8'h55;
testbench.ethernet_message_0[6]   = 8'h55;

testbench.ethernet_message_1[0]   = 8'h55;
testbench.ethernet_message_1[1]   = 8'h55;
testbench.ethernet_message_1[2]   = 8'h55;
testbench.ethernet_message_1[3]   = 8'h55;
testbench.ethernet_message_1[4]   = 8'h55;
testbench.ethernet_message_1[5]   = 8'h55;
testbench.ethernet_message_1[6]   = 8'h55;

testbench.ethernet_message_0[7]   = 8'hD5;

testbench.ethernet_message_1[7]   = 8'hD5;


testbench.ethernet_message_0[8]   = 8'hF6;
testbench.ethernet_message_0[9]   = 8'h90;
testbench.ethernet_message_0[10]  = 8'h2A;
testbench.ethernet_message_0[11]  = 8'h94;
testbench.ethernet_message_0[12]  = 8'h2D;
testbench.ethernet_message_0[13]  = 8'h5E;

testbench.ethernet_message_1[8]   = 8'hB8;
testbench.ethernet_message_1[9]   = 8'h27;
testbench.ethernet_message_1[10]  = 8'hEB;
testbench.ethernet_message_1[11]  = 8'hBA;
testbench.ethernet_message_1[12]  = 8'h99;
testbench.ethernet_message_1[13]  = 8'hD6;

testbench.ethernet_message_0[14]  = 8'hB8;
testbench.ethernet_message_0[15]  = 8'h27;
testbench.ethernet_message_0[16]  = 8'hEB;
testbench.ethernet_message_0[17]  = 8'hBA;
testbench.ethernet_message_0[18]  = 8'h99;
testbench.ethernet_message_0[19]  = 8'hD6;

testbench.ethernet_message_1[14]  = 8'hF6;
testbench.ethernet_message_1[15]  = 8'h90;
testbench.ethernet_message_1[16]  = 8'h2A;
testbench.ethernet_message_1[17]  = 8'h94;
testbench.ethernet_message_1[18]  = 8'h2D;
testbench.ethernet_message_1[19]  = 8'h5E;

for (i_0 = 0; i_0 < 1000; i_0 = i_0 + 1) begin
    testbench.ethernet_message_0[20+i_0]  = i_0;
    testbench.ethernet_message_1[20+i_0]  = i_0;
end
//crc32
testbench.ethernet_message_0[1020]  = 8'hC3;
testbench.ethernet_message_0[1021]  = 8'hFA;
testbench.ethernet_message_0[1022]  = 8'h72;
testbench.ethernet_message_0[1023]  = 8'h5E;

testbench.ethernet_message_1[1020]  = 8'hDF;
testbench.ethernet_message_1[1021]  = 8'h83;
testbench.ethernet_message_1[1022]  = 8'hEB;
testbench.ethernet_message_1[1023]  = 8'hA8;

fork : f0
    begin
        for (int j_0 = 0; j_0 < number_of_packets; j_0 = j_0 + 1) begin
            for (i_0 = 0; i_0 < 1024; i_0 = i_0 +1) begin
                @(negedge testbench.rgmii_clock_0);
                #2ns;
                testbench.rgmii_data_control_0     = 1;
                testbench.rgmii_data_0             = testbench.ethernet_message_0[i_0][3:0];
                @(posedge testbench.rgmii_clock_0);
                #2ns;
                testbench.rgmii_data_0              = testbench.ethernet_message_0[i_0][7:4];
            end
            @(negedge testbench.rgmii_clock_0);
            #2ns;
            testbench.rgmii_data_control_0          = 0;
            testbench.rgmii_data_0                  = 0;
            #100ns;
        end
        #1000ms;
        $display("0: %d/%d packets routed\n", number_of_routed_packets_0, number_of_packets);
        $fatal(0, "%t : timeout while waiting for all packets to be routed\n", $time);
        disable f0;
    end
    begin
        for (int j_1 = 0; j_1 < number_of_packets; j_1 = j_1 + 1) begin
            for (i_1 = 0; i_1 < 1024; i_1 = i_1 +1) begin
                @(negedge testbench.rgmii_clock_1);
                #2ns;
                testbench.rgmii_data_control_1     = 1;
                testbench.rgmii_data_1             = testbench.ethernet_message_1[i_1][3:0];
                @(posedge testbench.rgmii_clock_1);
                #2ns;
                testbench.rgmii_data_1              = testbench.ethernet_message_1[i_1][7:4];
            end
            @(negedge testbench.rgmii_clock_1);
            #2ns;
            testbench.rgmii_data_control_1          = 0;
            testbench.rgmii_data_1                  = 0;
            #100ns;
        end
        #100ms;
        $display("Port 0: %d/%d packets routed\n", number_of_routed_packets_0, number_of_packets);
        $display("Port 1: %d/%d packets routed\n", number_of_routed_packets_1, number_of_packets);
        $fatal(0, "%t : timeout while waiting for all packets to be routed\n", $time);
        disable f0;
    end
    begin
        while (number_of_routed_packets_0 != number_of_packets) begin
            wait(testbench.passe_passe_example_top.switch_core.genblk3[0].rgmii_port.rgmii_byte_shipper.frame_data_valid);
            c_0 = 0;

            while (c_0 != 1024) begin
                @(negedge testbench.passe_passe_example_top.switch_core.genblk3[0].rgmii_port.rgmii_byte_shipper.clock) begin
                    if (testbench.passe_passe_example_top.switch_core.genblk3[0].rgmii_port.rgmii_byte_shipper.frame_data != testbench.ethernet_message_1[c_0]) begin
                        $fatal(0, "Port 0 sent wrong byte, expecting %h, got %h\n", testbench.passe_passe_example_top.switch_core.genblk3[0].rgmii_port.rgmii_byte_shipper.frame_data, testbench.ethernet_message_0[c_0]);
                        disable f0;
                    end
                    else begin
                        //$display("Sent correct byte, expecting %h, got %h", testbench.passe_passe_example_top.switch_core.genblk3[1].rgmii_port.rgmii_byte_shipper.frame_data, testbench.ethernet_message_0[c]);
                    end
                    c_0++;
                end
            end
            number_of_routed_packets_0++;
            wait(!testbench.passe_passe_example_top.switch_core.genblk3[0].rgmii_port.rgmii_byte_shipper.frame_data_valid);
            $display("Port 0: %d/%d packets routed\n", number_of_routed_packets_0, number_of_packets);
        end
        disable f0;
    end
    begin
        while (number_of_routed_packets_1 != number_of_packets) begin
            wait(testbench.passe_passe_example_top.switch_core.genblk3[1].rgmii_port.rgmii_byte_shipper.frame_data_valid);
            c_1 = 0;

            while (c_1 != 1024) begin
                @(negedge testbench.passe_passe_example_top.switch_core.genblk3[1].rgmii_port.rgmii_byte_shipper.clock) begin
                    if (testbench.passe_passe_example_top.switch_core.genblk3[1].rgmii_port.rgmii_byte_shipper.frame_data != testbench.ethernet_message_0[c_1]) begin
                        $fatal(0, "Port 1 sent wrong byte, expecting %h, got %h\n", testbench.passe_passe_example_top.switch_core.genblk3[1].rgmii_port.rgmii_byte_shipper.frame_data, testbench.ethernet_message_0[c_1]);
                        disable f0;
                    end
                    else begin
                        //$display("Sent correct byte, expecting %h, got %h", testbench.passe_passe_example_top.switch_core.genblk3[1].rgmii_port.rgmii_byte_shipper.frame_data, testbench.ethernet_message_0[c]);
                    end
                    c_1++;
                end
            end
            number_of_routed_packets_1++;
            wait(!testbench.passe_passe_example_top.switch_core.genblk3[1].rgmii_port.rgmii_byte_shipper.frame_data_valid);
            $display("Port 1: %d/%d packets routed\n", number_of_routed_packets_1, number_of_packets);
        end
        disable f0;
    end
    begin
        while (1) begin
            //check for packet drop state
            @(posedge testbench.passe_passe_example_top.switch_core.genblk3[1].rgmii_port.ethernet_packet_parser.clock)
            if (testbench.passe_passe_example_top.switch_core.genblk3[1].rgmii_port.ethernet_packet_parser.state == 4) begin
                $fatal(0, "Port 1 parser dropped a packet!\n");
                disable f0;
            end
        end
        disable f0;
    end
    begin
        while (1) begin
            //check for packet drop state
            @(posedge testbench.passe_passe_example_top.switch_core.genblk3[0].rgmii_port.ethernet_packet_parser.clock)
            if (testbench.passe_passe_example_top.switch_core.genblk3[0].rgmii_port.ethernet_packet_parser.state == 4) begin
                $fatal(0, "Port 0 parser dropped a packet!\n");
                disable f0;
            end
        end
        disable f0;
    end
join



endtask: case_002

`endif