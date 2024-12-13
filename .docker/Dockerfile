FROM ruby:3.1.3

# Устанавливаем необходимые зависимости
RUN apt-get update -qq && apt-get install -y \
    curl \
    gnupg \
    build-essential \
    libpq-dev \
    unzip \
    wget \
    apt-transport-https \
    ca-certificates

# Устанавливаем Google Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update -qq && apt-get install -y google-chrome-stable

# Установка Node.js (включая npm)
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs

# Устанавливаем конкретную версию Yarn (1.x)
RUN npm install -g yarn@1.22.19

# Устанавливаем ChromeDriver определенной версии
ENV CHROMEDRIVER_VERSION=114.0.5735.90
RUN curl -fsSL -o /tmp/chromedriver.zip "https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip" && \
    if [ -s /tmp/chromedriver.zip ]; then \
        unzip /tmp/chromedriver.zip -d /usr/local/bin && \
        chmod +x /usr/local/bin/chromedriver && \
        rm /tmp/chromedriver.zip; \
    else \
        echo "Не удалось загрузить chromedriver.zip"; exit 1; \
    fi

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем Gemfile и Gemfile.lock для установки Ruby-зависимостей
COPY Gemfile Gemfile.lock ./

# Устанавливаем Ruby-зависимости
RUN bundle install

# Копируем package.json и yarn.lock для установки Node.js зависимостей
COPY package.json yarn.lock ./

# Проверка версий Yarn и npm
RUN yarn --version && npm --version

# Устанавливаем Node.js зависимости через Yarn
RUN yarn install

# Копируем оставшиеся файлы проекта
COPY . .

# Предоставляем права на выполнение entrypoint.sh
COPY .docker/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# Устанавливаем entrypoint
ENTRYPOINT ["entrypoint.sh"]

# Порт для приложения
EXPOSE 3000
