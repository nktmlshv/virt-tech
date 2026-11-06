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
  *Лабораторная работа № 2* \
])

#align(center + horizon, text(16pt)[
  Использование гипервизоров в Unix
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

= Введение
== Цель
Освоить установку и настройку виртуальных гипервизоров (Gnome Boxes, QEMU/KVM, Virtual Machine Manager) в Unix-системе. Изучить создание и управление виртуальными машинами через графические интерфейсы и командную строку, включая настройку сетевых подключений, работу со снимками состояния и использование утилит virsh и virt-install.
== Инструменты
- Host OS: Lubuntu 24.04.5 LTS
- Guest OS: Lubuntu 24.04.3 LTS
- KVM OS: Lubuntu 24.04.3 LTS
- Oracle Virtual Box: 7.2.20 (2026)

= Подготовка окружения
Добавим жёсткий диск (SATA) объемом 30 Gb в гостевую ОС Lubuntu.

#figure(
    image("img/sata_30gb.jpg", width: 100%),
    caption: "Жёсткий диск (SATA) объемом 30 Gb в гостевой ОС"
)

Настроим конфигурацию для вложенной виртуализации.

#figure(
    image("img/processor_config.jpg", width: 100%),
    caption: "Установки во вкладке Processor"
)

#figure(
    image("img/acceleration_config.jpg", width: 100%),
    caption: "Установки во вкладке Acceleration"
)

Создадим общую для основной и гостевой ОС папку под названием Soft.

#figure(
    image("img/shared_folder_soft.jpg", width: 100%),
    caption: "Добавленная папка Soft в разделе Shared folders"
)

Скачаем образ `lubuntu-24.04.3-desktop-amd64.iso`. Lubuntu 24.04.3 LTS имеет возможность запуска как в Live-режиме, так и в режиме с установкой.

= Gnome Boxes
== Настройка
Установим в гостевой ОС приложение Gnome Boxes.

#figure(
    image("img/apt_gnome_boxes.jpg", width: 100%),
    caption: "Приложение Gnome Boxes установлено"
)

Запустим Boxes и создадим виртуальную машину из скачанного образа.

#figure(
    image("img/create_vm_gb.jpg", width: 100%),
    caption: "Создание ВМ в Gnome Boxes"
)

Запустим ОС в режиме Live.

#figure(
    image("img/choose_live.jpg", width: 100%),
    caption: "Выбор режима Try Lubuntu при запуске ОС"
)

#figure(
    image("img/live_ubuntu_runs.jpg", width: 100%),
    caption: "Live Lubuntu запущена"
)

Boxes имеет достаточно скудный минимальный набор условий, которые можно варьировать для виртуальных машин, созданных в нем (CPU и память). Мониторинг недоступен. К счастью, это компенсируется тем, что под капотом используется совместимая с той же VMM XML формат конфигурации машины, поэтому, кстати, ВМ Boxes доступны и в VMM, где есть мониторинг и более богатая настройка машин.

== Удалённое подключение к серверу Helios по ssh

Создадим удалённое подключение к серверу Helios по ssh.

#figure(
    image("img/ssh_boxes.jpg", width: 100%),
    caption: "Подключение к серверу Helios по ssh"
)

== Удалённое подключение к компьютеру на MacOS по VNC

Проверим, что у вашей гостевой системы стоят настройки сетевого подключения Сетевой мост.

#figure(
    image("img/bridged_network.jpg", width: 100%),
    caption: "Настройки сетевого подключения"
)

Подключимся к удалённому компьютеру на MacOS по VNC.

Зададим нужные настройки VNC на MacOS. 

#figure(
    image("img/macos_vnc.png", width: 80%),
    caption: "Настройки VNC в разделе Remote Management на MacOS"
)

Выясним IP-адрес компьютера на MacOS.

#figure(
    image("img/macos_ip.png", width: 80%),
    caption: "IP-адрес компьютера на MacOS"
)

На Live Lubuntu скачаем VNC-клиент.
```bash
sudo apt update
sudo apt install tigervnc-viewer
```

Подключимся командой:
```bash
vncviewer 192.168.0.18:5900
```

#figure(
    image("img/connect_macos_password.jpg", width: 100%),
    caption: "Подключение к удалённому компьютеру на MacOS по VNC"
)

#figure(
    image("img/vnc_connect_manage.jpg", width: 100%),
    caption: "Управление удалённым компьютером на MacOS по VNC"
)

= QEMU
Установим QEMU и проверим поддержку KVM.

