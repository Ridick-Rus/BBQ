#!/bin/bash
set -e

# Если RAILS_ENV не задано, установим его значение по умолчанию (development)
: "${RAILS_ENV:=development}"

echo "Запуск в окружении: $RAILS_ENV"

# Устанавливаем зависимости, если их нет
bundle check || bundle install
yarn install --check-files

bundle exec rake assets:precompile

# Проверяем наличие файла базы данных и создаём при необходимости
if [[ ! -f tmp/pids/server.pid ]]; then
  echo "Создание базы данных..."
  bundle exec rake db:create
  bundle exec rake db:migrate
fi

# Удаляем старый PID сервера (если он есть)
rm -f tmp/pids/server.pid

# Запуск приложения
exec "$@"
