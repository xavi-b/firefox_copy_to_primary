#!/bin/bash
set -e

echo "=================================="
echo "Copy to PRIMARY Extension Installer"
echo "=================================="
echo ""

# Check if xclip is installed
if ! command -v xclip &> /dev/null; then
    echo "⚠️  xclip is not installed"
    echo "   Install it with: sudo apt install xclip (or equivalent for your distro)"
    read -p "   Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "📂 Extension directory: $SCRIPT_DIR"
echo ""

# Create native messaging host directory
NATIVE_HOST_DIR="$HOME/.mozilla/native-messaging-hosts"
echo "📁 Creating directory: $NATIVE_HOST_DIR"
mkdir -p "$NATIVE_HOST_DIR"

# Copy and process the manifest file
MANIFEST_SRC="$SCRIPT_DIR/native_host/host-manifest.json"
MANIFEST_DST="$NATIVE_HOST_DIR/copy_to_primary_host.json"

echo "📝 Installing native messaging manifest..."
sed "s|HOME_PATH|$HOME|g" "$MANIFEST_SRC" > "$MANIFEST_DST"
echo "   Installed to: $MANIFEST_DST"

# Copy the Python script
SCRIPT_SRC="$SCRIPT_DIR/native_host/copy_to_primary_host.py"
SCRIPT_DST="$NATIVE_HOST_DIR/copy_to_primary_host.py"

echo "🐍 Installing Python native host script..."
cp "$SCRIPT_SRC" "$SCRIPT_DST"
chmod +x "$SCRIPT_DST"
echo "   Installed to: $SCRIPT_DST"

# Verify the installation
echo ""
echo "✅ Installation complete!"
echo ""
echo "📋 Installed files:"
echo "   - $MANIFEST_DST"
echo "   - $SCRIPT_DST"
echo ""
echo "🔍 Manifest contents:"
cat "$MANIFEST_DST"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📌 Next steps:"
echo "   1. Open Firefox"
echo "   2. Go to: about:debugging#/runtime/this-firefox"
echo "   3. Click 'Load Temporary Add-on'"
echo "   4. Select: $SCRIPT_DIR/manifest.json"
echo ""
echo "   For permanent installation, see:"
echo "   https://extensionworkshop.com/documentation/publish/signing-and-distribution-overview/"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

