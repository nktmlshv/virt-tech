#show figure.where(kind: image): set figure(supplement: [Рис.])
#show figure.where(kind: table): set figure(supplement: [Табл.])
#show figure.where(kind: table): set figure.caption(position: top)
#set text(14pt, lang: "ru")
#show raw: set text(size: 9pt)
#show raw.where(block: true): block.with(fill: luma(245), inset: 8pt, radius: 3pt, width: 100%)
#show figure: set block(breakable: true)

#let placeholder(body) = rect(
  width: 100%,
  height: 6cm,
  stroke: (dash: "dashed"),
)[#align(center + horizon)[#body]]

#let layer(title, body) = rect(width: 100%, inset: 8pt, stroke: 0.8pt, radius: 3pt)[
  #align(center)[*#title* \ #body]
]

#let down-arrow = align(center)[#text(16pt)[↓]]

#align(center, text(16pt)[
  *Федеральное государственное автономное образовательное учреждение высшего образования «Национальный исследовательский университет ИТМО»*
  \
  \
  *Факультет программной инженерии и компьютерной техники*
])

#align(center + horizon, text(16pt)[
  Дисциплина \ "Технологии виртуализации"
])

#v(2cm)

#align(center + horizon, text(16pt)[
  *Лабораторная работа №3* \
])

#align(center + horizon, text(16pt)[
  Знакомство с Docker
])


#v(4cm)

#align(left, text(16pt)[
  #table(
    columns: 2,
    stroke: none,
    align: left,
    [*Выполнил:*], [Малышев Никита Александрович],
    [*Группа:*], [P3412],
    [*Проверил:*], [Адмакин Максим Александрович],
  )
])

#align(center + bottom, text(16pt)[
  Санкт-Петербург\
  #datetime.today().year() год
])

#pagebreak()

#set heading(numbering: "1.")
#outline(
  title: [Содержание]
)

#set page(numbering: "1")

#pagebreak()

#set par(justify: true)

= Цель
Изучить основы работы с Docker, основные команды, создание и запуск контейнеров, запуск и управление нескольких контейнеров, регистрацию на DockerHub.

= Установка Docker и VirtualBox

#figure(
    image("img/install-docker-vbox.png", width: 80%),
    caption: "Docker и VirtualBox установлены"
)

= Запуск тестового контейнера

Попробуем запустить тестовый контейнер `hello-malyshev`.

#figure(
    image("img/image-doesnt-exist.png", width: 100%),
    caption: "Невозможно найти образ"
)

Мы получаем ошибку, так как образа hello-malyshev не существует как
локально, так и в удаленном репозитории образов. Исправим это, создав образ
для hello-malyshev.

= Контейнер с Nginx и пользовательской страницей

Создан каталог home/www/html, в нём размещён HTML-файл `index.html`.
Написан `Dockerfile` на базе образа `nginx:latest`, который пробрасывает порт
8080 и копирует страницу.

#figure(
    image("img/index-html-dockerfile.png", width: 80%),
    caption: "Содержимое Dockerfile и HTML-страницы"
)

Образ собран и запущен с монтированием тома.
```bash
docker build -t my-nginx home/www/html
docker run -d -p 8080:80 -v /Users/admin/ws/docs/lab3/home/www/html:/usr/share/nginx/html:ro --name my-webserver my-nginx
open http://localhost:8080
```

#figure(
    image("img/docker-build-run.png", width: 100%),
    caption: "Сборка и запуск образа"
)

#figure(
    image("img/browser-runs.png", width: 100%),
    caption: "Результат работы веб-сервера в браузере"
)

= Контейнер с MariaDB
Запущен контейнер `mariadb` с монтированием тома `home/DB` и пробросом
порта 3306.

```bash
docker run -d --name my-mariadb \
  -v /Users/admin/ws/docs/lab3/home/db:/var/lib/mysql \
  -e MARIADB_ROOT_PASSWORD=admin \
  -p 3306:3306 \
  mariadb:12.1.1-rc
```

