# 🔍 Debug: requirements.txt Still Not Found

## Quick Checks

### 1. Verify File is Committed to Git

```bash
# Check if file is tracked
git ls-files | grep requirements.txt

# If nothing shows, the file isn't committed:
git add requirements.txt
git commit -m "Add requirements.txt"
git push
```

### 2. Check .gitignore

Make sure `requirements.txt` is NOT in `.gitignore`:

```bash
cat .gitignore | grep requirements
```

If it shows up, remove that line from `.gitignore`.

### 3. Verify File is in Repository Root on GitHub

1. Go to your GitHub repository
2. Check if `requirements.txt` is visible in the root directory
3. If it's not there, it wasn't committed/pushed

### 4. Check render.yaml Format

The `rootDir` should be exactly `.` (dot):

```yaml
services:
  - type: web
    rootDir: .  # ← This should be exactly "."
```

### 5. Alternative: Use Absolute Path in buildCommand

If `rootDir` doesn't work, try specifying the full path:

```yaml
buildCommand: cd /opt/render/project/src && pip install -r requirements.txt
```

But this is usually not needed if `rootDir: .` is set correctly.

## Most Common Issue

**The file isn't committed to git!**

Even if it exists locally, Render can only see files that are:
1. Committed to git
2. Pushed to GitHub
3. Not in .gitignore

## Fix Steps

1. **Check git status:**
   ```bash
   git status
   ```

2. **If requirements.txt shows as untracked:**
   ```bash
   git add requirements.txt
   git commit -m "Add requirements.txt for Render deployment"
   git push
   ```

3. **Verify on GitHub:**
   - Go to your repo on GitHub
   - Check if `requirements.txt` is visible in root
   - If yes, Render should see it after next deploy

4. **Redeploy on Render:**
   - Go to service → "Manual Deploy" → "Deploy latest commit"

## Alternative Solution: Create requirements.txt in Build

If the file still can't be found, you can create it during build:

```yaml
buildCommand: |
  echo "dash>=2.14.0" > requirements.txt
  echo "plotly>=5.17.0" >> requirements.txt
  echo "pandas>=2.0.0" >> requirements.txt
  echo "numpy>=1.24.0" >> requirements.txt
  echo "websocket-client>=1.6.0" >> requirements.txt
  echo "sqlalchemy>=2.0.0" >> requirements.txt
  echo "psycopg2-binary>=2.9.0" >> requirements.txt
  echo "gunicorn>=21.2.0" >> requirements.txt
  echo "python-dotenv>=1.0.0" >> requirements.txt
  pip install -r requirements.txt
```

But this is a workaround - the real fix is to commit the file to git.

