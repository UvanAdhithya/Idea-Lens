from fastapi import APIRouter
from pydantic import BaseModel
from typing import List

router = APIRouter(prefix="/generate", tags=["generate"])

class GenerateRequest(BaseModel):
    objects: List[str]

@router.post("/")
def generate(req: GenerateRequest):
    if not req.objects:
        return {"tasks": []}

    tasks = [
        {
            "title": f"Use {req.objects[0]} creatively",
            "difficulty": "easy",
            "points": 10
        },
        {
            "title": f"Build something using {', '.join(req.objects[:2])}",
            "difficulty": "medium",
            "points": 20
        },
        {
            "title": f"Create a project using all items: {', '.join(req.objects)}",
            "difficulty": "hard",
            "points": 40
        }
    ]

    return {"tasks": tasks}