#figure(
    image("img/run-mariadb.png", width: 100%),
    caption: "Запуск mariadb"
)

Через `docker exec` выполнено подключение к СУБД и создана база данных
с именем `malyshev`

```bash
docker exec -it my-mariadb mariadb -u root -padmin -e "CREATE DATABASE malyshev; SHOW DATABASES;"
```

#figure(
    image("img/docker-exec.png", width: 100%),
    caption: "Создание базы данных в MariaDB через терминал контейнера"
)

В итоге база данных сохранилась как отдельная папка внутри хостовой
директории `home/DB`, которая смонтирована внутрь контейнера.

#figure(
    image("img/ls-la-home-db.png", width: 80%),
    caption: "Содержимое home/DB"
)

= Контейнер с NextCloud

Запущен официальный образ `nextcloud` с пробросом порта 8088 и
монтированием каталога `home/www/NextCloud`.

```bash
docker run -d --name my-nextcloud \
  -v /Users/admin/ws/docs/lab3/home/www/NextCloud:/var/www/html \
  -p 8088:80 \
  nextcloud:latest
```

#figure(
    image("img/create-nextcloud.png", width: 80%),
    caption: "Создание контейнера с NextCloud"
)

Логин и пароль от NextCloud – admin:admin.

#figure(
    image("img/nextcloud-settings.png", width: 60%),
    caption: "Настройка NextCloud"
)

Через веб-интерфейс зарегистрированы два пользователя: студент
Н. А. Малышев и преподаватель М. А. Адмакин.

#figure(
    image("img/create-new-acc.png", width: 60%),
    caption: "Создание пользователя"
)

#figure(
    image("img/nextcloud-users.png", width: 100%),
    caption: "Раздел Accounts в NextCloud"
)

= Контейнер с phpvirtualbox

Сначала запустим `vboxwebsrv`.

```bash
vboxwebsrv -H 0.0.0.0 -A null -b
```

#figure(
    image("img/vboxwebserv-run.png", width: 100%),
    caption: "Запуск веб-сервиса VirtualBox"
)

Запустим phpVirtualBox.
```bash
docker run --name vbox_http --restart=unless-stopped \
  -p 8089:80 \
  -e ID_HOSTPORT=host.docker.internal:18083 \
  -e ID_NAME=MyVBoxServer \
  -e ID_USER=admin \
  -e ID_PW=admin \
  -e CONF_noAuth=true \
  -d joweisberg/phpvirtualbox:latest
```

#figure(
    image("img/create-phpvirtualbox.png", width: 80%),
    caption: "Создание контейнера с phpVirtualBox"
)

Логин:пароль от phpVirtualBox – `admin:admin`.

#figure(
    image("img/phpvirtualbox-login-page.png", width: 60%),
    caption: "Начальный экран phpVirtualBox"
)

Можно увидеть те же виртуальные машины, что и в VirtualBox.

#figure(
    image("img/phpvb-vms.png", width: 80%),
    caption: "Список ВМ в phpVirtualBox"
)

#figure(
    image("img/vb-vms.png", width: 80%),
    caption: "Список ВМ в VirtualBox"
)

= Настройка окружения с помощью Docker Compose

Создан файл `docker-compose.yml`, описывающий три сервиса: `db`
(MariaDB), `app` (NextCloud), `web` (Nginx).

