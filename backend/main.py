from fastapi import FastAPI
from dotenv import load_dotenv

load_dotenv()

from routes.analyze import router as analyze_router
from routes.generate import router as generate_router
from routes.reward import router as reward_router

app = FastAPI(title="AI Learning Platform Backend (Gemini)")

app.include_router(analyze_router)
app.include_router(generate_router)
app.include_router(reward_router)

@app.get("/")
def root():
    return {"status": "Backend running with Gemini"}
