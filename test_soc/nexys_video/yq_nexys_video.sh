set -x

/usr/local/bin/yq -i '
.bsc_compile_options.test_memory_size=33554432 |
.bsc_compile_options.trace_dump=False |
.bsc_compile_options.compile_target="fpga" |
.bsc_compile_options.top_module="mkDebugSoc" |
.bsc_compile_options.top_file="DebugSoc.bsv" |
.bsc_compile_options.top_dir="test_soc/nexys_video"
' sample_config/c64/core64.yaml