```yaml
services:
  db:
    image: mariadb:12.1.1-rc
    container_name: nextcloud-mariadb
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: admin
      MYSQL_DATABASE: nextcloud
      MYSQL_USER: nextcloud_user
      MYSQL_PASSWORD: nextcloud_pass
    volumes:
      - /Users/admin/ws/docs/lab3/home/db:/var/lib/mysql
    networks:
      - nextcloud-network

  app:
    image: nextcloud:latest
    container_name: nextcloud-app
    restart: unless-stopped
    ports:
      - "2022:80"
    environment:
      MYSQL_HOST: db
      MYSQL_DATABASE: nextcloud
      MYSQL_USER: nextcloud_user
      MYSQL_PASSWORD: nextcloud_pass
      NEXTCLOUD_ADMIN_USER: admin
      NEXTCLOUD_ADMIN_PASSWORD: admin
      NEXTCLOUD_TRUSTED_DOMAINS: localhost
    volumes:
      - /Users/admin/ws/docs/lab3/home/nextcloud:/var/www/html
    depends_on:
      - db
    networks:
      - nextcloud-network

  web:
    image: nginx:alpine
    container_name: nginx-webserver
    restart: unless-stopped
    ports:
      - "8080:80"
    volumes:
      - /Users/admin/ws/docs/lab3/home/www/html:/usr/share/nginx/html:ro
    depends_on:
      - app
    networks:
      - nextcloud-network

networks:
  nextcloud-network:
    driver: bridge
```

Запустим сервисы и проверим их статус.
```bash
docker compose up -d
docker compose ps
```

#figure(
    image("img/docker-compose-runs.png", width: 100%),
    caption: "Запуск сервисов и проверка их статуса через Docker Compose"
)

Страницу NextCloud можно найти по адресу http://localhost:2022.

#figure(
    image("img/nextcloud-2222.png", width: 80%),
    caption: "Доступный через порт 2022 NextCloud"
)

Судя по содержимому нового контейнера `mariadb` — инициализация
прошла успешно.

#figure(
    image("img/docker-compose-mariadb.png", width: 80%),
    caption: "Таблицы NextCloud в MariaDB"
)

= Регистрация на Docker Hub

Выполнена регистрация на https://hub.docker.com.

#figure(
    image("img/docker-hub-login.png", width: 80%),
    caption: "Мой профиль на Docker Hub"
)

= Публикация образа на Docker Hub

Образ `my-nginx` помечен тегом и отправлен в публичный репозиторий.

#figure(
    image("img/docker-hub-push.png", width: 100%),
    caption: "Push образа в Docker Hub"
)

#figure(
    image("img/docker-hub-img-pushed.png", width: 60%),
    caption: "Образ, опубликованный в публичном репозитории Docker Hub"
)

= Запуск приложения из Docker Hub

Запущен публичный образ игры 2048. Приложение доступно
в браузере по порту 8082.

```bash
docker run -p 8082:80 cnrock/2048
```

#figure(
    image("img/run2048.png", width: 100%),
    caption: "Стороннее приложение из Docker Hub, запущенное в браузере"
)

= Основные команды Docker

В ходе выполнения лабораторной работы были применены следующие команды Docker для управления контейнерами, образами и многоконтейнерными приложениями.

Управление контейнерами:

- `docker create` — создаёт контейнер из образа без его запуска.
- `docker start` — запускает ранее созданный или остановленный контейнер.
- `docker run` — создаёт и сразу запускает новый контейнер из образа.
- `docker ps` — отображает список только запущенных контейнеров.
- `docker ps -a` — отображает все контейнеры, включая остановленные.
- `docker inspect` — выводит подробную информацию о контейнере (сетевые настройки, тома, переменные окружения и др.).
- `docker logs` — показывает журнал (логи) работы контейнера.
- `docker stop` — корректно останавливает контейнер, отправляя сигнал завершения (SIGTERM, затем при необходимости SIGKILL).
- `docker kill` — немедленно завершает работу контейнера принудительно (SIGKILL).
- `docker rm` — удаляет остановленный контейнер из системы.
- `docker exec` — выполняет указанную команду внутри уже запущенного контейнера.

Управление образами:

- `docker build` — собирает образ на основе инструкций из файла Dockerfile.
- `docker pull` — загружает образ из реестра (например, с Docker Hub).
- `docker push` — отправляет локальный образ в удалённый реестр.
- `docker images` (или `docker image ls`) — отображает список всех локальных образов.
- `docker image inspect` — выводит детальную информацию о метаданных и конфигурации образа.
- `docker rmi` (или `docker image rm`) — удаляет указанный образ из локального хранилища.
- `docker login` — выполняет аутентификацию в Docker Hub или другом реестре контейнеров.

Команды Docker Compose:

