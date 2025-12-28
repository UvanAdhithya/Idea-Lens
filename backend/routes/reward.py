from fastapi import APIRouter
from services.firebase import add_points
from utils.scoring import DIFFICULTY_POINTS

router = APIRouter(prefix="/reward", tags=["Gamification"])

@router.post("/")
def reward(user_id: str, difficulty: str):
    points = DIFFICULTY_POINTS[difficulty]
    add_points(user_id, points)
    return {"user_id": user_id, "points_added": points}
