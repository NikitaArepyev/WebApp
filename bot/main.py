import asyncio
import logging

from aiogram import Bot, Dispatcher

from bot.config import load_settings
from bot.handlers import router


async def main() -> None:
    settings = load_settings()

    bot = Bot(token=settings.bot_token)
    dp = Dispatcher()

    dp["settings"] = settings
    dp.include_router(router)

    await dp.start_polling(bot)


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    asyncio.run(main())
