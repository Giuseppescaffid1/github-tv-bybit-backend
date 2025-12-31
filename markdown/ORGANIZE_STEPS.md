# 📁 Organize Files into Folder - Step by Step

## Quick Steps

### Option 1: Use the Script (Easiest)

```bash
# Make script executable
chmod +x MOVE_TO_FOLDER.sh

# Run it (it will create 'app' folder)
./MOVE_TO_FOLDER.sh
```

### Option 2: Manual Steps

```bash
# 1. Create folder (choose a name - I suggest "app")
mkdir app

# 2. Move all application files
mv app.py app/
mv data_collector.py app/
mv database.py app/
mv source.py app/
mv requirements.txt app/
mv Procfile app/
mv __init__.py app/
```

## After Moving Files

### 1. Update render.yaml

I've already updated `render.yaml` to use `rootDir: app`.

**If you used a different folder name**, change it:
```yaml
rootDir: your-folder-name  # Change this
```

### 2. Choose render.yaml Location

**Option A: Keep render.yaml in root** (Recommended)
- Keep `render.yaml` in repository root
- Set `rootDir: app` (already done)

**Option B: Move render.yaml to folder**
- Move `render.yaml` to `app/` folder
- Set `rootDir: .` (means "current folder")

## Final Structure

```
github-tv-bybit-backend/
  ├── app/                    ← Your app folder
  │   ├── app.py
  │   ├── data_collector.py
  │   ├── database.py
  │   ├── source.py
  │   ├── requirements.txt    ← Render will find this!
  │   ├── Procfile
  │   └── __init__.py
  ├── render.yaml             ← In root, pointing to app/
  ├── README.md
  └── ... (other files)
```

## Commit and Push

```bash
# Add all changes
git add .

# Commit
git commit -m "Organize files into app folder for Render deployment"

# Push
git push
```

## Verify

After pushing:
1. Render will detect the new structure
2. It will look in `app/` folder for `requirements.txt`
3. Build should succeed!

## Important Notes

- ✅ `rootDir: app` tells Render to use the `app/` folder as root
- ✅ All files (`requirements.txt`, `app.py`, etc.) must be in the same folder
- ✅ `render.yaml` can stay in root OR move to folder (both work)

