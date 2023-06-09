# Разворачивание контейнера Jenkins
Для того, чтобы развернуть контейнер Jenkins, используем следующую команду:
```
docker run -d --name jenkins -p 8080:8080 -p 50000:50000 -v $(pwd)/build:/home/ jenkins/jenkins:lts
```
# Веб-интерфейс
Для получения доступа к веб-морде требуется узнать IP-адрес машины, на которой расположен контейнер.
В данном случае установим пакет net-tools для этой цели:
```
sudo apt update && apt install net-tools -y
```
После этого вводим команду для отображения текущего IP:
```
ifconfig | grep inet
```
В результате получаем IP-адрес в виде
```
inet 192.168.1.215  netmask 255.255.255.0  broadcast 192.168.1.255
```
В данном случае наш IP - **192.168.1.215**

Открываем браузер и вводим полученный IP с указанием номера порта (в данном случае 8080)
```
192.168.1.215:8080
```
При первом входе сервис запросит пароль администратора. Чтобы его получить, выполняем ряд команд в консоли ubuntu:
```
docker exec -it jenkins /bin/bash
cat /var/jenkins_home/secrets/initialAdminPassword
```
В результате получим пароль следующего вида:
```
b576455deee54453a60bb3fbceee4b6a
```
Вводим его в строке веб-интерфейса и проваливаемся в админку

# Настройка агента
В меню Dashboard есть виджет "состояние сборщиков". На него можно нажать, после чего высветится список агентов (они же сборщики)

Нажимаем в меню слева **новый узел**

Пишем название узла (чтобы потом самим не забыть), ставим переключатель **Permanent Agent**

Далее нужно заполнить некоторые обязательные поля:
1) Корень удалённой ФС - директория сервера, в которую агент будет деплоить проект, вводится в формате:
```
/home/ubuntu/alexwp
```
2) Способ запуска - соответственно, метод авторизации агента на удалённом сервере (иначе он просто не сможет подключиться).
Выбираем **Launch agents via SSH**

В поле **Host** указываем IP-адрес удалённого сервера.

Далее в поле **Credentials** нужно нажать кнопку **Add**. В открывшемся меню изменяем поле **Kind** на **SSH Username with private key**

После этого в поле **Username** вводим имя пользователя, в пункте **Private key** включаем **Enter directly**, нажимаем **Add** и вставляем туда ключ шифрования *(да-да, та супер длинная последовательность символов)*.

Крутим в самый низ и нажимаем **Add**

После проделанных манипуляций в поле **Credentials** появится заветный пункт с пользователем, его и выбираем.

Крутим вниз и жмём **Save**

# Настройка проекта
В меню Dashboard нажимаем **Создать item**

Даём проекту имя, после чего из вариантов ниже выбираем **Pipeline**

Оставляем всё, как есть, и крутим вниз до пункта **Pipeline**

Тут в разделе **Definition** выбираем **Pipeline script from SCM**. Это значит, что наш пайплайн будет храниться в удалённом гит-репозитории (в данном случае гитлаб).
В поле **SCM** выбираем **Git**, после чего появится меню с кредами. Там нажимаем **Add** и выбираем способ аутентификации. Я оставил логин с паролем и просто ввёл их в соответствующие поля **Username** и **Password**.
Ниже проверяем, что название ветки соответствует действительности. По умолчанию там стоит ветка */master. В моём репозитории главная ветка называется **main**, так что пришлось поменять.
Также смотрим на поле **Script Path**, там надо указать путь к файлу с pipeline'ом. У меня он лежит в корне, так что я написал напрямую название **Jenkinsfile**

# Вот и всё. Дальше только настраивать Pipeline

# Возможные косяки
На сервере должны быть установлены пакеты git, docker, docker-compose, default-jdk.

Установку первых трёх пакетов смотреть в [README.md](wp/README.md#установка-docker-и-docker-compose)

Установка Java
```
sudo apt install default-jdk -y
```
## Ошибки
sudo: a terminal is required to read the password; either use the -S option to read from standard input or configure an askpass helper
Надо настроить на сервере выполнение sudo без пароля:
```
sudo visudo
alex ALL=(ALL) NOPASSWD: ALL
```
Если не пропадёт, то делаем следующим образом:
```
sudo visudo -f /etc/sudoers.d/alex
 alex ALL=(ALL) NOPASSWD: ALL
```
alex = имя пользователя
