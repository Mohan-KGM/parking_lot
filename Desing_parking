module parkinglot_design(Alaram,clk,rst,count,Entry_gate,Exit_gate,valid_tag,Active_ID,car_detect_entry,car_detect_exit,Initial_payment,validation_fail,Timeout_1,Timeout_2,TAG,IssueTicket,startTimer1,startTimer2);
input clk,rst,car_detect_entry,car_detect_exit,Initial_payment,validation_fail;
    input [3:0]valid_tag;
    input Active_ID;
  	input Timeout_1,Timeout_2;
  	output reg [3:0]count;
    output reg Entry_gate,Exit_gate, IssueTicket;
    output reg Alaram,startTimer1, startTimer2;
  	output reg [3:0]TAG;
    reg [31:0]Timer[3:0];
    reg [3:0]tag[0:15];
  	reg [2:0]cur_state,next_state;
    parameter   RESET = 3'b000,
                IDLE_state = 3'b001,
                Valid_entery_state = 3'b010,
                Issue_Ticket_state =  3'b011,
                Error_state = 3'b100,
                Parking_hold_state = 3'b101,
                Valid_exit_state = 3'b110,
                Payment_state = 3'b111,
                True = 1'b1,
                False = 1'b0; 
                
  always @(posedge clk or negedge rst)
    begin
        if(rst == 1)
            cur_state <= RESET;
        else
            cur_state <= next_state;
    end 
    
  always @(cur_state or car_detect_entry or car_detect_exit or valid_tag or Timeout_1 or Timeout_2) begin
    			count = 0;
              	IssueTicket = 0;
              	Entry_gate = 0;
              	Exit_gate = 0;
              	Alaram = 0;
              	startTimer1=0;
              	startTimer2=0;
              	TAG = 0;
        case(cur_state)
            RESET : begin
                count = 0;
              	IssueTicket = 0;
              	Entry_gate = 0;
              	Exit_gate = 0;
              	Alaram = 0;
              	startTimer1=0;
              	startTimer2=0;
              	TAG = 0;
                if( rst == 0 )
                    next_state = IDLE_state;
                else
                    next_state = RESET;
            end
            
            IDLE_state : begin
              	startTimer1 = 1; startTimer2 = 0;
                Entry_gate = 0; Exit_gate=0;
                if((car_detect_entry == 1)&&(Timeout_2 == 0) )
                    next_state = Valid_entery_state;
                else if((Timeout_2 == 1)&&(car_detect_entry == 0))
                    next_state = Parking_hold_state;
                else
                    next_state = IDLE_state;
            end
            
            Valid_entery_state : begin
              	Entry_gate = 0; Exit_gate=0;
                if((Active_ID == True)&&(validation_fail == 0)) begin
                    next_state = Issue_Ticket_state;
                end
                else if((Active_ID == False)&&(validation_fail == 1))
                    next_state = Error_state;
                else
                    next_state = Valid_entery_state; 
            end
            
            Issue_Ticket_state : begin
                tag[count] = valid_tag;
                TAG = tag[count];
                if( valid_tag >=4'b0000 && valid_tag <=4'b1111) begin
                   	IssueTicket = 1;
                  	Entry_gate = True;
                    #10 Entry_gate = False;
                  	 Exit_gate = False;
                    count = count+1;
                    next_state =  Parking_hold_state;
                    Timer[valid_tag] = Timer[valid_tag]+1;
                end
                else
                    next_state = Issue_Ticket_state;
            end
            
            Error_state : begin
                Alaram = True;
                #50 Alaram = False;
                if( car_detect_entry == 1)
                   next_state = IDLE_state;
                else if(car_detect_exit == 1)
                    next_state = Valid_exit_state; 
                else
                    next_state = Error_state;       
            end
            
            Parking_hold_state : begin
              	startTimer1= 0; startTimer2=1;
              	Entry_gate = 0; Exit_gate=0;
                if(( car_detect_exit == 1))
                    next_state = Valid_exit_state;
                else if(( car_detect_exit == 0)&&(Timeout_1 == 1))
                    next_state = IDLE_state;
                else
                    next_state = Parking_hold_state;
            end
            
            Valid_exit_state : begin
            	Entry_gate = 0; Exit_gate=0;
                if(validation_fail == 1 || tag[count]<4'b0000 && tag[count]>4'b1111)
                    next_state = Error_state;
                else if(validation_fail == 0 || tag[count]>=4'b0000 && tag[count]<=4'b1111)
                    next_state = Payment_state;
                else
                    next_state = Valid_exit_state;
            end
            
            Payment_state : begin
                if( Initial_payment == 1) begin
                    Timer[valid_tag] = 4'b0000;
                  	Entry_gate = False;
                    Exit_gate = True;
                    count = count-1;
                    #10 Exit_gate = False;
                    next_state = IDLE_state;
                end
                else
                    next_state = Payment_state;
            end
          	default : begin
              	Entry_gate = 0; Exit_gate=0;
            end
        endcase
    end
endmodule
