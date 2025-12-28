from edushot.common.classes import User
from edushot.common.exceptions import AccountNotFound

from tinydb import Query, TinyDB
from tinydb.operations import add
from tinydb.table import Document

from datetime import datetime


class Database:
    def __init__(self) -> None:
        self._auth_db = TinyDB("auth.json")
        self._user_db = TinyDB("users.json")
        query = Query()

    def query(self, userid: int) -> dict[str, int | str]:
        userid = int(userid)

        if result := self._user_db.get(doc_id=userid):
            return dict(result)  # type: ignore

        else:
            raise AccountNotFound(f"Account id not found: {userid}")

    def new(
        self, name: str, dob: datetime, interest: list[str], study: str, password: str
    ) -> int:
        """
        Create a new account
        Args:
            name: str
            dob: datetime
            interest: list[str]
            study: str
        Returns:
            int: account id
        """

        # TODO: add points history
        data = {
            "name": str(name),
            "dob": dob.isoformat(),
            "interest": interest,
            "study": str(study),
            "points": 0,
        }

        userid = int(self._user_db.insert(data))

        self._auth_db.insert({"userid": userid, "password": password})

        return userid

    def get_User(self, userid: int) -> User:
        details = self.query(userid)
        return User(
            userid=int(userid),
            name=str(details["name"]),
            dob=datetime.fromisoformat(str(details["dob"])),
            interest=list(details["interest"]),  # type: ignore
            study=str(details["study"]),
            points=int(details["points"]),
        )

    def authenticate(self, userid: int, password: str) -> bool:
        """
        Authenticate a user
        Args:
            userid: int
            password: str
        Returns:
            bool: authenticated
        """
        userid = int(userid)
        result = self._auth_db.get(Query().userid == userid)
        if not result:

            raise AccountNotFound(f"Account not found: {userid}")

        return result["password"] == password  # type: ignore

    def update(self, userid: int, key: str, value) -> None:
        """
        Arbitrary update function
        Args:
            userid: int
            key: str
            value: any
        Returns:
            None
        """
        userid = int(userid)
        self._user_db.update(Document({key: value}, doc_id=userid))

    def get_name(self, userid: int) -> str:
        """
        Get the name of a user
        Args:
        userid: int
        Returns:
        str: name
        """
        return str(self.query(userid)["name"])

    def get_dob(self, userid: int) -> datetime:
        """
        Get the date of birth of a user
        Args:
            userid: int
        Returns:
            datetime: date of birth
        """

        return datetime.fromisoformat(str(self.query(userid)["dob"]))

    def add_interest(self, userid: int, interest: str) -> list[str]:
        """
        Add an interest to a user
        Args:
            userid: int
            interest: str
        Returns:
        list[str]: interests
        """

        interests = self.get_interest(userid)
        interests.append(interest)
        interests = list(set(interests))
        self.update(userid, "interest", interests)
        return interests

    def remove_interest(self, userid: int, interest: str) -> list[str]:
        """
        Remove an interest from a user
        Args:
            userid: int
            interest: str
        Returns:
            list[str]: interests
        """
        interests = self.get_interest(userid)
        interests.remove(interest)
        self.update(userid, "interest", interests)
        return interests

    def get_interest(self, userid: int) -> list[str]:
        """
        Get the interests of a user
        Args:
            userid: int
        Returns:
            list[str]: interests
        """
        return list(self.query(userid)["interest"])  # type: ignore

    def get_study(self, userid: int) -> str:
        """
        Get the study of a user
        Args:
            userid: int
        Returns:
            str: study
        """
        return str(self.query(userid)["study"])

    def get_points(self, userid: int) -> int:
        """
        Get the points of a user
        Args:
            userid: int
        Returns:
            int: points
        """
        return int(self.query(userid)["points"])

    def increment_points(self, userid: int, points: int) -> int:
        """
        Increment the points of a user
        Args:
            userid: int
            points: int
        Returns:
            int: new points
        """
        self._user_db.update(add("points", points), doc_ids=[userid])
        return self.get_points(userid)

    def set_password(self, userid: int, password: str) -> None:
        self._auth_db.update({"password": password}, Query().userid == userid)
