`ifndef _case_001_svh_
`define _case_001_svh_

task case_001();


automatic integer   i                           = 0;
automatic integer   j                           = 0;
automatic integer   c                           = 0;
automatic integer   number_of_packets           = 2;
automatic integer   number_of_routed_packets    = 0;

$display("Running case 001");

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

for (i = 0; i < 1000; i = i + 1) begin
    testbench.ethernet_message_0[20+i]  = i;
end
//crc32
testbench.ethernet_message_0[1020]  = 8'hC3;
testbench.ethernet_message_0[1021]  = 8'hFA;
testbench.ethernet_message_0[1022]  = 8'h72;
testbench.ethernet_message_0[1023]  = 8'h5E;

fork : f0
    begin
        for (int j = 0; j < number_of_packets; j = j + 1) begin
            for (i=0;i<1024;i=i+1) begin
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
        #100ms;
        $display("%d out of %d packets routed\n", number_of_routed_packets, number_of_packets);
        disable f0;
    end
    begin
        while (number_of_routed_packets != number_of_packets) begin
            wait(testbench.passe_passe_example_top.switch_core.genblk3[1].rgmii_port.rgmii_byte_shipper.frame_data_valid);
            number_of_routed_packets++;
            c = 0;

            while (c != 1024) begin
                @(negedge testbench.passe_passe_example_top.switch_core.genblk3[1].rgmii_port.rgmii_byte_shipper.clock) begin
                    if (testbench.passe_passe_example_top.switch_core.genblk3[1].rgmii_port.rgmii_byte_shipper.frame_data != testbench.ethernet_message_0[c]) begin
                        $fatal(0, "Sent wrong byte, expecting %h, got %h", testbench.passe_passe_example_top.switch_core.genblk3[1].rgmii_port.rgmii_byte_shipper.frame_data, testbench.ethernet_message_0[c]);
                    end
                    else begin
                        //$display("Sent correct byte, expecting %h, got %h", testbench.passe_passe_example_top.switch_core.genblk3[1].rgmii_port.rgmii_byte_shipper.frame_data, testbench.ethernet_message_0[c]);
                    end
                    c++;
                end
            end
            wait(!testbench.passe_passe_example_top.switch_core.genblk3[1].rgmii_port.rgmii_byte_shipper.frame_data_valid);
            $display("%d packets routed\n", number_of_routed_packets);
        end
        disable f0;
    end
join



endtask: case_001

`endif