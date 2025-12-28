from fastapi import APIRouter, UploadFile
from services.vision_ai import analyze_image

router = APIRouter(prefix="/analyze", tags=["Vision"])

@router.post("/")
async def analyze(file: UploadFile):
    objects = await analyze_image(file)
    return {"objects": objects}
