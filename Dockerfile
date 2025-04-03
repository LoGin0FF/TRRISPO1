# Этап сборки
FROM golang:1.24-bullseye AS builder

WORKDIR /app
COPY . .

# Сборка приложения
RUN go mod download
RUN make build

# Этап тестирования
FROM builder AS tester
RUN make test

# Этап создания deb-пакета
FROM builder AS packager

# Установка необходимых инструментов для создания deb-пакета
RUN apt-get update && apt-get install -y \
    dpkg-dev \
    debhelper \
    && rm -rf /var/lib/apt/lists/*

# Создание структуры для deb-пакета
RUN mkdir -p /app/debian/myapp/usr/bin
RUN cp bin/app /app/debian/myapp/usr/bin/myapp

# Создание control файла
RUN mkdir -p /app/debian/myapp/DEBIAN
RUN echo "Package: myapp\n\
Version: 1.0.0\n\
Section: utils\n\
Priority: optional\n\
Architecture: amd64\n\
Maintainer: Your Name <your.email@example.com>\n\
Description: Text Analysis Application\n\
 Application for finding longest words in text." > /app/debian/myapp/DEBIAN/control

# Создание deb-пакета
RUN dpkg-deb --build /app/debian/myapp

# Финальный этап
FROM debian:bullseye-slim

COPY --from=packager /app/debian/myapp.deb /
RUN dpkg -i /myapp.deb

ENTRYPOINT ["myapp"] 