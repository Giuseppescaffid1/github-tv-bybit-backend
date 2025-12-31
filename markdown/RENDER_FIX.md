# 🔧 Fix: requirements.txt Not Found on Render

## Problem
Render can't find `requirements.txt` during build:
```
ERROR: Could not open requirements file: [Errno 2] No such file or directory: 'requirements.txt'
```

## Solutions

### Solution 1: Verify File is Committed to Git

Make sure `requirements.txt` is committed:

```bash
# Check if file is tracked
git ls-files | grep requirements.txt

# If not, add and commit it
git add requirements.txt
git commit -m "Add requirements.txt"
git push
```

### Solution 2: Check Repository Structure

If your repository has a subdirectory structure, you may need to set `rootDir` in `render.yaml`.

**If your repo structure is:**
```
github-tv-bybit-backend/
  ├── requirements.txt
  ├── app.py
  ├── data_collector.py
  └── render.yaml
```

Then `rootDir: .` (current directory) is correct.

**If your repo structure is:**
```
github-tv-bybit-backend/
  └── liquidity-imbalance-strategy/
      ├── requirements.txt
      ├── app.py
      └── render.yaml
```

Then you need `rootDir: liquidity-imbalance-strategy` in `render.yaml`.

### Solution 3: Update render.yaml

I've already added `rootDir: .` to your `render.yaml`. This tells Render to use the repository root as the working directory.

### Solution 4: Manual Service Configuration

If using Blueprint doesn't work, manually configure:

1. **Go to Render Dashboard** → Your service → "Settings"
2. **Check "Root Directory"**:
   - If empty, set it to `.` (repository root)
   - Or set to the subdirectory where `requirements.txt` is located
3. **Save changes** and redeploy

## Quick Fix Steps

1. **Verify file exists and is committed:**
   ```bash
   git status
   git add requirements.txt
   git commit -m "Ensure requirements.txt is committed"
   git push
   ```

2. **Check render.yaml has rootDir:**
   - Should have `rootDir: .` for both services
   - Already added in the updated render.yaml

3. **Redeploy on Render:**
   - Go to your service → "Manual Deploy" → "Deploy latest commit"
   - Or push a new commit to trigger auto-deploy

## Verify

After fixing, the build should show:
```
==> Running build command 'pip install -r requirements.txt'...
Collecting dash>=2.14.0
...
Successfully installed ...
```

Instead of the error message.

