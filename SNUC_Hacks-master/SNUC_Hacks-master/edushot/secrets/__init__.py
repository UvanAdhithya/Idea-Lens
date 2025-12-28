from dotenv import load_dotenv

load_dotenv()


def get_secret(key: str, default: str | None = None) -> str:
    """
    Safely retrieve secret from environment variables.

    Args:
        key: Environment variable name
        default: Optional default value if env var is not set

    Returns:
        str: The secret value or default
    """
    import os

    value = os.environ.get(key, default)
    if value is None:
        raise ValueError(f"Required secret {key} is not set in environment")

    return value
