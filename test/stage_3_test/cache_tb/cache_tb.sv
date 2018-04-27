module Cache_tb();

	logic clk;
	logic rst;

	// PIPELINE Interface
	logic pipe_MemRead; // does the pipeline want to read something from mem?
	logic [15:0] pipe_read_addr; // PC for I-cache, mem_read_addr for D-cache
	logic pipe_MemWrite; // does the pipeline want to write to mem? always 0 for I-cache
	logic [15:0] pipe_mem_write_addr; // mem addr the pipeline wants to write to
	logic [15:0] pipe_mem_write_data; // data the pipeline wants to write to mem

	// Cache gets data from memory (when it wants to)
	logic MemDataValid;	// is data from memory valid?
	logic [15:0] mem_read_data; // data read from memory

	// Cache controls Memory module (when it wants to)
	logic cache_MemWrite; // Does the cache want to write to mem?
	logic cache_MemRead; // Does the cache want to read from mem
	logic [15:0] cache_mem_addr; // addr cache specifies in mem control

	logic [15:0] cache_data_out; // data read from the cache
	logic CacheFinish;
	logic CacheBusy; // does the cache want any data from mem?

	wire CacheHit;

CACHE DUT(
	.clk(clk),
	.rst(rst),

	// PIPELINE Interface
	.pipe_MemRead(pipe_MemRead), // does the pipeline want to read something from mem?
	.pipe_read_addr(pipe_read_addr), // PC for I-cache, mem_read_addr for D-cache
	.pipe_MemWrite(pipe_MemWrite), // does the pipeline want to write to mem? always 0 for I-cache
	.pipe_mem_write_addr(pipe_mem_write_addr), // mem addr the pipeline wants to write to
	.pipe_mem_write_data(pipe_mem_write_data), // data the pipeline wants to write to mem

	// Cache gets data from memory (when it wants to)
	.MemDataValid(MemDataValid),	// is data from memory valid?
	.mem_read_data(mem_read_data), // data read from memory

	// Cache controls Memory module (when it wants to)
	.cache_MemWrite(cache_MemWrite), // Does the cache want to write to mem?
	.cache_MemRead(cache_MemRead), // Does the cache want to read from mem
	.cache_mem_addr(cache_mem_addr), // addr cache specifies in mem control

	.cache_data_out(cache_data_out), // data read from the cache
	.CacheFinish(CacheFinish),
	.CacheHit(CacheHit),
	.CacheBusy(CacheBusy) // does the cache want any data from mem?
);

always #5 clk = ~clk;

assign WriteTagArray = DUT.WriteTagArray;

`ifdef DUMPFSDB
    initial begin
        $fsdbDumpfile("cache.fsdb");
        $fsdbDumpvars(0,"+all");
    end
 `endif

initial begin
	clk = 1;
	rst = 1;
	pipe_MemRead = 0;
	pipe_read_addr = 0;
	pipe_MemWrite = 0;
	pipe_mem_write_addr = 0;
	pipe_mem_write_data = 0;
	MemDataValid = 0;
	mem_read_data = 0;

	#10
	rst = 0;
	pipe_MemRead = 1;
	pipe_read_addr = 0;


	#40 
	MemDataValid = 1;
	mem_read_data = 1;

	#10
	mem_read_data = 2;

	#10
	mem_read_data = 3;

	#10
	mem_read_data = 4;

	#10
	mem_read_data = 5;

	#10
	mem_read_data = 6;

	#10
	mem_read_data = 7;

	#10
	mem_read_data = 8;

	#10
	MemDataValid = 0;

	#10
	pipe_read_addr = 0;

	#10
	pipe_read_addr = 2;

	#10
	pipe_read_addr = 4;

	#10
	pipe_read_addr = 6;

	#10
	pipe_read_addr = 8;

	#10
	pipe_read_addr = 10;

	#10
	pipe_read_addr = 12;

	#10
	pipe_read_addr = 14;

	#10
	pipe_read_addr = 16;


	#100
	$stop;
end // initial
endmodule // Cache_tb


