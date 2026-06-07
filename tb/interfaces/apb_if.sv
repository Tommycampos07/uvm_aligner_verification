interface apb_if(

    input logic clk;
    input logic reset_n;

);

    logic psel;
    logic penable;
    logic pwrite;
    logic [15:0] paddr;
    logic [31:0] pwdata;

    logic pready;
    logic [31:0] prdata;
    logic pslverr;

    //Visto del DUT
    modport dut_mp(

        input clk,
        input reset_n,
        input psel,
        input penable,
        input pwrite,
        input paddr,
        input pwdata,
        
        output pready,
        output prdata,
        output pslverr

    );


    //Visto del driver 
    modport drv_mp(

        input clk,
        input reset_n,
        input pready,
        input prdata,
        input pslverr,

        output psel,
        output penable,
        output pwrite,
        output paddr,
        output pwdata

    );

    //Visto del monitor 
    modport mon_mp(

        input clk,
        input reset_n,
        input psel,
        input penable,
        input pwrite,
        input paddr,
        input pwdata,
        input pready,
        input prdata,
        input pslverr

    );
    
endinterface
