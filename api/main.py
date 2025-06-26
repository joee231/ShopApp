# D:\api\main.py
import uvicorn

if __name__ == "__main__":
    # Uvicorn will handle importing 'app' from 'app.main' directly.
    uvicorn.run("app.main:app", host="192.168.1.3", port=41654, reload=True)