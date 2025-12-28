from datetime import datetime

from edushot import db
from edushot.common.classes import User
from edushot.common.exceptions import AccountNotFound, InvalidPassword
from edushot.secrets import get_secret

database = db.Database()


class AuthUser:
    def __init__(self, userid: int, password: str) -> None:
        """
        Authenticate a user
        Args:
            userid: int
            password: str
        Raises:
            AccountNotFound: if account is not found
            InvalidPassword: if password is incorrect
        """

        try:
            if database.authenticate(userid, password):
                self.User: User = database.get_User(userid)
                self._userid = self.User.userid
            else:
                raise InvalidPassword("Invalid password")
        except AccountNotFound as e:
            raise AccountNotFound(e)

    def refresh(self) -> User:
        self.User = database.get_User(self._userid)
        return self.User

    def get_points(self) -> int:
        """
        Refreshes the user object and returns the points
        Returns:
            int: points
        """
        return self.refresh().points

    def add_points(self, points: int) -> int:
        """
            Increment the points of the user
        Args:
            points: int
        Returns:
            int: new points
        """
        database.increment_points(self._userid, points)
        return self.refresh().points

    def change_password(self, new_password: str) -> None:
        """
        Change the password of the user
        Args:
            new_password: str
        """
        database.set_password(self._userid, new_password)

    def reauthenticate(self, password: str) -> bool:
        """
        Verify the password
        Args:
            password: str
        Raises:
            InvalidPassword: if password is incorrect
        """
        try:
            return database.authenticate(self._userid, password)
        except InvalidPassword:
            return False


class Administrator:
    def __init__(self, password: str) -> None:
        if not (env_pass := get_secret("ADMIN_PASSWORD")):
            raise InvalidPassword("Admin password not set")
        if str(password) == str(env_pass):
            return
        else:
            raise InvalidPassword("Admin password incorrect")

    def new_user(
        self, name: str, dob: datetime, interest: list[str], study: str, password: str
    ) -> int:

        return database.new(name, dob, interest, study, password)

    def set_password(self, userid: int, password: str) -> None:
        database.set_password(userid, password)
