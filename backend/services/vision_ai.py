import os
import base64
import io
from PIL import Image
from google import genai

client = genai.Client(api_key=os.getenv("GEMINI_API_KEY"))

async def analyze_image(file):
    try:
        # Read uploaded image
        image_bytes = await file.read()

        # Convert to JPEG (safe format)
        image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
        buffer = io.BytesIO()
        image.save(buffer, format="JPEG")
        jpeg_bytes = buffer.getvalue()

        image_b64 = base64.b64encode(jpeg_bytes).decode()

        response = client.models.generate_content(
            model="models/gemini-2.5-flash",
            contents=[
                {
                    "role": "user",
                    "parts": [
                        {"text": "List all objects visible in this image as bullet points."},
                        {
                            "inline_data": {
                                "mime_type": "image/jpeg",
                                "data": image_b64
                            }
                        }
                    ]
                }
            ]
        )

        text = response.text or ""
        return [
            line.strip("- ").lower()
            for line in text.splitlines()
            if line.strip()
        ]

    except Exception as e:
        return [f"error: {str(e)}"]
