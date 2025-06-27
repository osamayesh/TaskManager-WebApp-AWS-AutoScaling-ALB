# 🖼️ Generate AWS Architecture Diagram PNG

This guide helps you generate a high-quality PNG image from the Mermaid diagram in `aws-architecture-diagram.md`.

## 🚀 **Quick Generation Methods**

### **Method 1: Using Mermaid CLI (Recommended)**

```bash
# Install Mermaid CLI
npm install -g @mermaid-js/mermaid-cli

# Generate PNG from the Mermaid diagram
mmdc -i ../aws-architecture-diagram.md -o aws-architecture-diagram.png -w 1200 -H 800 --backgroundColor white
```

### **Method 2: Using Online Mermaid Live Editor**

1. Go to [https://mermaid.live/](https://mermaid.live/)
2. Copy the Mermaid diagram code from `aws-architecture-diagram.md`
3. Paste it into the editor
4. Click **Actions** → **Download PNG**
5. Save as `aws-architecture-diagram.png` in this directory

### **Method 3: Using GitHub Mermaid Rendering**

1. GitHub automatically renders Mermaid diagrams in markdown files
2. You can screenshot the rendered diagram from GitHub
3. Or use GitHub's API to get the rendered SVG/PNG

### **Method 4: Using VS Code Extension**

1. Install "Mermaid Markdown Syntax Highlighting" extension
2. Open `aws-architecture-diagram.md` in VS Code
3. Right-click on the Mermaid diagram → **Export to PNG**

## 📏 **Image Specifications**

- **Width**: 1200px (recommended for README display)
- **Height**: Auto-calculated (approximately 800px)
- **Format**: PNG
- **Background**: White
- **DPI**: 300+ for crisp display
- **File Size**: Keep under 2MB

## 🔄 **Auto-Generation Script**

Create this script to automatically generate the diagram:

```bash
#!/bin/bash
# generate-diagram.sh

echo "🎨 Generating AWS Architecture Diagram..."

# Extract Mermaid code from markdown file
sed -n '/```mermaid/,/```/p' ../aws-architecture-diagram.md | sed '1d;$d' > temp-diagram.mmd

# Generate PNG
mmdc -i temp-diagram.mmd -o aws-architecture-diagram.png -w 1200 -H 800 --backgroundColor white

# Clean up
rm temp-diagram.mmd

echo "✅ Diagram generated: aws-architecture-diagram.png"
```

## 🎯 **Usage After Generation**

Once you have the PNG file:

1. **Commit to repository**:
   ```bash
   git add aws-architecture-diagram.png
   git commit -m "Add AWS architecture diagram PNG"
   git push origin main
   ```

2. **Update README links** to reference:
   ```markdown
   ![AWS Architecture](./images/aws-architecture-diagram.png)
   ```

3. **Access via GitHub URL**:
   ```
   https://raw.githubusercontent.com/osamayesh/TaskManager-WebApp-AWS-AutoScaling-ALB/main/ScalableTaskManager/TaskManagerAPI/images/aws-architecture-diagram.png
   ```

## 🔗 **Direct Links to Mermaid Diagram**

If you prefer to use the Mermaid diagram directly:

- **GitHub Rendered**: The diagram in `aws-architecture-diagram.md` is automatically rendered by GitHub
- **Raw Mermaid Code**: Available in the markdown file for copying to other tools
- **Live Editor**: Copy the code to [mermaid.live](https://mermaid.live) for editing and exporting

## 🆘 **Troubleshooting**

- **Mermaid CLI not working**: Try using the online editor instead
- **Image too large**: Reduce width parameter in mmdc command
- **Font issues**: Add `--configFile mermaid-config.json` with font settings
- **Background color**: Use `--backgroundColor transparent` for transparent background 