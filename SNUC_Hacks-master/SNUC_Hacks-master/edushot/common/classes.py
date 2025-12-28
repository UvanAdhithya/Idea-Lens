from dataclasses import dataclass
from datetime import datetime


@dataclass
class User:
    userid: int
    name: str
    dob: datetime
    interest: list[str]
    study: str
    points: int

    def __init__(
        self,
        userid: int,
        name: str,
        dob: datetime,
        interest: list[str],
        study: str,
        points,
    ):
        self.userid = userid
        self.name = str(name)
        self.dob = dob
        self.interest = interest
        self.study = str(study)
        self.points = int(points)
