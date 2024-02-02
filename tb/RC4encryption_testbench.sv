localparam NULL_CHAR = 8'b0;
 
module RC4encryption_tb;
    reg clk = 1'b0;
    always #5 clk = !clk;
 
    reg rst_n = 1'b0;
 
    initial begin
        @(posedge clk) rst_n = 1'b1;
    end
 
    reg [127:0] key = 128'b0;
    reg valid_key = 1'b0;
    reg [7:0] plaintext = 8'b0;
    reg valid_din = 1'b0;
 
    wire ready_for_key;
    wire ready_for_plaintext;
    wire [7:0] ciphertext;
    wire valid_dout;
 
    RC4encryption INSTANCE_NAME (
        .clock                  (clk)
        ,.rst_n                 (rst_n)
        ,.key                   (key)
        ,.valid_key             (valid_key)
        ,.plaintext             (plaintext)
        ,.valid_din             (valid_din)
        ,.ready_for_key         (ready_for_key)
        ,.ready_for_plaintext   (ready_for_plaintext)
        ,.ciphertext            (ciphertext)
        ,.valid_dout            (valid_dout)
    );
 
    int FP_PTXT;
    int FP_CTXT;
    int FP_KEY;
    byte hexa;
    reg [7:0] CTXT [$];
    reg [7:0] PTXT [$];
    reg [7:0] KEYTXT;
 
    initial begin
        @(posedge clk); // INITIALIZATION PERMUTATION BOX (S0)
        @(posedge clk); // NOW I WAIT UNTIL READY_FOR KEY IS SET UP
       
        while (ready_for_key == 1'b0)
        begin
            @(posedge clk);
        end
 
        key = 128'b0;
        FP_KEY = $fopen("tv/key.txt", "r");
        while($fscanf(FP_KEY, "%2h", KEYTXT) == 1)
        begin
            key = {KEYTXT, key[127:8]};
        end
 
        $display("The key given in input is: %d", key);
        valid_key = 1'b1;
        @(posedge clk);
        valid_key = 1'b0;
       
        $display("Now I wait until the encryptor is ready for the encryption");
 
        while (ready_for_plaintext == 1'b0)
        begin
            @(posedge clk);
        end
 
        FP_PTXT = $fopen("tv/plaintext.txt", "r");
        $display("Encrypting file 'tv/plaintext.txt' to 'tv/ctxt.txt'...");
        while($fscanf(FP_PTXT, "%2h", hexa) == 1)
        begin
            plaintext = byte'(hexa);
            valid_din = 1'b1;
            @(posedge clk);
            if (valid_dout == 1'b1)
            begin
                CTXT.push_back(ciphertext);
            end
        end
        valid_din = 1'b0;
        @(posedge clk);
 
        // Here we take the last byte encrypted, sure that it is encrypted in 1 clock cycle by the encryptor module
        if (valid_dout == 1'b1)
        begin
            CTXT.push_back(ciphertext);
        end
        $fclose(FP_PTXT);
 
        FP_CTXT = $fopen("tv/ciphertext.txt", "w");
        foreach (CTXT[i]) $fwrite(FP_CTXT, "%2h", CTXT[i]);
        $fclose(FP_CTXT);
 
        $display("Done!");
        @(posedge clk);
        $stop;
    end
endmodule
