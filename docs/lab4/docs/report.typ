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
  *Лабораторная работа №4* \
])

#align(center + horizon, text(16pt)[
  Знакомство с LXC и LDC
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

= Основы работы с LXC/LXD

Установить LXD.
```bash
sudo snap install lxd
```

#figure(
  image("img/install-lxd.png", width: 80%),
  caption: "Установка LXD"
)

Проверить работу LXD.
```bash
lxc list
lxc --version
```

#figure(
  image("img/check-lxd.png", width: 80%),
  caption: "Проверка работы LXD"
)

Выполнить инициализацию LXD командой `lxd init` со следующими параметрами: 
- Кластеринг -- нет
- Название хранилица -- My_MNA_fs
- Размер -- 5GB
- MAAS -- Нет
- Настроить сеть -- Сетевой мост
- Включить -- NAT

#figure(
  image("img/init-lxd.png", width: 100%),
  caption: "Инициализация LXD"
)

Получить конфигурации компонентов LXD.
```bash
lxc profile list
lxc network list
lxc storage list
```

#figure(
  image("img/config-lxd.png", width: 100%),
  caption: "Конфигурация компонентов LXD"
)

Создать три контейнера с названиями: Apache, Chrome, MC.
```bash
lxc init ubuntu:26.04 Apache --storage My_MNA_fs
lxc init ubuntu:26.04 Chrome --storage My_MNA_fs
lxc init ubuntu:26.04 MC --storage My_MNA_fs
```

#figure(
  image("img/create-containers.png", width: 80%),
  caption: "Создание контейнеров"
)

Запустить контейнеры Apache и MC и получим список.
```bash
lxc start Apache
lxc start MC
lxc list
```

#figure(
  image("img/run-containers.png", width: 80%),
  caption: "Запуск контейнеров и получение списка"
)

Вывести список, содержащий только IP-адреса контейнеров, и список, содержащий только остановленные контейнеры.
```bash
lxc list --columns=n6
lxc list status=STOPPED
```

#figure(
  image("img/lxc-lists.png", width: 80%),
  caption: "Получение списка с применением фильтра"
)

Удалить контейнер MC.
```bash
lxc stop MC
lxc delete MC
```

#figure(
  image("img/delete-mc.png", width: 100%),
  caption: "Удаление контейнера"
)

Получить список, содержащий только тип контейнеров.
```bash
lxc list -c nt
```

#figure(
  image("img/container-types.png", width: 50%),
  caption: "Список, содержащий только тип контейнеров"
)

= Конфигурация и выполнение команд LXC/LXD

Создать и запустить 3 контейнера: Big, Medium, Small. 

```bash
lxc launch ubuntu:26.04 Big --storage My_MNA_fs
lxc launch ubuntu:26.04 Medium --storage My_MNA_fs
lxc launch ubuntu:26.04 Small --storage My_MNA_fs
```

#figure(
  image("img/run-containers-sized.png", width: 80%),
  caption: "Создание и запуск контейнеров"
)

Получить конфигурацию каждого контейнера. 

