#!/bin/bash
cd /opt/corvoboys/openpli-oe-core   # <-- correggi qui

# Poi nella riga che cerca il tuo script, metti il nome corretto:
echo "=== MODEL COMPARISON ==="
echo

echo Extract current models
find meta-* -name "*.conf" -path "*/conf/machine/*" -exec basename {} .conf \; | sort > /tmp/current_models.txt
# find . -name "*.conf" | grep -E "/machine/.*\.conf" | sed 's/.*\/\(.*\)\.conf/\1/' | sort -u

echo Extract models from your script
grep -o 'MODELS_[A-Za-z0-9]*=(\[[0-9]*\]="[^"]*"' /opt/corvoboys/openpli-oe-core/build_all_models.sh | cut -d'"' -f2 | sort > /tmp/script_models.txt
# grep -oP '"\K[^"]+' build_all_models.sh | grep -v '^[0-9]' | sort -u > /tmp/script_reali.txt


echo "STATISTICS:"
echo "Models in the code: $(wc -l < /tmp/current_models.txt)"
echo "Models in your script: $(wc -l < /tmp/script_models.txt)"
echo

echo "❌ REMOVE THIS MODELS (no longer supported):"
comm -13 /tmp/current_reali.txt /tmp/script_reali.txt

echo -e "\n✅ ADD THESE MODELS (new available):"
comm -23 /tmp/current_reali.txt /tmp/script_reali.txt