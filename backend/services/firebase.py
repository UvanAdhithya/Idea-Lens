import os
import firebase_admin
from firebase_admin import credentials, firestore

cred_path = os.getenv("FIREBASE_CREDENTIALS")
cred = credentials.Certificate(cred_path)

if not firebase_admin._apps:
    firebase_admin.initialize_app(cred)

db = firestore.client()

def add_points(user_id, points):
    ref = db.collection("users").document(user_id)
    ref.set({"points": firestore.Increment(points)}, merge=True)