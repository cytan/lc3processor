#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    FILE *fp;
	int i4, i32, i256, index;
    fp = fopen("out.txt", "w");
	for (i4=0 ; i4<4 ; i4++)
	{
		index = 0;
		for (i32=0 ; i32<16 ; i32++)
		{
    		fprintf(fp, "set_multicycle_path -from [get_registers {");
			for (i256=0 ; i256<256 ; i256++, index++)
			{
				fprintf(fp, "l2_cache:l2cache|l2_cache_datapath:l2_datapath|l2_array:data_array_%d|data~%d ", i4, index);
			}
			fprintf(fp, "}] -to [get_ports {");
			for (i256=0 ; i256<256 ; i256++)
			{
				fprintf(fp, "wdata[%d] ", i256);
			}
			fprintf(fp, "}] -setup -end 2\n");
		}
	}
}


// set_multicycle_path -from [get_registers {l2_cache:l2cache|l2_cache_datapath:l2_datapath|l2_array:data_array_1|data~0 l2_cache:l2cache|l2_cache_datapath:l2_datapath|l2_array:data_array_1|data~1 l2_cache:l2cache|l2_cache_datapath:l2_datapath|l2_array:data_array_1|data~2}] -to [get_ports {wdata[0] wdata[1] wdata[2] wdata[3]}] -setup -end 2
