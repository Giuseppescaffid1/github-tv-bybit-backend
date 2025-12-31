#!/bin/bash
# Script to organize files into a folder for Render deployment

FOLDER_NAME="app"  # Change this to your preferred folder name

echo "📁 Creating folder: $FOLDER_NAME"
mkdir -p "$FOLDER_NAME"

echo "📦 Moving application files..."
mv app.py "$FOLDER_NAME/"
mv data_collector.py "$FOLDER_NAME/"
mv database.py "$FOLDER_NAME/"
mv source.py "$FOLDER_NAME/"
mv requirements.txt "$FOLDER_NAME/"
mv Procfile "$FOLDER_NAME/"
mv __init__.py "$FOLDER_NAME/"

echo "✅ Files moved to $FOLDER_NAME/"
echo ""
echo "📝 Next steps:"
echo "1. Update render.yaml: Change rootDir from '.' to '$FOLDER_NAME'"
echo "2. Move render.yaml to $FOLDER_NAME/ OR keep in root (both work)"
echo "3. Commit and push: git add . && git commit -m 'Organize files into $FOLDER_NAME' && git push"