```bash
user@ubuntu:~$ lxc info Big
lxc info Medium
lxc info Small
Name: Big
Status: RUNNING
Type: container
Architecture: aarch64
PID: 16709
Created: 2026/11/09 14:07 UTC
Last Used: 2026/11/09 14:07 UTC

Resources:
  Processes: 26
  Disk usage:
    root: 3.52MiB
  Disk total:
    root: 0B
  CPU usage:
    CPU usage (in seconds): 5
  Memory usage:
    Memory (current): 115.11MiB
  Network usage:
    eth0:
      Type: broadcast
      State: UP
      Host interface: veth93715321
      MAC address: 00:16:3e:b4:10:9e
      MTU: 1500
      Bytes received: 20.12kB
      Bytes sent: 6.75kB
      Packets received: 116
      Packets sent: 64
      IP addresses:
        inet:  10.86.74.211/24 (global)
        inet6: fd42:6b61:c94b:5584:216:3eff:feb4:109e/64 (global)
        inet6: fe80::216:3eff:feb4:109e/64 (link)
    lo:
      Type: loopback
      State: UP
      MTU: 65536
      Bytes received: 2.20kB
      Bytes sent: 2.20kB
      Packets received: 24
      Packets sent: 24
      IP addresses:
        inet:  127.0.0.1/8 (local)
        inet6: ::1/128 (local)
Name: Medium
Status: RUNNING
Type: container
Architecture: aarch64
PID: 17019
Created: 2026/11/09 14:07 UTC
Last Used: 2026/11/09 14:07 UTC

Resources:
  Processes: 26
  Disk usage:
    root: 3.52MiB
  Disk total:
    root: 0B
  CPU usage:
    CPU usage (in seconds): 5
  Memory usage:
    Memory (current): 105.69MiB
  Network usage:
    eth0:
      Type: broadcast
      State: UP
      Host interface: veth40384586
      MAC address: 00:16:3e:d4:e9:7e
      MTU: 1500
      Bytes received: 19.39kB
      Bytes sent: 6.89kB
      Packets received: 112
      Packets sent: 66
      IP addresses:
        inet:  10.86.74.228/24 (global)
        inet6: fd42:6b61:c94b:5584:216:3eff:fed4:e97e/64 (global)
        inet6: fe80::216:3eff:fed4:e97e/64 (link)
    lo:
      Type: loopback
      State: UP
      MTU: 65536
      Bytes received: 2.22kB
      Bytes sent: 2.22kB
      Packets received: 24
      Packets sent: 24
      IP addresses:
        inet:  127.0.0.1/8 (local)
        inet6: ::1/128 (local)
Name: Small
Status: RUNNING
Type: container
Architecture: aarch64
PID: 17617
Created: 2026/11/09 14:07 UTC
Last Used: 2026/11/09 14:07 UTC

Resources:
  Processes: 26
  Disk usage:
    root: 3.52MiB
  Disk total:
    root: 0B
  CPU usage:
    CPU usage (in seconds): 5
  Memory usage:
    Memory (current): 128.07MiB
  Network usage:
    eth0:
      Type: broadcast
      State: UP
      Host interface: veth140b3969
      MAC address: 00:16:3e:6a:b8:26
      MTU: 1500
      Bytes received: 17.97kB
      Bytes sent: 6.36kB
      Packets received: 99
      Packets sent: 61
      IP addresses:
        inet:  10.86.74.150/24 (global)
        inet6: fd42:6b61:c94b:5584:216:3eff:fe6a:b826/64 (global)
        inet6: fe80::216:3eff:fe6a:b826/64 (link)
    lo:
      Type: loopback
      State: UP
      MTU: 65536
      Bytes received: 2.21kB
      Bytes sent: 2.21kB
      Packets received: 24
      Packets sent: 24
      IP addresses:
        inet:  127.0.0.1/8 (local)
        inet6: ::1/128 (local)
```

#figure(
  image("img/config-lxc-sized.png", width: 80%),
  caption: "Получение конфигурации контейнера"
)

Остановить контейнер Big.
```bash
lxc stop Big
```

Изменить ограничение на использование CPU на 2 и RAM на 300 MiB для контейнера Big.
```bash
lxc config set Big limits.cpu 2
lxc config set Big limits.memory 300MiB
```

#figure(
  image("img/config-big.png", width: 100%),
  caption: "Конфигурация контейнера Big после изменений"
)

Запустить контейнер Big. 
```bash
lxc start Big
```

Отправить утилиту free в контейнер Big.
```bash
lxc exec Big -- free -h
```

#figure(
  image("img/exec-big.png", width: 80%),
  caption: "Отправка утилиты free в контейнер Big"
)

Открыть терминал и запустить на нем утилиту top в контейнере Medium.
```bash
lxc exec Medium -- top
```
#figure(
  image("img/top-medium.png", width: 80%),
  caption: "Запуск утилиты top"
)

Открыть еще один терминал, и изменить в нем значение ограничения использования RAM для контейнера на 200 MiB. 
```bash
lxc config set Medium limits.memory 200MiB
```

#figure(
  image("img/set-mem-medium.png", width: 100%),
  caption: "Изменение ограничений памяти в другом терминале"
)

Значение свободной памяти поменялось на лету после применения изменений.

#figure(
  image("img/changed-top-medium.png", width: 80%),
  caption: "Изменение ограничений памяти в top"
)

Проделать то же самое для контейнера Small.

Сначала изменить значение ограничения RAM на 150 MiB.
```bash
lxc config set Small limits.memory 150MiB
```

#figure(
  image("img/small-mem-150.png", width: 100%),
  caption: "Изменение ограничений памяти на 150 MiB для Small"
)

После чего установить 800 MiB. 
```bash
lxc config set Small limits.memory 800MiB
```

#figure(
  image("img/small-mem-800.png", width: 100%),
  caption: "Изменение ограничений памяти на 800 MiB для Small"
)

Изменить описание для контейнера Small, после чего выполнить команду, предоставляющую описания контейнеров. 

```bash
lxc config set Small user.description "N. A. Malyshev"
lxc config get Small user.description
```

#figure(
  image("img/change-description.png", width: 80%),
  caption: "Изменение описания контейнера"
)

Остановить контейнер Small. 
```bash
lxc stop Small
```

Изменить название контейнера Small на BigBig. 
```bash
lxc rename Small BigBig
```

Вывести список контейнеров. 
```bash
lxc list
```

#figure(
  image("img/rename.png", width: 100%),
  caption: "Изменение названия контейнера"
)

