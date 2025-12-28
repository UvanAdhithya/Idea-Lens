from googleapiclient.discovery import build
import os

def search_videos(query):
    youtube = build("youtube", "v3", developerKey=os.getenv("YOUTUBE_API_KEY"))
    req = youtube.search().list(q=query, part="id", maxResults=3, type="video")
    res = req.execute()
    return [f"https://youtube.com/watch?v={i['id']['videoId']}" for i in res["items"]]