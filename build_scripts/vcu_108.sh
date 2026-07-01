#!/bin/bash
# =====================================================================
# build_soc_vcu108.sh - Configure and build SoC for VCU108 board
# with user-defined bus width
# =====================================================================

set -e
set -o pipefail
set -u

# ------------------------------
# Parse and validate user input
# ------------------------------
BUS_WIDTH="${1:-}"
if [[ -z "$BUS_WIDTH" ]]; then
    echo "Usage: $0 <bus_width>"
    echo "Example: $0 64"
    exit 1
fi

if [[ "$BUS_WIDTH" != "32" && "$BUS_WIDTH" != "64" && "$BUS_WIDTH" != "128" ]]; then
    echo "Error: Invalid bus width '$BUS_WIDTH'. Allowed values are 32, 64, or 128."
    exit 1
fi

# ------------------------------
# Setup paths
# ------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$ROOT_DIR"

echo "=== Building SoC for VCU108 with BUS_WIDTH = $BUS_WIDTH ==="
echo "Project root: $ROOT_DIR"

# ------------------------------
# Python environment setup
# ------------------------------
echo "=== Upgrading pip ==="
pip install --upgrade pip

echo "=== Uninstalling existing Python packages ==="
if [ -f requirements.txt ]; then
    pip uninstall -r requirements.txt -y || true
fi
pip uninstall soc_config -y || true

echo "=== Installing dependencies ==="
pip install -r requirements.txt

# ------------------------------
# Repo management
# ------------------------------
echo "=== Cleaning and updating dependencies ==="
repomanager --yaml "$ROOT_DIR/test_soc/vcu108/deps.yaml" --clean
repomanager --yaml "$ROOT_DIR/test_soc/vcu108/deps.yaml" -cup

# ------------------------------
# YQ configuration update
# ------------------------------
echo "=== Updating general SoC configuration ==="
yq -i '
  .hardfloat = false |
  .bsc_compile_options.test_memory_size = 33554432 |
  .bsc_compile_options.trace_dump = false |
  .bsc_compile_options.open_ocd = true |
  .bsc_compile_options.compile_target = "fpga" |
  .bsc_compile_options.top_module = "mkDebugSoc" |
  .bsc_compile_options.top_file = "DebugSoc.bsv" |
  .bsc_compile_options.top_dir = "test_soc/vcu108"
' "$ROOT_DIR/sample_config/c64/core64.yaml"

echo "=== Updating bus width in core configuration ==="
yq -i ".bus_protocol_configuration.bus_width = ${BUS_WIDTH}" "$ROOT_DIR/sample_config/c64/core64.yaml"

# ------------------------------
# SoC configuration
# ------------------------------
echo "=== Running soc_config ==="
soc_config \
  -ispec "$ROOT_DIR/sample_config/c64/rv64i_isa.yaml" \
  -customspec "$ROOT_DIR/sample_config/c64/rv64i_custom.yaml" \
  -cspec "$ROOT_DIR/sample_config/c64/core64.yaml" \
  -gspec "$ROOT_DIR/sample_config/c64/csr_grouping64.yaml" \
  -dspec "$ROOT_DIR/sample_config/c64/rv64i_debug.yaml" \
  --verbose info

# ------------------------------
# Verilog generation and FPGA build
# ------------------------------
echo "=== Generating Verilog ==="
make -j$(nproc) generate_verilog

echo "=== Building for VCU108 board ==="
export BOARD=vcu108
make ip_build
make board_build

echo "=== Build completed successfully for VCU108 with BUS_WIDTH = $BUS_WIDTH ==="
