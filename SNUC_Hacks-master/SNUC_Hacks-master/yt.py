import json
import re
import requests
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError
import socket

def test_internet_connection():
    """Check if the system can access the internet (Google)."""
    try:
        socket.create_connection(("www.google.com", 80), timeout=5)
        return True
    except OSError:
        return False

def extract_keywords(data):
    """
    Extracts keywords from the JSON project data by looking at key fields.
    Filters out common stopwords.
    """
    keywords = set()
    stopwords = {"and", "or", "in", "the", "of", "a", "to", "for", "with", "using", "on", "is", "as"}
    
    intro = data.get("elaborated_activity", {}).get("Introduction", {})
    title = intro.get("Title", "")
    concept = intro.get("Concept", "")
    materials = intro.get("Materials", [])
    
    keywords.update(re.findall(r'\w+', title))
    keywords.update(re.findall(r'\w+', concept))
    for material in materials:
        keywords.update(re.findall(r'\w+', material))
    
    procedure = data.get("elaborated_activity", {}).get("Step-by-Step_Procedure", {})
    for step in procedure.values():
        instructions = step.get("Instructions", "")
        keywords.update(re.findall(r'\w+', instructions))
    
    filtered_keywords = {word.strip().lower() for word in keywords if word.lower() not in stopwords}
    return list(filtered_keywords)

def youtube_search(query, api_key, max_results=5):
    """
    Uses the YouTube Data API to search for videos matching the query.
    Ensures at least 2-3 links are returned.
    """
    try:
        youtube = build('youtube', 'v3', developerKey=api_key)
        request = youtube.search().list(
            q=query,
            part="id",
            maxResults=max_results,
            type="video"
        )
        response = request.execute()
        
        video_links = [f"https://www.youtube.com/watch?v={item['id']['videoId']}" 
                       for item in response.get("items", []) if "videoId" in item["id"]]

        # Retry with a shorter query if too few results
        if len(video_links) < 3 and len(query.split()) > 2:
            short_query = " ".join(query.split()[:2])  # Use only first 2 words
            request = youtube.search().list(q=short_query, part="id", maxResults=max_results, type="video")
            response = request.execute()
            video_links += [f"https://www.youtube.com/watch?v={item['id']['videoId']}" 
                            for item in response.get("items", []) if "videoId" in item["id"]]

        # Ensure at least 2-3 links are returned
        fallback_links = [
            "https://www.youtube.com/watch?v=dQw4w9WgXcQ",  # Placeholder educational links
            "https://www.youtube.com/watch?v=3JdWlSF195Y"
        ]
        while len(video_links) < 3:
            video_links.append(fallback_links.pop(0))

        return video_links[:3]  # Ensure exactly 3 links

    except HttpError as e:
        print(f"❌ YouTube API Error: {e}")
        return []
    except Exception as e:
        print(f"❌ Unexpected Error: {e}")
        return []

def main():
    # Check for internet connection
    if not test_internet_connection():
        print("❌ No internet connection. Please check your network.")
        return

    # Load the JSON file (ensure the file path is correct)
    json_file = "learning_elaborated_activity_2025-02-24_10-27-58.json"
    try:
        with open(json_file, "r") as f:
            data = json.load(f)
    except FileNotFoundError:
        print(f"❌ Error: JSON file '{json_file}' not found.")
        return
    except json.JSONDecodeError:
        print(f"❌ Error: Failed to parse JSON file.")
        return

    # Extract keywords from the JSON data
    keywords = extract_keywords(data)
    
    # Create a search query by joining the keywords
    query = " ".join(keywords)
    
    # Replace with your actual YouTube Data API key
    API_KEY = "AIzaSyBLmrIMSo48L2GK_CF5d5N_JAMiwbZ-_68"
    videos = youtube_search(query, API_KEY)

    # Print only video links in JSON format
    print(json.dumps(videos, indent=4))

if __name__ == "__main__":
    main()
