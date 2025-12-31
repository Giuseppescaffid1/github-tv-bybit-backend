# 🏗️ Architecture: How Worker and Web Service Communicate

## Overview

The **background worker** and **web service** don't directly talk to each other. Instead, they communicate through a **shared PostgreSQL database**. This is a **database-backed architecture**.

## Architecture Diagram

```
┌─────────────────────┐
│  Bybit WebSocket    │
│  (External API)     │
└──────────┬──────────┘
           │
           │ Real-time orderbook data
           ▼
┌─────────────────────┐
│  Background Worker   │  ← Runs continuously
│  (data_collector.py) │     Collects data every second
└──────────┬──────────┘
           │
           │ Saves ticks to database
           ▼
┌─────────────────────┐
│  PostgreSQL Database │  ← Shared storage
│  (orderbook_ticks)   │     Both services access this
└──────────┬──────────┘
           │
           │ Reads data from database
           ▼
┌─────────────────────┐
│  Web Service        │  ← Serves dashboard
│  (app.py)           │     Reads data with small lag
└─────────────────────┘
           │
           │ HTTP requests
           ▼
┌─────────────────────┐
│  User's Browser      │
│  (Dashboard)         │
└─────────────────────┘
```

## How It Works

### 1. Background Worker (Data Collector)

**File**: `data_collector.py`

**What it does:**
1. Connects to Bybit WebSocket
2. Receives orderbook updates every second
3. **Writes** data to PostgreSQL database using `save_tick()`
4. Runs continuously in the background

**Code flow:**
```python
# In data_collector.py
from database import save_tick

# When WebSocket receives data:
tick = {
    "ts": datetime.utcnow(),
    "symbol": "ETHUSDT",
    "best_bid_price": 2500.5,
    "best_ask_price": 2500.6,
    # ... other fields
}

save_tick(tick)  # ← Saves to database
```

**Database operation**: **WRITE** (INSERT)

### 2. Web Service (Dashboard)

**File**: `app.py`

**What it does:**
1. Receives HTTP requests from users
2. **Reads** data from PostgreSQL database using `get_ticks_as_dataframe()`
3. Processes data (calculates signals, trades, etc.)
4. Sends HTML/JSON to user's browser

**Code flow:**
```python
# In app.py
from database import get_ticks_as_dataframe, get_session, OrderbookTick

# When dashboard needs data:
df = get_ticks_as_dataframe(n=2000, symbol='ETHUSDT', minutes_back=10)
# ← Reads from database

# Process and display data
# ... create charts, calculate signals, etc.
```

**Database operation**: **READ** (SELECT)

### 3. PostgreSQL Database

**Shared storage** that both services use:

- **Table**: `orderbook_ticks`
- **Columns**: `id`, `ts`, `symbol`, `best_bid_price`, `best_ask_price`, etc.
- **Access**: Both services use the same `DATABASE_URL`

## Communication Flow

### Step-by-Step:

1. **Worker collects data**:
   ```
   Bybit WebSocket → Worker → Database (INSERT)
   ```

2. **Web service reads data**:
   ```
   User Browser → Web Service → Database (SELECT) → User Browser
   ```

3. **No direct communication**:
   - Worker doesn't call web service
   - Web service doesn't call worker
   - They only interact through the database

## Data Flow Timeline

```
Time  | Worker                    | Database              | Web Service
------|---------------------------|-----------------------|------------------
00:00 | Connects to WebSocket     | Empty                 | Waiting
00:01 | Receives tick #1          | INSERT tick #1        | Waiting
00:02 | Receives tick #2          | INSERT tick #2        | User visits site
00:02 | ...                       | ...                   | SELECT * FROM ...
00:02 | ...                       | ...                   | Shows data to user
00:03 | Receives tick #3          | INSERT tick #3        | User refreshes
00:03 | ...                       | ...                   | SELECT * FROM ...
00:03 | ...                       | ...                   | Shows updated data
```

## Benefits of This Architecture

### ✅ **Separation of Concerns**
- Worker focuses on data collection
- Web service focuses on serving users
- Each can be scaled independently

### ✅ **Reliability**
- If web service crashes, worker keeps collecting
- If worker crashes, web service still shows historical data
- Database persists data even if services restart

### ✅ **Scalability**
- Can run multiple web service instances (all read from same DB)
- Can run multiple workers (all write to same DB)
- Database handles concurrent access

### ✅ **Simplicity**
- No complex message queues needed
- No direct service-to-service communication
- Standard database operations (INSERT/SELECT)

## Database as Communication Channel

The database acts as a **message queue** and **data store**:

1. **Worker writes** → Database stores → **Web service reads**
2. **No direct connection** between worker and web service
3. **Database URL** (`DATABASE_URL`) is the only shared configuration

## Configuration

Both services need the same `DATABASE_URL`:

```bash
# Worker Service Environment
DATABASE_URL=postgresql://user:pass@host:port/db

# Web Service Environment  
DATABASE_URL=postgresql://user:pass@host:port/db  # Same value!
```

## Data Lag

- **Real-time**: Worker receives data from Bybit immediately
- **Database write**: ~1ms (very fast)
- **Database read**: ~1-5ms (very fast)
- **Total lag**: Typically 1-5 seconds from Bybit to dashboard

This small lag is acceptable for a dashboard and provides better reliability than direct WebSocket connections.

## Summary

**They don't directly talk** - they use the database as a shared storage:

- **Worker**: Writes data to database (producer)
- **Database**: Stores data (shared storage)
- **Web Service**: Reads data from database (consumer)

This is a classic **producer-consumer pattern** using a database as the message broker.

