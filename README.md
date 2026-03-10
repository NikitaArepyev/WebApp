# Telegram HR Bot + Mini App

Личный Telegram-бот для HR с компактным функционалом:
- приветственное сообщение `/start` с короткой самопрезентацией;
- кнопки соцсетей (`GitHub`, `LinkedIn`, `HH`);
- кнопка `Mini App` с развёрнутым резюме;
- scripted-ответы на несколько базовых сообщений.

## Стек

- Python 3.11+
- aiogram 3
- python-dotenv
- Mini App: HTML/CSS/JS

## Структура

```text
.
├── bot/
│   ├── __init__.py
│   ├── config.py
│   ├── handlers.py
│   ├── keyboards.py
│   ├── main.py
│   └── texts.py
├── miniapp/
│   ├── index.html
│   ├── script.js
│   └── styles.css
├── .env.example
├── .gitignore
├── requirements.txt
└── README.md
```

## Быстрый запуск

1. Создайте бота в BotFather и получите токен.
2. Скопируйте `.env.example` в `.env` и заполните значения.
3. Установите зависимости:

```bash
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
```

4. Запустите бота:

```bash
python -m bot.main
```

## Переменные окружения

- `BOT_TOKEN` — токен Telegram-бота.
- `MINIAPP_URL` — ссылка на опубликованный Mini App.
- `SOCIAL_GITHUB` — ссылка GitHub.
- `SOCIAL_LINKEDIN` — ссылка LinkedIn (сейчас TODO).
- `SOCIAL_HH` — ссылка HH (сейчас TODO).

## Команды и scripted-ответы

- `/start` — приветствие + кнопки.
- `/help` — список доступных фраз.
- Фразы: `о себе`, `стек`, `проекты`, `контакты`.

## Публикация Mini App на GitHub Pages

1. Загрузите проект в GitHub-репозиторий.
2. В `Settings -> Pages` выберите публикацию из ветки `main`.
3. Укажите папку `/ (root)` или перенесите файлы `miniapp/*` в отдельную ветку/папку для Pages.
4. Возьмите публичный URL и вставьте в `MINIAPP_URL`.

Пример URL:
`https://your-username.github.io/your-repo/miniapp/`

## Важно

- GitHub Pages хостит только Mini App (статические файлы).
- Python-бот должен работать отдельно: локально, на Render или Railway.
- Обновите TODO-ссылки LinkedIn и HH перед показом работодателю.

## Деплой бота на Render

- В проект добавлены `render.yaml` и `runtime.txt`.
- Render поднимет **Background Worker** (не Web Service), установит зависимости из `requirements.txt` и запустит `python -m bot.main`.
- Версия Python зафиксирована в `runtime.txt` (`python-3.12.8`), чтобы избежать проблем установки зависимостей на более новых версиях.