- `docker compose up` — создаёт и запускает все сервисы, описанные в файле docker-compose.yml.
- `docker compose down` — останавливает и удаляет контейнеры, сети и тома, созданные через docker-compose up.
- `docker compose ps` — отображает статус всех сервисов в проекте.
- `docker compose logs` — выводит журналы всех запущенных сервисов.
- `docker compose build` — пересобирает образы, указанные в конфигурации Compose.

Прочие команды:

- `docker system df` — отображает использование дискового пространства Docker (образы, контейнеры, тома).
- `docker volume ls` — перечисляет все тома, созданные Docker.
- `docker network ls` — перечисляет все сети, управляемые Docker.
- `docker version` — показывает версии Docker Engine и других компонентов.
- `docker info` — выводит подробную информацию о конфигурации и состоянии Docker-окружения.

= Работа с Portainer

== Запуск

Добавим в `docker-compose.yaml` конфигурацию сервиса Portainer.

```yaml
  portainer:
    image: portainer/portainer-ce:lts
    container_name: portainer
    restart: always
    ports:
      - "9443:9443"
      - "8000:8000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data
    networks:
      - nextcloud-network

volumes:
  portainer_data:
    name: portainer_data
```

Запустим.

#figure(
    image("img/portainer-dashboard.png", width: 80%),
    caption: "Дашборд в Portainer"
)

== Возможности Portainer

=== Мониторинг

- *Обзор состояния* — дашборд с количеством контейнеров, образов, томов и сетей; статус каждого контейнера (running/stopped/error).
- *Логи в реальном времени* — просмотр stdout/stderr любого контейнера без `docker logs`.
- *Статистика ресурсов* — потребление CPU, RAM, сети и диска по контейнерам.
- *События Docker* — журнал событий движка (старт, стоп, ошибки, изменения).
- *Health-статусы* — отображение состояния healthcheck-проверок сервисов.

=== Администрирование

- *Управление контейнерами* — создание, запуск, остановка, перезапуск, удаление, просмотр деталей, выполнение команд внутри (`exec`).
- *Управление образами* — сборка из Dockerfile, pull, push, удаление, просмотр слоёв и метаданных.
- *Управление томами и сетями* — создание, удаление, просмотр подключений.
- *Стеки (Compose)* — развёртывание и редактирование `docker-compose.yml` прямо из UI, обновление стека.
- *Шаблоны приложений* — быстрое развёртывание популярных сервисов в пару кликов.
- *Права и роли* — пользователи, команды, разграничение доступа к окружениям (RBAC).
- *Мультиокружения* — управление несколькими Docker-хостами (локальными и удалёнными) из одного интерфейса.

=== Преимущества

- *Единая точка управления* — вместо десятков команд `docker` — визуальный интерфейс.
- *Снижение порога входа* — не нужно помнить синтаксис CLI для типовых операций.
- *Наглядность* — статусы, логи и метрики видны сразу, без ручного опроса.
- *Безопасность* — RBAC и централизованный доступ вместо прямого доступа к `docker.sock`.
- *Удалённое администрирование* — управление хостами через веб-браузер, в т.ч. Edge-агенты.
- *Воспроизводимость* — стеки Compose хранятся и версионируются в UI.
- *Бесплатность CE* — Community Edition покрывает большинство задач без лицензии.

= Вывод

В ходе лабораторной работы я освоил Docker на практике: собрал собственный образ Nginx с HTML-страницей через `Dockerfile`, запустил MariaDB и создал базу через `docker exec`, поднял NextCloud с пользователями, связал phpVirtualBox с локальным `vboxwebsrv`. Описал три сервиса в `docker-compose.yml` и запустил всё одной командой, а затем опубликовал образ `my-nginx` на Docker Hub и запустил стороннее приложение оттуда же.

Главный вывод: Docker упрощает развёртывание — `compose up` заменяет ручную установку, тома сохраняют данные между перезапусками, Docker Hub позволяет делиться образами, а Portainer даёт наглядный GUI поверх CLI. 