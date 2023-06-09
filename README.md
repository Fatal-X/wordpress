# Описание к репозиторию

В данном репозитории располагается проект по реализации системы управления содержимым сайта Wordpress на базе Web-сервера nginx с использованием базы данных MySQL. 

# Структура
Проект состоит из следующих составляющих:
- [ ] docker-compose.yml: это ядро проекта, конфигурационный файл контейнеров, по которому формируется инфраструктура
- [ ] .env: файл с переменными окружения, из которого берутся все данные, которые могут быть в будущем изменены.
- [ ] nginx: каталог с настройками web-сервера. Внутри него находится файл непосредственно с конфигурацией виртуального хоста, файл с записями логинов и паролей для HTTP-авторизации и Dockerfile, который необходим для сборки web-сервера (иначе говоря, предыдущие 2 файла не попадут в назначенное место без этого файла)
- [ ] .gitignore и .dockerignore - файлы, которые определяют исключения, которые не будут затронуты деятельностью git и docker соответственно.
- [ ] creds - файл с логинами и паролями от окружения

# Подготовительные процедуры
Для запуска проекта пользователю понадобятся пакеты Git, Docker и Docker-compose

Порядок работы проверялся на ОС Ubuntu 20.04.4

## Установка Docker и Docker-compose

Чтобы установить Docker на Ubuntu, выполним подготовительные действия. Для начала, обновим состав установочных пакетов, чтобы иметь представление об их актуальных версиях:
```
sudo apt update
```
Предварительно установим набор пакетов, необходимый для доступа к репозиториям по протоколу HTTPS:

apt-transport-https — активирует передачу файлов и данных через https;

ca-сertificates — активирует проверку сертификаты безопасности;

curl — утилита для обращения к веб-ресурсам;

software-properties-common — активирует возможность использования скриптов для управления программным обеспечением.
```
sudo apt install apt-transport-https ca-certificates curl software-properties-common
```
Далее добавим в систему GPG-ключ для работы с официальным репозиторием Docker:
```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```
Теперь добавим репозиторий Docker в локальный список репозиториев:
```
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```
Повторно обновим данные о пакетах операционной системы:
```
sudo apt update
```
Приступаем к установке пакета Docker.
```
sudo apt install docker-ce -y
```
После завершения установки запустим демон Docker и добавим его в автозагрузку:
```
sudo systemctl start docker
sudo systemctl enable docker
```
Установим docker-compose
```
sudo apt install docker-compose
```
Добавим пользователям возможность работать с докером
```
newgrp docker
sudo usermod -aG docker ${USER}
sudo chmod 666 /var/run/docker.sock
```
Проверяем работоспособность пакета, выполнив команду вывода версии:
```
docker–compose –-version
```

## Установка Git
Устанавливаем пакет git
```
sudo apt-get install git
```
Далее следует склонировать репозиторий с проектом к себе на компьютер:
```
git clone https://gitlab.com/devops2383/wp.git
```
Где url - ссылка, взятая в репозитории. Нажимаем кнопку clone и выбираем ссылку под "Clone with HTTPS"

# Запуск
Чтобы запустить скаченный проект, потребуется файл pass, в котором будет располагаться ключ к расшифрованию переменных окружения.
Данный файл необходимо поместить в корень проекта, после чего после чего выполнить команду:
```
make
```
После ввода данной команды система начнёт скачивать необходимые образы, если они отсутствуют, после чего будет выполнено расшифрование переменных окружения и проект будет собран.
Для удобства имеет смысл сделать так, чтобы наше устройство искало сайт не в интернете, а у себя же. Это делается следующим образом:
- Открываем файл hosts 
```
sudo nano /etc/hosts
```
- Добавляем в конец следующие строки
```
127.0.0.1	alexwp.com
127.0.0.1	www.alexwp.com
```

Теперь в браузере при вводе в адресную строку "www.alexwp.com" запрос будет направляться на локальный веб-сервер. Это убирает необходимость ввода ip-адреса.

Все данные, необходимые для доступа к базе данных, а также пароль для расшифрования переменных окружения необходимо получать в индивидуальном порядке у Александра Кузьмина.