= Практическое применение LXD

Создать и запустить 3 контейнера: Apache, NextCloud, MC.

```bash
lxc launch ubuntu:26.04 Apache --storage My_MNA_fs
lxc launch ubuntu:26.04 NextCloud --storage My_MNA_fs
lxc launch ubuntu:26.04 MC --storage My_MNA_fs
```

Получить список контейнеров. 
```bash
lxc list
```

#figure(
  image("img/create-containers-again.png", width: 100%),
  caption: "Создание контейнеров"
)

Установить для всех контейнеров ограничение RAM = 500 MiB. 
```bash
lxc config set Apache limits.memory 500MiB
lxc config set NextCloud limits.memory 500MiB
lxc config set MC limits.memory 500MiB
```

#figure(
  image("img/set-mem-500.png", width: 60%),
  caption: "Установка ограничений"
)

Установить веб-сервер Apache2 на контейнере Apache. 
```bash
lxc exec Apache -- bash 
apt update
apt install apache2 -y
```

#figure(
  image("img/install-apache2.png", width: 80%),
  caption: "Установка Apache2"
)

Создать страницу со своим ФИО.
```bash
lxc exec Apache -- sh -c 'echo "<h1>N. A. Malyshev</h1>" > /var/www/html/index.html'
```

Узнать IP-адрес.
```bash
lxc list Apache -c 4
```

Запустить Apache2.

```bash
lxc exec Apache -- systemctl start apache2
lxc exec Apache -- systemctl status apache2
```

#figure(
  image("img/run-apache2.png", width: 100%),
  caption: "Запуск Apache2"
)

#figure(
  image("img/page.png", width: 80%),
  caption: "Страница, размещенная на Apache2"
)

Прокинуть порты для контейнера NextCloud. Пробрасываем порт 8080 на хосте на порт 80 в контейнере NextCloud.
```bash
lxc config device add NextCloud web proxy listen=tcp:0.0.0.0:8080 connect=tcp:127.0.0.1:80
```

Установить NextCloud.

```bash
lxc exec NextCloud -- bash
apt update && apt upgrade -y
snap install nextcloud
```

#figure(
  image("img/proxy.png", width: 100%),
  caption: "NextCloud доступен с локального хоста"
)

Установить MidnightCommander на контейнере MC.
```bash
lxc exec MC -- apt update
lxc exec MC -- apt install -y mc
```

Запустить в графическом режиме.
```bash
lxc exec -t MC -- mc
```

#figure(
  image("img/mc.png", width: 80%),
  caption: "Midnight Commander в контейнере"
)

Запустить и настроить веб-интерфейс lxd-ui (https://canonical.com/lxd/docs/latest/howto/access_ui/). 

По умолчанию LXD принимает подключения только через локальный Unix-сокет, поэтому веб-интерфейс недоступен. Нужно настроить его на прослушивание сетевого адреса (обычно порт 8443).
```bash
lxc config set core.https_address :8443
```

Для аутентификации сгенерировать ссылку первичного доступа и пройти по ней.

```bash
lxd init --ui-initial-access-link
```

#figure(
  image("img/auth.png", width: 100%),
  caption: "Запуск и настройка веб-интерфейса lxd-ui"
)

Создать контейнер при помощи веб-интерфейса.

#figure(
  image("img/create-lxd-ui.png", width: 80%),
  caption: "Создание контейнера через lxd-ui"
)

#figure(
  image("img/lxd-ui-list.png", width: 100%),
  caption: "Список контейнеров в lxd-ui"
)

Какие возможности LXD веб-интерфейс не покрывает? 

- *Нет полного покрытия CLI* — часть функций доступна только в командной строке.
- *Нет истории метрик* — только текущие значения, без графиков за период.
- *Нет управления хостом* — нельзя выключить/перезагрузить хост, смотреть логи ОС, обновления, SMART/температуру.
- *Нет сложной сети* — продвинутые VLAN/мосты требуют CLI.
- *Нет своей аутентификации* — только mTLS-сертификат или OIDC, управления пользователями нет.

= Вывод
В ходе лабораторной разобрались с LXD от установки до веб-интерфейса: инициализировали хранилище и сеть, создавали контейнеры через `lxc init`/`lxc launch`, запускали и останавливали их, фильтровали вывод `lxc list`, меняли на лету лимиты CPU и RAM (и видели в `top`, как свободная память пересчитывается без перезапуска), переименовывали и удаляли контейнеры.

На практике подняли Apache с самодельной страницей, пробросили порт в NextCloud через proxy-устройство, поставили Midnight Commander и потыкали lxd-ui. Главный вывод: CLI LXD — это основной инструмент, а веб-интерфейс удобен для базового управления, но не заменяет консоль (нет истории метрик, управления хостом, сложной сети и своей аутентификации).