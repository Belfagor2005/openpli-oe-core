#!/bin/bash

# Backup Script for Modified OpenPli Files
# Author: Lululla

# Configuration
SOURCE_BASE="/opt/corvoboys/openpli-oe-core"
DEST_DIR="/opt/corvoboys/backup_restore/scarthgap"
BACKUP_DATE=$(date +%Y%m%d_%H%M%S)
LOG_FILE="$DEST_DIR/backup_$BACKUP_DATE.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Colorized output functions
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

# Create destination directory with timestamp
DEST_DIR_WITH_DATE="$DEST_DIR/backup_$BACKUP_DATE"
mkdir -p "$DEST_DIR_WITH_DATE"

print_info "Starting backup to: $DEST_DIR_WITH_DATE"

# Create directory structure
mkdir -p "$DEST_DIR_WITH_DATE/meta-openpli/conf/distro"
mkdir -p "$DEST_DIR_WITH_DATE/meta-openpli/recipes-openpli/bootlogo/openpli-bootlogo"
mkdir -p "$DEST_DIR_WITH_DATE/meta-openpli/recipes-openpli/enigma2"
mkdir -p "$DEST_DIR_WITH_DATE/meta-openpli/recipes-openpli/images"
mkdir -p "$DEST_DIR_WITH_DATE/meta-openpli/recipes-openpli/enigma2-plugins"
mkdir -p "$DEST_DIR_WITH_DATE/meta-openpli/recipes-openpli/enigma2-skins"
mkdir -p "$DEST_DIR_WITH_DATE/meta-local/recipes-local/images"

# Array of files/directories to backup with descriptions
declare -A BACKUP_FILES=(
    ["meta-local/recipes-local/images/"]="Custom image recipes"
    ["meta-openpli/conf/distro/openpli-common.conf"]="Distribution common configuration"
    ["meta-openpli/recipes-openpli/bootlogo/openpli-bootlogo/"]="Bootlogo files (.mvi)"
    ["meta-openpli/recipes-openpli/enigma2/enigma-info.bb"]="Enigma2 info recipe"
    ["meta-openpli/recipes-openpli/enigma2/enigma2.bb"]="Main Enigma2 recipe"
    ["meta-openpli/recipes-openpli/images/openpli-enigma2-image.bb"]="Enigma2 image recipe"
    ["meta-openpli/recipes-openpli/images/openpli-image.bb"]="Base image recipe"
    ["meta-openpli/recipes-openpli/enigma2-plugins/enigma2-plugin-extensions-epgimport-99.bb"]="EPG Import plugin"
    ["meta-openpli/recipes-openpli/enigma2-plugins/enigma2-plugin-extensions-linuxsatpanel.bb"]="LinuxSat Panel plugin"
    ["meta-openpli/recipes-openpli/enigma2-plugins/enigma2-plugin-extensions-tvmanager.bb"]="TV Manager plugin"
    ["meta-openpli/recipes-openpli/enigma2-plugins/enigma2-plugin-extensions-xcforever.bb"]="XC Forever plugin"
    ["meta-openpli/recipes-openpli/enigma2-plugins/enigma2-plugin-oaweatherpli.bb"]="OA Weather plugin"
    ["meta-openpli/recipes-openpli/enigma2-skins/enigma2-plugin-skins-aglare.bb"]="Aglare skin"
)

# Backup function
backup_file() {
    local source_file="$1"
    local description="$2"

    if [[ -d "$SOURCE_BASE/$source_file" ]]; then
        shopt -s nullglob
        local files=("$SOURCE_BASE/$source_file"/*)  # prende TUTTI i file
        if [[ ${#files[@]} -gt 0 ]]; then
            mkdir -p "$DEST_DIR_WITH_DATE/$source_file"
            cp -a "${files[@]}" "$DEST_DIR_WITH_DATE/$source_file/"
            print_info "✓ Backed up directory: $description"
        else
            print_warning "⚠ Directory empty or not found: $source_file"
        fi
    elif [[ -f "$SOURCE_BASE/$source_file" ]]; then
        mkdir -p "$(dirname "$DEST_DIR_WITH_DATE/$source_file")"
        if cp "$SOURCE_BASE/$source_file" "$DEST_DIR_WITH_DATE/$source_file"; then
            print_info "✓ Backed up: $description"
        else
            print_error "✗ Failed to backup: $source_file"
        fi
    else
        print_warning "⚠ File or directory not found: $source_file"
    fi
}

# Execute backup
print_info "Starting backup process..."
for file_path in "${!BACKUP_FILES[@]}"; do
    backup_file "$file_path" "${BACKUP_FILES[$file_path]}"
done

# Create restore script
print_info "Creating restore script..."
cat > "$DEST_DIR_WITH_DATE/restore_backup.sh" << 'EOF'
#!/bin/bash
# Restore Script for OpenPli Backup

SOURCE_BASE="/opt/corvoboys/openpli-oe-core"
BACKUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Restoring backup from: $BACKUP_DIR"

read -p "Are you sure you want to restore? This will overwrite existing files! (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Restore cancelled."
    exit 1
fi

# Restore files
find "$BACKUP_DIR" -type f \( -name "*.bb" -o -name "*.conf" -o -name "*.mvi" \) | while read -r backup_file; do
    relative_path="${backup_file#$BACKUP_DIR/}"
    target_file="$SOURCE_BASE/$relative_path"
    
    if [[ -f "$target_file" ]]; then
        cp "$backup_file" "$target_file"
        echo "Restored: $relative_path"
    else
        echo "Target not found, skipping: $relative_path"
    fi
done

echo "Restore completed!"
EOF

chmod +x "$DEST_DIR_WITH_DATE/restore_backup.sh"

# Create file list
print_info "Creating file list..."
find "$DEST_DIR_WITH_DATE" -type f > "$DEST_DIR_WITH_DATE/backup_file_list.txt"

# Summary
print_info "=== BACKUP SUMMARY ==="
print_info "Backup location: $DEST_DIR_WITH_DATE"
print_info "Total files backed up: $(find "$DEST_DIR_WITH_DATE" -type f | wc -l)"
print_info "Log file: $LOG_FILE"
print_info "Restore script: $DEST_DIR_WITH_DATE/restore_backup.sh"

print_info "Backup completed successfully! 🎉"
