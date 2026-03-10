import os
from dataclasses import dataclass

from dotenv import load_dotenv


@dataclass
class Settings:
    bot_token: str
    miniapp_url: str
    social_github: str
    social_linkedin: str
    social_hh: str


def load_settings() -> Settings:
    load_dotenv()

    bot_token = os.getenv("BOT_TOKEN", "")
    if not bot_token:
        raise ValueError("BOT_TOKEN is not set. Add it to .env")

    return Settings(
        bot_token=bot_token,
        miniapp_url=os.getenv("MINIAPP_URL", "https://example.com"),
        social_github=os.getenv("SOCIAL_GITHUB", "https://github.com/Nikitaarepe192"),
        social_linkedin=os.getenv("SOCIAL_LINKEDIN", "TODO_ADD_LINKEDIN_URL"),
        social_hh=os.getenv("SOCIAL_HH", "TODO_ADD_HH_URL"),
    )