#figure(
    image("img/download_qemu.jpg", width: 100%),
    caption: "Установка QEMU и проверка поддержки KVM"
)

Создадим ВМ, выполнив команды:
```bash
mkdir VM
qemu-img create -f qcow2 ./VM/Lubuntu-24.img 10G
```

#figure(
    image("img/create_qemu_vm.jpg", width: 100%),
    caption: "Cоздание ВМ через QEMU"
)

Запустим ВМ.
```bash
qemu-system-x86_64 ./VM/Lubuntu-24.img
```

#figure(
    image("img/run_qemu_vm.jpg", width: 100%),
    caption: "Запуск ВМ через QEMU"
)

Запустим ВМ с установкой ОС.
```bash
qemu-system-x86_64 -m 1024 -cpu host -enable-kvm ./VM/Lubuntu-24.img -cdrom lubuntu-24.04.3-desktop-amd64.iso
```

#figure(
    image("img/run_qemu_vm_with_os.jpg", width: 100%),
    caption: "Запуск ВМ с установкой ОС через QEMU"
)

#figure(
    image("img/qemu_vm_runs.jpg", width: 100%),
    caption: "ВМ запущена через QEMU"
)

После установки системы создадим команду запуска гостевой ОС с помощью команды qemu с параметрами загрузки в полноэкранном режиме и установкой mac-адреса 17:10:20:22:20:09.

Поскольку mac-адрес – multicast, он не может быть присвоен сетевой карте, QEMU откажется запускаться, что можно увидеть на @run_with_mac.

```bash
qemu-system-x86_64 \
  -m 1024 \
  -hda ./VM/Lubuntu-24.img \
  -net nic,macaddr=17:10:20:22:20:09 \
  -net user \
  -full-screen
```

#figure(
    image("img/run_with_mac.jpg", width: 100%),
    caption: "Невозможно запустить qemu с multicast-mac адресом"
) <run_with_mac>

= Virtual Machine Manager
== Настройка

Установим пакеты приложений для нормальной работы Virtual Manager.

#figure(
    image("img/install_virt_manager.jpg", width: 100%),
    caption: "Установка пакетов приложений для нормальной работы Virtual Manager"
)

Добавим пользователя в группу `libvirt` и проверим, что libvirt запущен и работает.

#figure(
    image("img/add_user_libvirt.jpg", width: 100%),
    caption: "Добавление пользователя в группу и проверка работы libvirt"
)

Проверим правильность работы системы, все ли правильно установлено.

#figure(
    image("img/kvm_ok.jpg", width: 100%),
    caption: "Проверка на правильность работы системы"
)

После перезапуска найдем в приложениях программу Virtual Machine Manager.

#figure(
    image("img/vm_manager.jpg", width: 100%),
    caption: "Главное окно Virtual Machine Manager"
)

Создадим ВМ через VMM.

#figure(
    image("img/create_vm_vmm.jpg", width: 100%),
    caption: "Создание ВМ через VMM"
)

Запустим ВМ через VMM.

#figure(
    image("img/vm_vmm_runs.jpg", width: 100%),
    caption: "Запущенная через VMM ВМ"
)

Проверим настройки системы.

#figure(
    image("img/vmm_settings.jpg", width: 100%),
    caption: "Настройки ВМ в VMM"
)

Добавим диск на 10 МБ.

#figure(
    image("img/disk_10mb.jpg", width: 100%),
    caption: "Добавление диска размером 10 МБ"
)

#figure(
    image("img/added_disk_10mb.jpg", width: 100%),
    caption: "Диск размером 10 МБ добавлен"
)

Изучим свойства виртуальной машины созданной в VMM. В VMM можно настраивать большой спектр параметров ВМ, сопоставимый с тем, что предоставляет нам VirtualBox. Настраиваются ядра процессора, сеть, память, контроллеры внешних устройств, и даже можно настроить псевдослучайный генератор /dev/urandom.

== Снимки состояния системы

Создадим снимок начального состояния системы.

#figure(
    image("img/snapshot_before.jpg", width: 100%),
    caption: "Создание снимка виртуальной машины до установки приложения"
)

Теперь установим игру "Сапёр". 

#figure(
    image("img/download_mines.jpg", width: 100%),
    caption: "Приложение установлено"
)

Создадим снимок состояния системы с установленным приложением.

#figure(
    image("img/snapshot_after.jpg", width: 100%),
    caption: "Создание снимка виртуальной машины после установки приложения"
)

Теперь восстановим систему в первоначальное состояние.

