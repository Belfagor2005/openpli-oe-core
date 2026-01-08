#!/bin/bash
cd /openpli-oe-core

echo "=== MODEL COMPARISON ==="
echo

# Extract current models
find meta-* -name "*.conf" -path "*/conf/machine/*" -exec basename {} .conf \; | sort > /tmp/current_models.txt

# Extract models from your script
grep -o 'MODELS_[A-Za-z0-9]*=(\[[0-9]*\]="[^"]*"' /opt/corvoboys/openpli-oe-core/script.sh | cut -d'"' -f2 | sort > /tmp/script_models.txt

echo "STATISTICS:"
echo "Models in the code: $(wc -l < /tmp/current_models.txt)"
echo "Models in your script: $(wc -l < /tmp/script_models.txt)"
echo

echo "NEW MODELS TO ADD:"
comm -23 /tmp/current_models.txt /tmp/script_models.txt

echo
echo "MODELS TO REMOVE (IN SCRIPT BUT NOT IN
