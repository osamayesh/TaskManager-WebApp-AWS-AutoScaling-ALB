# 🖼️ Architecture Diagrams

This directory contains visual representations of the TaskManager API AWS architecture.

## 🚨 **Quick Fix for 404 Error**

If you're getting a **404 error** for `aws-architecture-diagram.png`, the PNG file doesn't exist yet. Here's the fastest solution:

### **🎯 Method 1: Online Mermaid Editor (2 minutes)**
1. **Copy the diagram code**: Open `mermaid-diagram-code.txt` in this directory
2. **Go to**: [https://mermaid.live/](https://mermaid.live/)
3. **Paste** the code into the editor
4. **Download**: Click **Actions** → **Download PNG**
5. **Save as**: `aws-architecture-diagram.png` in this directory
6. **Commit**: `git add aws-architecture-diagram.png && git commit -m "Add architecture diagram PNG" && git push`

### **🎯 Method 2: Use the Shell Script**
```bash
cd images/
chmod +x generate-png.sh
./generate-png.sh
```

### **🎯 Method 3: View the Diagram Directly**
The complete architecture diagram is already available in the main file:
- **📋 View on GitHub**: `aws-architecture-diagram.md` (automatically rendered)
- **🔗 Direct Link**: [Architecture Documentation](../aws-architecture-diagram.md)

## 📁 Files

### **aws-architecture-diagram.png** *(To be generated)*
- **Source**: Mermaid diagram or Lucidchart
- **Format**: High-resolution PNG (300+ DPI)
- **Usage**: Main README documentation
- **Size**: Recommended max 2MB for fast loading

### **mermaid-diagram-code.txt**
- **Source**: Extracted from `aws-architecture-diagram.md`
- **Format**: Plain text Mermaid code
- **Usage**: Copy to Mermaid Live Editor for PNG generation
- **Purpose**: Easy copying without formatting issues

### **generate-png.sh**
- **Source**: Automated shell script
- **Format**: Bash script
- **Usage**: Auto-generates PNG from Mermaid code
- **Requirements**: Node.js and npm for Mermaid CLI

### **generate-diagram.md**
- **Source**: Documentation
- **Format**: Markdown guide
- **Usage**: Complete instructions for PNG generation
- **Methods**: Multiple approaches (CLI, online, VS Code)

### **aws-architecture-diagram.svg** *(Optional)*
- **Source**: Mermaid or Lucidchart SVG export
- **Format**: Scalable Vector Graphics
- **Usage**: Web presentations, scaling without quality loss
- **Size**: Typically smaller than PNG

## 🎨 How to Add Your Lucidchart Diagram

### **Step 1: Export from Lucidchart**
1. Open your Lucidchart diagram
2. Click **File** → **Download**
3. Choose **PNG** format
4. Set resolution to **300 DPI** or higher
5. Save as `aws-architecture-diagram.png`

### **Step 2: Add to Repository**
1. Copy the exported file to this `images/` directory
2. Commit and push to repository:
   ```bash
   git add images/aws-architecture-diagram.png
   git commit -m "Add Lucidchart AWS architecture diagram"
   git push origin main
   ```

### **Step 3: Update Links** *(if needed)*
If you want to share the live Lucidchart diagram:
1. In Lucidchart, click **Share** → **Publish**
2. Copy the public link
3. Update the link in the main README.md file

## 📏 Image Guidelines

- **Resolution**: Minimum 300 DPI for crisp display
- **Format**: PNG for photos, SVG for vector graphics
- **Size**: Keep under 2MB for fast GitHub loading
- **Dimensions**: Recommended 1200px width for README display
- **Background**: Use white or transparent background

## 🔄 Version Control

When updating diagrams:
1. Keep the same filename to maintain README links
2. Add version comments in commit messages
3. Consider keeping previous versions with date suffixes if major changes 