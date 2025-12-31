# 🔧 Web Service Setup on Render

## What You Need to Do

Since you already have:
- ✅ Database (PostgreSQL)
- ✅ Worker service (bybit-data-collector)
- ✅ Web service (bybit-trading-dashboard)

You just need to **configure the web service** to connect to the database.

## Step 1: Get Database URL

1. Go to your **PostgreSQL database** service on Render
2. Click **"Connect"** tab
3. Copy the **"Internal Database URL"** (starts with `postgres://`)
   - **Important**: Use **Internal** URL, not External
   - Format: `postgres://user:password@host:port/database`

## Step 2: Set Environment Variable in Web Service

1. Go to your **Web Service** (`bybit-trading-dashboard`)
2. Click **"Environment"** tab (in the left sidebar)
3. Click **"Add Environment Variable"**
4. Enter:
   - **Key**: `DATABASE_URL`
   - **Value**: Paste the **Internal Database URL** from Step 1
5. Click **"Save Changes"**
6. The service will automatically restart

## Step 3: Verify Worker Service Also Has DATABASE_URL

1. Go to your **Worker Service** (`bybit-data-collector`)
2. Click **"Environment"** tab
3. Check if `DATABASE_URL` exists
4. If **missing**, add it (same value as web service)
5. If **exists**, verify it's the same Internal Database URL

## Step 4: Verify Everything Works

### Check Web Service Logs:

1. Go to Web Service → **"Logs"** tab
2. Look for:
   ```
   ✅ Using DATABASE_URL from environment
   ✅ Database tables initialized
   ✅ Retrieved X ticks from database
   ```

### Check Worker Service Logs:

1. Go to Worker Service → **"Logs"** tab
2. Look for:
   ```
   ✅ Database connection successful
   ✅ Saved tick #1 to database
   💓 Heartbeat #1 - Collected 60 ticks so far
   ```

### Check Web Dashboard:

1. Visit your web service URL: `https://your-app.onrender.com`
2. Should show charts with data (wait 5-10 minutes if just started)
3. Visit health endpoint: `https://your-app.onrender.com/health`
   - Should show: `"total_ticks": X` where X > 0

## Quick Checklist

- [ ] Database service exists and is running
- [ ] Worker service exists and is running
- [ ] Web service exists and is running
- [ ] `DATABASE_URL` set in **Web Service** (Internal Database URL)
- [ ] `DATABASE_URL` set in **Worker Service** (same value)
- [ ] Both services restarted after setting `DATABASE_URL`
- [ ] Worker logs show "✅ Saved tick #1"
- [ ] Web logs show "✅ Retrieved X ticks"
- [ ] Dashboard shows data (not "waiting for live data")

## Troubleshooting

### Issue: "Database is empty" on dashboard

**Check:**
1. `DATABASE_URL` is set in web service
2. `DATABASE_URL` is set in worker service (same value)
3. Worker service is running and collecting data
4. Wait 5-10 minutes for data to accumulate

**Solution:**
- Verify `DATABASE_URL` in both services
- Check worker logs for "✅ Saved tick" messages
- Restart both services if needed

### Issue: Web service can't connect to database

**Check:**
- `DATABASE_URL` is set correctly
- Using **Internal Database URL** (not External)
- Database service is running (not paused)

**Solution:**
- Re-add `DATABASE_URL` with Internal Database URL
- Restart web service

## Summary

**The only thing you need to do:**
1. Get Internal Database URL from your PostgreSQL service
2. Add `DATABASE_URL` environment variable to **Web Service**
3. Verify `DATABASE_URL` is also set in **Worker Service**
4. Wait 5-10 minutes for data to accumulate

That's it! The web service will automatically:
- Connect to the database
- Read data collected by the worker
- Display it on the dashboard

