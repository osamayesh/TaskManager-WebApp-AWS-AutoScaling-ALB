#!/bin/bash

# 🖼️ Generate AWS Architecture Diagram PNG
# This script generates a PNG image from the Mermaid diagram

echo "🎨 Generating AWS Architecture Diagram PNG..."

# Check if mermaid-cli is installed
if ! command -v mmdc &> /dev/null; then
    echo "❌ Mermaid CLI not found. Installing..."
    echo "📦 Installing @mermaid-js/mermaid-cli globally..."
    npm install -g @mermaid-js/mermaid-cli
    
    if [ $? -ne 0 ]; then
        echo "❌ Failed to install Mermaid CLI. Please install Node.js and npm first."
        echo "💡 Alternative: Use the online editor at https://mermaid.live/"
        echo "   Copy the code from mermaid-diagram-code.txt and export as PNG"
        exit 1
    fi
fi

# Check if the Mermaid code file exists
if [ ! -f "mermaid-diagram-code.txt" ]; then
    echo "❌ mermaid-diagram-code.txt not found!"
    echo "💡 Make sure you're in the images/ directory"
    exit 1
fi

# Generate PNG from Mermaid code
echo "🔄 Generating PNG from Mermaid diagram..."
mmdc -i mermaid-diagram-code.txt -o aws-architecture-diagram.png -w 1200 -H 800 --backgroundColor white

if [ $? -eq 0 ]; then
    echo "✅ Successfully generated: aws-architecture-diagram.png"
    echo "📏 Dimensions: 1200x800px"
    echo "🎯 Ready to commit to repository!"
    echo ""
    echo "📋 Next steps:"
    echo "   git add aws-architecture-diagram.png"
    echo "   git commit -m 'Add AWS architecture diagram PNG'"
    echo "   git push origin main"
else
    echo "❌ Failed to generate PNG"
    echo "💡 Try using the online editor instead:"
    echo "   1. Go to https://mermaid.live/"
    echo "   2. Copy the code from mermaid-diagram-code.txt"
    echo "   3. Paste it and click 'Actions' → 'Download PNG'"
fi 