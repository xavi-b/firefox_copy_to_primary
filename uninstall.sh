#!/bin/bash
set -e

echo "======================================"
echo "Copy to PRIMARY Extension Uninstaller"
echo "======================================"
echo ""

NATIVE_HOST_DIR="$HOME/.mozilla/native-messaging-hosts"
MANIFEST_FILE="$NATIVE_HOST_DIR/copy_to_primary_host.json"
SCRIPT_FILE="$NATIVE_HOST_DIR/copy_to_primary_host.py"

echo "🗑️  Removing native messaging host files..."

if [ -f "$MANIFEST_FILE" ]; then
    rm "$MANIFEST_FILE"
    echo "   ✓ Removed: $MANIFEST_FILE"
else
    echo "   ⚠️  Not found: $MANIFEST_FILE"
fi

if [ -f "$SCRIPT_FILE" ]; then
    rm "$SCRIPT_FILE"
    echo "   ✓ Removed: $SCRIPT_FILE"
else
    echo "   ⚠️  Not found: $SCRIPT_FILE"
fi

echo ""
echo "✅ Uninstall complete!"
echo ""
echo "📌 Don't forget to remove the extension from Firefox:"
echo "   about:debugging#/runtime/this-firefox → Remove extension"
echo ""

