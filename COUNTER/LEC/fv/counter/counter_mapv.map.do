
//input ports
add mapped point clk clk -type PI PI
add mapped point rst_n rst_n -type PI PI
add mapped point en en -type PI PI

//output ports
add mapped point q[7] q[7] -type PO PO
add mapped point q[6] q[6] -type PO PO
add mapped point q[5] q[5] -type PO PO
add mapped point q[4] q[4] -type PO PO
add mapped point q[3] q[3] -type PO PO
add mapped point q[2] q[2] -type PO PO
add mapped point q[1] q[1] -type PO PO
add mapped point q[0] q[0] -type PO PO

//inout ports




//Sequential Pins
add mapped point q[6]/q q_reg_6/Q -type DFF DFF
add mapped point q[5]/q q_reg_5/Q -type DFF DFF
add mapped point q[3]/q q_reg_3/Q -type DFF DFF
add mapped point q[7]/q q_reg_7/Q -type DFF DFF
add mapped point q[4]/q q_reg_4/Q -type DFF DFF
add mapped point q[2]/q q_reg_2/Q -type DFF DFF
add mapped point q[1]/q q_reg_1/Q -type DFF DFF
add mapped point q[0]/q q_reg_0/Q -type DFF DFF



//Black Boxes



//Empty Modules as Blackboxes
