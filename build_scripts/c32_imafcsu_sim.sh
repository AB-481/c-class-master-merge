#!/bin/bash
# =====================================================================
# build_soc_buswidth.sh - Configure and build SoC with default bus width = 32
# =====================================================================

set -e
set -o pipefail
set -u

# ------------------------------
# Bus Width (default = 32)
# ------------------------------
BUS_WIDTH="${1:-32}"   # If no argument passed, use 32

if [[ "$BUS_WIDTH" != "32" ]]; then
    echo "Error: This script supports ONLY 32-bit bus width."
    exit 1
fi

# ------------------------------
# Setup paths
# ------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$ROOT_DIR"

echo "=== Building SoC with BUS_WIDTH = $BUS_WIDTH ==="
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
repomanager --yaml "$ROOT_DIR/test_soc/c64_c32/c32imacsu_deps.yaml" --clean
repomanager --yaml "$ROOT_DIR/test_soc/c64_c32/c32imacsu_deps.yaml" -cup

# ------------------------------
# YQ configuration update
# ------------------------------
echo "=== Updating bus width in core configuration ==="
yq -i ".bus_protocol_configuration.bus_width = ${BUS_WIDTH}" "$ROOT_DIR/sample_config/c32_imafcsu/core32.yaml"

# ------------------------------
# SoC configuration
# ------------------------------
echo "=== Running soc_config ==="
soc_config \
  -ispec "$ROOT_DIR/sample_config/c32_imafcsu/rv32i_isa.yaml" \
  -customspec "$ROOT_DIR/sample_config/c32_imafcsu/rv32i_custom.yaml" \
  -cspec "$ROOT_DIR/sample_config/c32_imafcsu/core32.yaml" \
  -gspec "$ROOT_DIR/sample_config/c32_imafcsu/csr_grouping32.yaml" \
  -dspec "$ROOT_DIR/sample_config/c32_imafcsu/rv32i_debug.yaml" \
  --verbose info

# ------------------------------
# Verilog generation and linking
# ------------------------------
echo "=== Generating Verilog and boot files ==="
make -j$(nproc) generate_verilog
make link_verilator generate_boot_files

echo "=== Build completed successfully with BUS_WIDTH = $BUS_WIDTH ==="

# ------------------------------
# Run test in c-class directory
# ------------------------------
echo "=== Returning to c-class directory and running tests ==="

cd "$ROOT_DIR"

# Added export SOC=bsoc
export SOC=bsoc

make test opts='--test=add --suite=rv32ui --debug' CONFIG_ISA=RV32IMAFDCZicsr_zifencei

