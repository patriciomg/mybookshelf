import sys
import uvicorn
from fastapi import FastAPI

version = f"{sys.version_info.major}.{sys.version_info.minor}"

app = FastAPI()

@app.get("/")
async def root():
    message = f"Hello world! From FastAPI running on Uvicorn with Gunicorn. Using Python {version}"
    return {"message": message}

if __name__ == "__main__":
    print('HERE  at main.py')
    # uvicorn.run(app, host="0.0.0.0", port=8000, reload=True, log_level="debug")