#figure(
    image("img/to_snapshot_before.jpg", width: 100%),
    caption: "Восстановление системы из снимка до установки приложения"
)

Проверим работу снимков состояния. Как видно, после восстановления из снимка приложение "Сапёр" не установлено.

#figure(
    image("img/no_mines.jpg", width: 100%),
    caption: "Снимок new восстановлен успешно"
)

После восстановления снимка mines приложение "Сапёр" установлено.

#figure(
    image("img/to_mines.jpg", width: 100%),
    caption: "Восстановление снимка mines"
)

#figure(
    image("img/yes_mines.jpg", width: 100%),
    caption: "Снимок mines восстановлен успешно"
)

Основных сетевых настроек, которых можно устанавливать гостевой машине, две. Это сеть с NAT и сетевой мост. При этом сетевой мост есть 2 подтипов – прямой мост до сетевой карточки на хосте, и с виртуальным адаптером, который позволяет удобнее взаимодействовать с другими виртуальными хостами.

= virsh

Основные команды:
- Посмотреть запущенные виртуальные хосты (все доступные `--all`): `virsh list`
- Перезагрузить хост можно: `virsh reboot $VM_NAME`
- Остановить виртуальную машину: `virsh stop $VM_NAME`
- Выполнить halt: `virsh destroy $VM_NAME`
- Запуск: `virsh start $VM_NAME`
- Отключение: `virsh shutdown $VM_NAME`
- Добавить в автозапуск: `virsh autostart $VM_NAME`
- Клонировать систему, чтобы в будущем использовать ее как основу для других виртуальных ОС: `virt-clone --help`

#figure(
    image("img/virsh.jpg", width: 100%),
    caption: "Пример управления ВМ через virsh"
)

= virt-install

#figure(
    image("img/virt_install_install.jpg", width: 100%),
    caption: "Установка virt-install"
)

#figure(
    image("img/all_os.jpg", width: 100%),
    caption: "Часть списка доступных ОС из virt-install"
)

Отсортируем все ОС Windows и сохраним список.

#figure(
    image("img/win_sorted.jpg", width: 100%),
    caption: "Список ОС Windows"
)

Отсортируем все ОС Fedora и сохраним список.

#figure(
    image("img/fedora_sorted.jpg", width: 100%),
    caption: "Список ОС Fedora"
)

Добавим ВМ с помощью virt-install.
```bash
virt-install \
  --name MNA-p3412-virt-install \  # Имя ВМ
  --virt-type=kvm \  # Тип гипервизора KVM (аппаратная виртуализация)
  --memory 1024 \  # Объём оперативной памяти
  --vcpus=1 \  # Количество виртуальных CPU
  --os-variant=ubuntu24.04 \  # Идентификатор ОС для оптимальных настроек по умолчанию
  --hvm \  # Полная аппаратная виртуализация (hardware VM)
  --cdrom=lubuntu-24.04.3-desktop-amd64.iso \  # ISO-образ, подключаемый как CD-ROM для установки
  --network default,model=virtio \  # Подключаем ВМ к сети libvirt "default" (NAT), сетевая карта — virtio (быстрая паравиртуальная)
  --disk path=~/VM/lubuntu24.qcow2,size=5,bus=virtio,format=qcow2 \  # Диск: путь, размер 5 ГБ, шина virtio, формат qcow2
  --graphics vnc \  # Экран ВМ смотреть через VNC-клиент (окно на хосте не открывается)
  --noautoconsole  # Не открывать автоматически консоль после запуска
```

#figure(
    image("img/create_vm_virt_install.jpg", width: 100%),
    caption: "Процесс создания и запуска виртуальной машины через virt-install"
)

Запустить машину в фоновом режиме можно при помощи флага `wait`.

Чтобы подключиться к виртуальной машине по ssh, нужно сделать в системе автозапуск sshd, опционально сделать проброс портов из QEMU в 127.0.0.1, либо подключиться по сетевому адресу виртуальной машины, затем воспользоваться ssh-клиентом на целевой машине.

= Вывод

В лабораторной мы разобрали три способа работы с виртуалками на KVM: Gnome Boxes, QEMU/KVM с Virtual Machine Manager и `virt-install`. Настроили гостевую ОС, создали и покрутили виртуалки. Посмотрели снимки, сети и удалённый доступ.

Заодно сравнили подходы: 
- Gnome Boxes - быстро и просто через GUI, 
- VMM - когда нужен полный контроль над настройками, 
- `virsh`/`virt-install` - для автоматизации и серверов.
