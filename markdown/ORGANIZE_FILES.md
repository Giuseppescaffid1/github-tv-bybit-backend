# 📁 Organize Files into Folder for Render

## Step 1: Create Folder

Create a folder for your app (e.g., `app` or `bybit-trading`):

```bash
mkdir app
```

## Step 2: Move Files to Folder

Move all your app files to the folder:

```bash
# Move main application files
mv app.py app/
mv data_collector.py app/
mv database.py app/
mv source.py app/
mv requirements.txt app/
mv render.yaml app/
mv Procfile app/
mv __init__.py app/

# Move documentation (optional - you can keep these in root)
# mv *.md app/
```

## Step 3: Update render.yaml

After moving files, update `render.yaml` in the folder:

```yaml
services:
  - type: web
    name: bybit-trading-dashboard
    runtime: python
    rootDir: app  # ← Change to folder name
    buildCommand: pip install -r requirements.txt
    startCommand: python -c "from database import init_db; init_db()" && gunicorn --bind 0.0.0.0:$PORT app:server
    # ... rest of config
```

## Step 4: Update render.yaml in Root (if needed)

If you keep `render.yaml` in root, update it to point to the folder:

```yaml
services:
  - type: web
    name: bybit-trading-dashboard
    runtime: python
    rootDir: app  # ← Your folder name
    buildCommand: pip install -r requirements.txt
    # ... rest
```

## Final Structure

```
github-tv-bybit-backend/
  ├── app/                    ← Your app folder
  │   ├── app.py
  │   ├── data_collector.py
  │   ├── database.py
  │   ├── source.py
  │   ├── requirements.txt
  │   ├── render.yaml         ← Can be here OR in root
  │   ├── Procfile
  │   └── __init__.py
  ├── render.yaml             ← OR keep here (pointing to app/)
  └── README.md               ← Keep in root
```

## Important Notes

1. **rootDir in render.yaml**: Set to your folder name (e.g., `app`)
2. **All files in folder**: Make sure `requirements.txt`, `app.py`, etc. are all in the same folder
3. **render.yaml location**: Can be in root OR in the folder (both work)

