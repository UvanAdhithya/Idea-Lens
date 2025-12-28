import asyncio
import websockets
import cv2
import base64
import json
from datetime import datetime

# IP Webcam Stream URL (Replace with correct credentials)
IP_CAMERA_URL = "http://10.31.23.88:8080/video"

# Gemini API Configuration
API_KEY = "AIzaSyBiyYtGBqjUKpIdet-CcDUOA1cNl-ZYOrw"  # Replace with your actual Gemini API key
WS_ENDPOINT = (
    f"wss://generativelanguage.googleapis.com/ws/google.ai.generativelanguage.v1alpha."
    f"GenerativeService.BidiGenerateContent?key={API_KEY}"
)

async def get_objects_from_frame(ws, frame_data, frame_label, timeout=10):
    """
    Sends the given frame (in base64 JPEG format) to the Gemini API,
    waits for the response, and returns the bullet list of objects.
    """
    client_message = {
        "clientContent": {
            "turns": [
                {
                    "parts": [
                        {"inlineData": {"mimeType": "image/jpeg", "data": frame_data}}
                    ],
                    "role": "user"
                }
            ],
            "turnComplete": True
        }
    }
    await ws.send(json.dumps(client_message))
    print(f"[{frame_label}] Frame sent, waiting for response...")
    try:
        response = await asyncio.wait_for(ws.recv(), timeout=timeout)
        resp_json = json.loads(response)
        if (
            "serverContent" in resp_json and 
            "modelTurn" in resp_json["serverContent"] and 
            "parts" in resp_json["serverContent"]["modelTurn"]
        ):
            parts = resp_json["serverContent"]["modelTurn"]["parts"]
            full_text = " ".join(part.get("text", "").strip() for part in parts)
            # Split text into bullet items (removing any leading bullet characters)
            bullets = [line.strip(" *") for line in full_text.split("\n") if line.strip(" *")]
            return bullets
        else:
            print(f"[{frame_label}] Unexpected response format:", response)
            return None
    except Exception as e:
        print(f"[{frame_label}] Error receiving response: {e}")
        return None

async def stream_until_response():
    # This set will store all unique objects detected
    union_objects = set()
    last_frame_data = None
    frame_index = 1

    async with websockets.connect(WS_ENDPOINT) as ws:
        # STEP 1: Send the setup message using the supported Gemini model.
        setup_message = {
            "setup": {
                "model": "models/gemini-2.0-flash-exp",  # Supported model for this API version
                "generationConfig": {"responseModalities": ["TEXT"]},
                "systemInstruction": {
                    "parts": [
                        {
                            "text": (
                                "Analyze the image and provide a bullet point list of all objects you see. "
                                "Only output the list. "
                                "Analyze the image and list every object you can identify—even small or partially obscured items. "
                                "Include both prominent and subtle objects in your list."
                            )
                        }
                    ]
                }
            }
        }
        await ws.send(json.dumps(setup_message))
        setup_resp = await ws.recv()
        print("Setup response:", setup_resp)

        # Open the IP Webcam feed
        cap = cv2.VideoCapture(IP_CAMERA_URL)
        if not cap.isOpened():
            print("Could not open IP Webcam stream")
            return

        try:
            # Capture frames until we get a valid response.
            while True:
                ret, frame = cap.read()
                if not ret:
                    print("Failed to capture frame from IP camera")
                    continue

                # Encode the frame as JPEG and convert to base64.
                ret, buffer = cv2.imencode('.jpg', frame)
                if not ret:
                    continue
                frame_data = base64.b64encode(buffer).decode('utf-8')
                last_frame_data = frame_data  # store the latest frame data

                # Try to get objects from the current frame.
                bullets = await get_objects_from_frame(ws, frame_data, f"Frame {frame_index}")
                if bullets and len(bullets) > 0:
                    print(f"[Frame {frame_index}] Valid response received: {bullets}")
                    union_objects.update(bullets)
                    break  # exit loop once we get a valid response
                else:
                    print(f"[Frame {frame_index}] Returned an empty or invalid list. Continuing...")
                
                # Optionally, display the frame locally.
                cv2.imshow("Live Video - Press 'q' to quit", frame)
                if cv2.waitKey(1) & 0xFF == ord('q'):
                    break

                frame_index += 1
                # Wait 5 seconds before capturing the next frame.
                await asyncio.sleep(5)

        except KeyboardInterrupt:
            print("Streaming interrupted by user.")
        finally:
            cap.release()
            cv2.destroyAllWindows()

        # Once a valid response is received, send additional requests (e.g., 3 more) using the same frame.
        additional_requests = 3  # You can adjust this number as needed.
        for i in range(1, additional_requests + 1):
            bullets = await get_objects_from_frame(ws, last_frame_data, f"Additional {i}")
            if bullets:
                print(f"[Additional {i}] Response received: {bullets}")
                union_objects.update(bullets)
            else:
                print(f"[Additional {i}] Received an empty or invalid response.")
            frame_index += 1
            # A small delay between additional requests.
            await asyncio.sleep(2)

    # Prepare the final union of detected objects.
    if union_objects:
        final_result = {"frame": frame_index, "objects": list(union_objects)}
        timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
        filename = f"detected_objects_{timestamp}.json"
        with open(filename, "w") as f:
            json.dump({"timestamp": timestamp, "result": final_result}, f, indent=2)
        print(f"Final union response saved to {filename}")
        print("Combined list of detected objects:", list(union_objects))
    else:
        print("No valid responses were received.")

if __name__ == "__main__":
    asyncio.run(stream_until_response())
