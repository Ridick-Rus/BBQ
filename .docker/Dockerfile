# .docker/Dockerfile
FROM ruby:3.1.3

# Устанавливаем необходимые зависимости для Node.js, Yarn и PostgreSQL
RUN apt-get update -qq && apt-get install -y \
    curl \
    build-essential \
    libpq-dev

# Установка Node.js (включает npm)
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs

# Устанавливаем конкретную версию Yarn (1.x)
RUN npm install -g yarn@1.22.19

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем Gemfile и Gemfile.lock для установки Ruby-зависимостей
COPY Gemfile Gemfile.lock ./

# Устанавливаем Ruby зависимости
RUN bundle install

# Копируем package.json и yarn.lock для установки Node.js зависимостей
COPY package.json yarn.lock ./

# Проверка версий Yarn и npm
RUN yarn --version && npm --version

# Устанавливаем Node.js зависимости через Yarn
RUN yarn install

# Копируем оставшиеся файлы проекта
COPY . .

# Предоставляем права на запуск entrypoint.sh
COPY .docker/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# Устанавливаем entrypoint
ENTRYPOINT ["entrypoint.sh"]

# Порт для приложения
EXPOSE 3000
