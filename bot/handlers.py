from aiogram import F, Router
from aiogram.filters import Command, CommandStart
from aiogram.types import Message

from bot.config import Settings
from bot.keyboards import build_main_keyboard
from bot.texts import HELP_TEXT, SCRIPTED_REPLIES, START_TEXT

router = Router()


@router.message(CommandStart())
async def start_handler(message: Message, settings: Settings) -> None:
    await message.answer(START_TEXT, reply_markup=build_main_keyboard(settings))


@router.message(Command("help"))
async def help_handler(message: Message) -> None:
    await message.answer(HELP_TEXT)


@router.message(F.text)
async def scripted_reply_handler(message: Message) -> None:
    user_text = message.text.strip().lower()
    if user_text in SCRIPTED_REPLIES:
        await message.answer(SCRIPTED_REPLIES[user_text])
        return

    await message.answer(
        "Я пока отвечаю только на базовые запросы. Напишите: о себе, стек, проекты или контакты."
    )
