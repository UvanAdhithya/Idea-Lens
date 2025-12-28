import os
from google import genai

client = genai.Client(api_key=os.getenv("GEMINI_API_KEY"))

def generate_tasks(objects):
    prompt = f"""
Given these objects: {objects}

Generate 3 tasks (easy, medium, hard).
Return ONLY valid JSON.
"""

    response = client.models.generate_content(
        model="gemini-1.5-flash",
        contents=prompt
    )

    return response.text
