from aiogram.types import InlineKeyboardButton, InlineKeyboardMarkup, WebAppInfo

from bot.config import Settings


def build_main_keyboard(settings: Settings) -> InlineKeyboardMarkup:
    return InlineKeyboardMarkup(
        inline_keyboard=[
            [
                InlineKeyboardButton(text="GitHub", url=settings.social_github),
                InlineKeyboardButton(text="LinkedIn", url=settings.social_linkedin),
                InlineKeyboardButton(text="HH", url=settings.social_hh),
            ],
            [
                InlineKeyboardButton(
                    text="Mini App",
                    web_app=WebAppInfo(url=settings.miniapp_url),
                )
            ],
        ]
    )
