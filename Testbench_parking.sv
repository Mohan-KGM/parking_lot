`timescale 1ns/1ps

module testbench;

reg resetn, clk;
reg CarDetectEntry, CarDetectExit, ValidTag1, ValidTag2, PaymentDone;
reg ValidationFail1, ValidationFail2;
reg Timeout1, Timeout2;

wire ActivateRFID, IssueTicket, OpenEntryGate, OpenExitGate;
wire AssertError, InitPayment;
wire startTimer1, startTimer2;

parkingLot uut (.*);

always forever #5 clk = ~clk;

assign #10 PaymentDone = InitPayment;
assign #20 ValidTag1 = ActivateRFID;
assign #50 ValidTag2 = ActivateRFID;

  initial begin
        $dumpfile("testbench.vcd"); $dumpvars;
        resetn = 1;
        clk = 0;
        CarDetectEntry=0; CarDetectExit=0; /*ValidTag1=0; ValidTag2=0; PaymentDone=0;*/
        ValidationFail1 = 0; ValidationFail2=0;
        Timeout1=0;Timeout2=0;

 @(posedge clk);
        @(posedge clk);
        resetn=0;
        @(posedge clk);
        @(posedge clk);
        resetn=1;
        @(posedge clk);
        @(posedge clk);
        CarDetectEntry=1; Timeout1=1;
        @(posedge clk);
        CarDetectEntry=0; Timeout1=1;
        @(posedge clk);
        CarDetectEntry=0; Timeout1=1;
        @(posedge clk);
        CarDetectEntry=0; Timeout1=1;
        @(posedge clk);
        @(posedge clk);
        CarDetectExit=1; Timeout2=1;
        @(posedge clk);
        CarDetectExit=0; Timeout2=1;
        @(posedge clk);
        CarDetectExit=0; Timeout2=1;
        @(posedge clk);
        CarDetectExit=0; Timeout2=1;
        @(posedge clk);
        @(posedge clk);

        #100 $finish;
end
initial begin
        $monitor("CarDetectEntry = %0b ActivateTag=%0x ValidTag1=%0x Tiemout1=%0x OpenEntryGate=%0x", CarDetectEntry, ActivateRFID, ValidTag1, Timeout1, OpenEntryGate);
        $monitor("CarDetectExit = %0b InitPayment=%0x ValidTag2=%0x Tiemout2=%0x OpenExitGate=%0x PaymentDone=%0x", CarDetectExit, InitPayment, ValidTag2, Timeout2, OpenExitGate, PaymentDone);
end
endmodule
