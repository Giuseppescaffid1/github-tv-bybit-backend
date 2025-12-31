# 🔧 Fix: requirements.txt Error on Render

## The Problem

Render can't find `requirements.txt` because **it's not committed to git**.

Render only sees files that are:
1. ✅ Committed to git
2. ✅ Pushed to GitHub
3. ✅ Not in .gitignore

## Quick Fix

Run these commands:

```bash
# 1. Check if file is tracked by git
git ls-files | grep requirements.txt

# 2. If nothing shows, add and commit it:
git add requirements.txt
git commit -m "Add requirements.txt for Render deployment"
git push
```

## Verify on GitHub

1. Go to your GitHub repository
2. Check if `requirements.txt` is visible in the root directory
3. If you can see it on GitHub, Render will see it after next deploy

## After Committing

1. **Wait for auto-deploy** (if enabled), OR
2. **Manual deploy**: Go to Render → Your service → "Manual Deploy" → "Deploy latest commit"

## Alternative: Check Render Settings

If the file IS committed but still not found:

1. Go to Render Dashboard → Your service → "Settings"
2. Check "Root Directory":
   - Should be **empty** (means repository root)
   - OR set to `.` (repository root)
3. Save and redeploy

## Most Common Issue

**99% of the time**, the file just isn't committed to git. 

Check with:
```bash
git status
```

If `requirements.txt` shows as "untracked" or "modified", commit it!

