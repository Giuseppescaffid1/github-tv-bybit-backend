# ✅ Pre-Deployment Checklist

## Code Structure ✅
- [x] All files in root directory (no `streamlit/` subdirectory)
- [x] `data_collector.py` in root
- [x] `app.py` in root
- [x] `database.py` in root
- [x] `source.py` in root

## Imports Fixed ✅
- [x] `data_collector.py`: Uses `from database import ...` (not `streamlit.database`)
- [x] `app.py`: Uses `from database import ...` and `from source import ...`
- [x] No `from streamlit.` imports in code files

## Configuration Files ✅
- [x] `render.yaml`: Updated for flat structure
  - [x] Web service: `python -c "from database import init_db; init_db()" && gunicorn ...`
  - [x] Worker service: `python data_collector.py`
- [x] `Procfile`: Updated for flat structure
- [x] `requirements.txt`: All dependencies listed

## Database Configuration ✅
- [x] `database.py` handles `DATABASE_URL` from environment
- [x] Converts `postgres://` to `postgresql://` automatically
- [x] `.env` file is gitignored (won't be deployed)

## Ready to Deploy ✅

### Before Pushing:
1. ✅ All imports fixed
2. ✅ `render.yaml` updated
3. ✅ `Procfile` updated
4. ✅ No `cd streamlit` commands
5. ✅ All files in root directory

### After Deploying to Render:

1. **Set Environment Variables:**
   - Go to Web Service → Environment → Add `DATABASE_URL` (Internal Database URL)
   - Go to Worker Service → Environment → Add `DATABASE_URL` (same value)

2. **Verify Deployment:**
   - Check worker logs: Should see `✅ Saved tick #1 to database`
   - Check web logs: Should see `✅ Database tables initialized`
   - Visit dashboard: Should show data (wait 5-10 minutes)

3. **Health Check:**
   - Visit: `https://your-app.onrender.com/health`
   - Should show: `"total_ticks": X` where X > 0

## Files Changed for Deployment:
- ✅ `data_collector.py` - Fixed imports
- ✅ `app.py` - Fixed imports
- ✅ `database.py` - Fixed .env path
- ✅ `render.yaml` - Removed `cd streamlit`
- ✅ `Procfile` - Removed `cd streamlit`

## You're Ready! 🚀

```bash
git add .
git commit -m "Fix imports and structure for Render deployment"
git push
```

Then set `DATABASE_URL` in both services on Render!

