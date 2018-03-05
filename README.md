# Fake IM Service (Test Application)

#### Описание

Проект создан в рамках выполнения тестового задания от компании 404 Group. Требуется создать прототип микросервиса, имитирующий отправку сообщений в API IM-сервисов (без фактического взаимодействия с ними и отправки сообщений)

##### Ruby version
```
ruby 2.3.1
```

##### Rails version
```
Rails 5.1.5
```

### Первый запуск
```
gem install bundler
bundle install
cp config/database.yml.example config/database.yml
cp config/secrets.yml.example config/secrets.yml
```

Далее необходимо сконфигурировать файлы `config/database.yml` и `config/secrets.yml` по аналогии с приведенным образцом.

Затем подготавливаем базу данных:

```
rails db:create
rails db:migrate
```

Запуск сервера

```
rails s
```

Запуск обработчика отложенных задач (использован gem resque):
```
QUEUE=im_fake_service* bundle exec rake environment resque:work
```

Запуск обработчика задачи по расписанию:
```
rake environment resque:scheduler
```

### Перед началом работы

Необходимо через rails-консоль (`rails c`) создать пользователя (или нескольких)

```
User.create(email: 'example@example.com', password: '12345678')
```

### Тесты
```
rspec
```

### Документация API

Описание существующих экшенов доступно по адресу http://localhost:3000/apipie
