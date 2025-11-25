#!/bin/bash
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
VERSION=$(grep '"version"' "$SCRIPT_DIR/manifest.json" | cut -d'"' -f4)
EXTENSION_NAME="copy-to-primary"
XPI_NAME="${EXTENSION_NAME}-${VERSION}.xpi"

echo "=================================="
echo "Packaging Firefox Extension"
echo "=================================="
echo ""

# Create temporary directory
TEMP_DIR=$(mktemp -d)
echo "📦 Creating package in: $TEMP_DIR"

# Copy extension files (exclude development files)
echo "📋 Copying extension files..."
cp "$SCRIPT_DIR/manifest.json" "$TEMP_DIR/"
cp "$SCRIPT_DIR/background.js" "$TEMP_DIR/"
cp "$SCRIPT_DIR/content_script.js" "$TEMP_DIR/"
cp "$SCRIPT_DIR/page_script.js" "$TEMP_DIR/"

# Create XPI file (ZIP archive)
cd "$TEMP_DIR"
zip -r "$SCRIPT_DIR/$XPI_NAME" . > /dev/null
cd - > /dev/null

# Cleanup
rm -rf "$TEMP_DIR"

echo "✅ Package created: $XPI_NAME"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⚠️  Firefox requires signed extensions. Choose an option:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "OPTION 1: Sign Extension (Recommended - Free & Official)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1. Go to: https://addons.mozilla.org/developers/addon/submit/"
echo "2. Sign in with Firefox Account"
echo "3. Click 'Submit a New Add-on'"
echo "4. Choose 'On your own' (self-distribution)"
echo "5. Upload: $XPI_NAME"
echo "6. Download the signed version"
echo "7. Drag signed XPI into Firefox"
echo ""
echo "OPTION 2: Disable Signature Check (Developer/ESR only)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⚠️  Only works in Firefox Developer Edition or ESR"
echo ""
echo "1. Open Firefox"
echo "2. Go to: about:config"
echo "3. Search: xpinstall.signatures.required"
echo "4. Double-click to set to: false"
echo "5. Accept warning"
echo "6. Drag $XPI_NAME into Firefox"
echo ""
echo "OPTION 3: Use Temporary Add-on (No signing needed)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1. Go to: about:debugging#/runtime/this-firefox"
echo "2. Click 'Load Temporary Add-on'"
echo "3. Select: manifest.json"
echo "⚠️  Note: Must reload after each Firefox restart"
echo ""

