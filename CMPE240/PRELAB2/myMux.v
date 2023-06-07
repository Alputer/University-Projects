module myMux(S0, S1, I0, I1, I2, I3, O);
 input I0, I1, I2, I3;
 input S0, S1;
 output O;
 reg O; 
 
always @(I0, I1, I2, I3, S0, S1)
begin
 if( S1==0 && S0==0 )
 O <= I0;
 else if( S1==0 && S0==1 )
 O <= I1;
 else if( S1==1 && S0==0 )
 O <= I2;
 else
 O <= I3;
end
 
 
 endmodule