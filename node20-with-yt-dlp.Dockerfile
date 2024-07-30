FROM node:20

RUN apt-get update \
    && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    ffmpeg

RUN python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install yt-dlp

RUN npm cache clean --force \
    && npm install npx \
    && npx playwright install \
    && npx playwright install-deps

ENV PATH="/opt/venv/bin:$PATH"

EXPOSE 5000

CMD sh -c "node index.js"

# define workdir WORKDIR /usr/src/bot
# you must map valume to 
# override into docker compose command npm install && node index.js
