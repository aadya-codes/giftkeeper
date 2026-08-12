from fastapi import FastAPI
from pydantic import BaseModel
from dotenv import load_dotenv
import os
import httpx

load_dotenv()

app = FastAPI()

GROQ_API_KEY = os.getenv("GROQ_API_KEY")


class GiftRequest(BaseModel):
    prompt: str


@app.get("/")
def home():
    return {"message": "GiftKeeper backend is running!"}


@app.post("/generate-gifts")
async def generate_gifts(request: GiftRequest):

    headers = {
        "Authorization": f"Bearer {GROQ_API_KEY}",
        "Content-Type": "application/json",
    }

    body = {
        "model": "llama-3.1-8b-instant",
        "messages": [
            {
                "role": "user",
                "content": request.prompt,
            }
        ],
    }

    async with httpx.AsyncClient() as client:
        response = await client.post(
            "https://api.groq.com/openai/v1/chat/completions",
            headers=headers,
            json=body,
        )

    if response.status_code != 200:
        return {
            "error": f"Groq error: {response.status_code}",
            "details": response.text,
        }

    data = response.json()
    ideas = data["choices"][0]["message"]["content"]

    return {"ideas": ideas}