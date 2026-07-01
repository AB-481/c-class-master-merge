#!/bin/bash
# =====================================================================
# build_soc.sh - Automates SoC configuration, repo management, and build
# =====================================================================

set -e
set -o pipefail
set -u

# ------------------------------
# Parse and validate user input (added like VCU108 script)
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

echo "=== Detected project root: $ROOT_DIR ==="
cd "$ROOT_DIR"

echo "=== Upgrading pip ==="
pip install --upgrade pip

echo "=== Uninstalling previous Python packages ==="
if [ -f requirements.txt ]; then
    pip uninstall -r requirements.txt -y || true
else
    echo "WARNING: requirements.txt not found in $ROOT_DIR"
fi
pip uninstall soc_config -y || true

echo "=== Installing dependencies ==="
pip install -r requirements.txt

echo "=== Cleaning and updating dependencies using repomanager ==="
repomanager --yaml "$ROOT_DIR/test_soc/nexys_video/deps.yaml" --clean
repomanager --yaml "$ROOT_DIR/test_soc/nexys_video/deps.yaml" -cup

echo "=== Modifying core configuration using yq ==="
yq -i '
  .hardfloat = false |
  .bsc_compile_options.test_memory_size = 33554432 |
  .bsc_compile_options.trace_dump = false |
  .bsc_compile_options.compile_target = "fpga" |
  .bsc_compile_options.top_module = "mkDebugSoc" |
  .bsc_compile_options.top_file = "DebugSoc.bsv" |
  .bsc_compile_options.top_dir = "test_soc/nexys_video"
' "$ROOT_DIR/sample_config/c64/core64.yaml"

# ------------------------------
# Bus width update (added exactly like VCU108 script)
# ------------------------------
echo "=== Updating bus width in core configuration ==="
yq -i ".bus_protocol_configuration.bus_width = ${BUS_WIDTH}" "$ROOT_DIR/sample_config/c64/core64.yaml"

echo "=== Running soc_config ==="
soc_config \
  -ispec "$ROOT_DIR/sample_config/c64/rv64i_isa.yaml" \
  -customspec "$ROOT_DIR/sample_config/c64/rv64i_custom.yaml" \
  -cspec "$ROOT_DIR/sample_config/c64/core64.yaml" \
  -gspec "$ROOT_DIR/sample_config/c64/csr_grouping64.yaml" \
  -dspec "$ROOT_DIR/sample_config/c64/rv64i_debug.yaml" \
  --verbose info

echo "=== Generating Verilog ==="
make -j$(nproc) generate_verilog

echo "=== Building for Nexys Video board ==="
export BOARD=nexys_video
make ip_build
make board_build

echo "=== Build complete for Nexys Video with BUS_WIDTH = $BUS_WIDTH ==="

