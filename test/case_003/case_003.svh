`ifndef _case_003_svh_
`define _case_003_svh_

task case_003();


automatic integer       i                           = 0;
automatic integer       j                           = 0;
automatic integer       c                           = 0;
automatic integer       number_of_packets           = 100000;
automatic integer       number_of_routed_packets    = 0;
automatic logic [31:0]  counter_value               = 0;
automatic logic [31:0]  frame_check_sequence        = 0;

$display("Running case 003");

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

for (i = 0; i < 996; i = i + 1) begin
    testbench.ethernet_message_0[20+i]  = i;
end
testbench.ethernet_message_0[1016] = 8'h00;
testbench.ethernet_message_0[1017] = 8'h00;
testbench.ethernet_message_0[1018] = 8'h00;
testbench.ethernet_message_0[1019] = 8'h00;
//crc32
testbench.ethernet_message_0[1020]  = 8'hC3;
testbench.ethernet_message_0[1021]  = 8'hFA;
testbench.ethernet_message_0[1022]  = 8'h72;
testbench.ethernet_message_0[1023]  = 8'h5E;

force testbench.passe_passe_example_top.switch_core.genblk2[0].virtual_port_udp.switch_inbound_fifo.full = 0;

fork : f0
    begin
        for (int j = 0; j < number_of_packets; j = j + 1) begin
            testbench.ethernet_message_0[1016][7:4] = (j  >> 28) & 32'hF;
            testbench.ethernet_message_0[1016][3:0] = (j  >> 24) & 32'hF;
            testbench.ethernet_message_0[1017][7:4] = (j  >> 20) & 32'hF;
            testbench.ethernet_message_0[1017][3:0] = (j  >> 16) & 32'hF;
            testbench.ethernet_message_0[1018][7:4] = (j  >> 12) & 32'hF;
            testbench.ethernet_message_0[1018][3:0] = (j  >> 8) & 32'hF;
            testbench.ethernet_message_0[1019][7:4] = (j >> 4) & 32'hF;
            testbench.ethernet_message_0[1019][3:0] = j & 32'hF;
            frame_check_sequence                    = testbench.calc_crc(testbench.ethernet_message_0, 1020);
            testbench.ethernet_message_0[1020]      = frame_check_sequence[31:24];
            testbench.ethernet_message_0[1021]      = frame_check_sequence[23:16];
            testbench.ethernet_message_0[1022]      = frame_check_sequence[15:8];
            testbench.ethernet_message_0[1023]      = frame_check_sequence[7:0];

            for (i = 0; i < 1024; i = i +1) begin
                @(negedge testbench.rgmii_clock_0);
                #2ns;
                testbench.rgmii_data_control_0     = 1;
                testbench.rgmii_data_0             = testbench.ethernet_message_0[i][3:0];
                @(posedge testbench.rgmii_clock_0);
                #2ns;
                testbench.rgmii_data_0              = testbench.ethernet_message_0[i][7:4];
            end
            @(negedge testbench.rgmii_clock_0);
            #2ns;
            testbench.rgmii_data_control_0          = 0;
            testbench.rgmii_data_0                  = 0;
            #100ns;
        end
        #1000ms;
        $display("0: %d/%d packets routed\n", number_of_routed_packets, number_of_packets);
        $display("%t : timeout while waiting for all packets to be routed\n", $time);
        $fatal(0);
        disable f0;
    end
    begin
        while (number_of_routed_packets != number_of_packets) begin
            wait(testbench.passe_passe_example_top.switch_core.genblk3[1].rgmii_port.rgmii_byte_shipper.frame_data_valid);
            c = 0;

            while (c != 1024) begin
                @(negedge testbench.passe_passe_example_top.switch_core.genblk3[1].rgmii_port.rgmii_byte_shipper.clock) begin
                    if (c == 1016) begin
                        counter_value[31:24] = testbench.passe_passe_example_top.switch_core.genblk3[1].rgmii_port.rgmii_byte_shipper.frame_data;
                    end
                    if (c == 1017) begin
                        counter_value[23:16] = testbench.passe_passe_example_top.switch_core.genblk3[1].rgmii_port.rgmii_byte_shipper.frame_data;
                    end
                    if (c == 1018) begin
                        counter_value[15:8] = testbench.passe_passe_example_top.switch_core.genblk3[1].rgmii_port.rgmii_byte_shipper.frame_data;
                    end
                    if (c == 1019) begin
                        counter_value[7:0] = testbench.passe_passe_example_top.switch_core.genblk3[1].rgmii_port.rgmii_byte_shipper.frame_data;

                        if (counter_value != number_of_routed_packets) begin
                            $display("Wrong sequence number, expecting %h, got %h\n", number_of_routed_packets, counter_value);
                            $fatal(0);
                            disable f0;
                        end
                        else begin
                            $display("Correct sequence number, expecting %h, got %h\n", number_of_routed_packets, counter_value);
                        end
                    
                    end
                    c++;
                end
            end
            number_of_routed_packets++;
            wait(!testbench.passe_passe_example_top.switch_core.genblk3[1].rgmii_port.rgmii_byte_shipper.frame_data_valid);
            $display("Port 1: %d/%d packets routed\n", number_of_routed_packets, number_of_packets);
        end
        disable f0;
    end
    begin
        while (1) begin
            //check for packet drop state
            @(posedge testbench.passe_passe_example_top.switch_core.genblk3[0].rgmii_port.ethernet_packet_parser.clock)
            if (testbench.passe_passe_example_top.switch_core.genblk3[0].rgmii_port.ethernet_packet_parser.state == 4) begin
                $display("Port 0 parser dropped a packet!\n");
                $fatal(0);
                disable f0;
            end
        end
        disable f0;
    end
join


endtask: case_003

`endif