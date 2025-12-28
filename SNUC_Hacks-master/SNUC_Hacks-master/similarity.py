import asyncio
import websockets
import cv2
import base64
import json
from datetime import datetime

# Gemini API Configuration
API_KEY = "AIzaSyBiyYtGBqjUKpIdet-CcDUOA1cNl-ZYOrw"  # Replace with your actual Gemini API key
WS_ENDPOINT = (
    f"wss://generativelanguage.googleapis.com/ws/google.ai.generativelanguage.v1alpha."
    f"GenerativeService.BidiGenerateContent?key={API_KEY}"
)

def load_project_json(filename):
    """Load the JSON file that contains the project description."""
    with open(filename, "r") as f:
        return json.load(f)

def extract_project_description(project_json):
    """
    Build a textual project description from the JSON.
    This combines key sections from the JSON to form a comprehensive description.
    """
    description_parts = []
    if "elaborated_activity" in project_json:
        ea = project_json["elaborated_activity"]
        # Introduction details
        if "Introduction" in ea:
            intro = ea["Introduction"]
            if "Title" in intro:
                description_parts.append("Title: " + intro["Title"])
            if "Concept" in intro:
                description_parts.append("Concept: " + intro["Concept"])
            if "Materials" in intro:
                description_parts.append("Materials: " + ", ".join(intro["Materials"]))
        # Setup instructions
        if "Setup_Instructions" in ea:
            si = ea["Setup_Instructions"]
            if "Preparation_Steps" in si:
                description_parts.append("Preparation Steps: " + ", ".join(si["Preparation_Steps"]))
            if "Safety_Considerations" in si:
                description_parts.append("Safety Considerations: " + ", ".join(si["Safety_Considerations"]))
        # Step-by-step procedure
        if "Step-by-Step_Procedure" in ea:
            stp = ea["Step-by-Step_Procedure"]
            for step_key, step_info in stp.items():
                if "Instructions" in step_info:
                    description_parts.append(f"{step_key} Instructions: " + step_info["Instructions"])
        # Additional sections (e.g., Teaching Guidelines, Assessment)
        if "Teaching_Guidelines" in ea:
            tg = ea["Teaching_Guidelines"]
            for key, value in tg.items():
                if isinstance(value, list):
                    description_parts.append(f"{key}: " + ", ".join(value))
                else:
                    description_parts.append(f"{key}: " + str(value))
        if "Assessment_and_Extensions" in ea:
            ae = ea["Assessment_and_Extensions"]
            for key, value in ae.items():
                if isinstance(value, list):
                    description_parts.append(f"{key}: " + ", ".join(value))
                elif isinstance(value, dict):
                    for subkey, subvalue in value.items():
                        description_parts.append(f"{subkey}: " + str(subvalue))
                else:
                    description_parts.append(f"{key}: " + str(value))
    return "\n".join(description_parts)

async def evaluate_project(image_path, project_json):
    """
    Reads the image and project JSON, then sends both to the Gemini API.
    The API is instructed to compare the project description with the image and return a score (0-100).
    """
    # Load and encode the image file
    img = cv2.imread(image_path)
    if img is None:
        print("Failed to load image. Check the image path.")
        return
    ret, buffer = cv2.imencode('.jpg', img)
    if not ret:
        print("Failed to encode image.")
        return
    # Get the base64-encoded string of the image (without a data URI prefix)
    frame_data = base64.b64encode(buffer).decode('utf-8')

    # Extract the project description text from the JSON file
    project_description = extract_project_description(project_json)
    print("Extracted Project Description:")
    print(project_description)

    async with websockets.connect(WS_ENDPOINT) as ws:
        # Setup message to instruct Gemini on the evaluation task.
        setup_message = {
            "setup": {
                "model": "models/gemini-2.0-flash-exp",
                "generationConfig": {"responseModalities": ["TEXT"]},
                "systemInstruction": {
                    "parts": [
                        {
                            "text": (
                                "You are provided with a project description and an image. "
                                "Evaluate if the image accurately represents the project described. "
                                "Return only a single numerical score between 0 and 100, where 100 indicates a perfect match."
                            )
                        }
                    ]
                }
            }
        }
        await ws.send(json.dumps(setup_message))
        setup_resp = await ws.recv()
        print("Gemini setup response:", setup_resp)

        # Send the project description as plain text and the image as inline data.
        client_message = {
            "clientContent": {
                "turns": [
                    {
                        "parts": [
                            {"text": project_description},
                            {"inlineData": {"mimeType": "image/jpeg", "data": frame_data}}
                        ],
                        "role": "user"
                    }
                ],
                "turnComplete": True
            }
        }
        await ws.send(json.dumps(client_message))
        print("Sent project description and image for evaluation, waiting for response...")
        try:
            response = await asyncio.wait_for(ws.recv(), timeout=20)
            resp_json = json.loads(response)
            if (
                "serverContent" in resp_json and 
                "modelTurn" in resp_json["serverContent"] and 
                "parts" in resp_json["serverContent"]["modelTurn"]
            ):
                parts = resp_json["serverContent"]["modelTurn"]["parts"]
                full_text = " ".join(part.get("text", "").strip() for part in parts)
                print("Evaluation Response:", full_text)
                try:
                    score = float(full_text.strip())
                    print("Project Score:", score)
                except ValueError:
                    print("Could not parse a numerical score from the response.")
            else:
                print("Unexpected response format:", response)
        except Exception as e:
            print("Error receiving response:", e)

def main():
    # Load the project JSON file (ensure the JSON file is in the same directory or provide its full path)
    project_json_filename = "learning_elaborated_activity_2025-02-24_10-27-58.json"
    project_json = load_project_json(project_json_filename)
    print("Project JSON loaded successfully.")

    # Prompt the user to enter the path to an image file
    image_path = input("Enter the path to the image file: ").strip()
    asyncio.run(evaluate_project(image_path, project_json))

if __name__ == "__main__":
    main()
