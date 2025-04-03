APP_NAME = myapp
VERSION = 1.0.0
BUILD_DIR = build
DEB_DIR = $(BUILD_DIR)/$(APP_NAME)

# Проверка наличия необходимых инструментов
REQUIRED_TOOLS := go dpkg-deb
$(foreach tool,$(REQUIRED_TOOLS),\
    $(if $(shell which $(tool)),,$(error "$(tool) не установлен. Установите его с помощью 'apt-get install $(tool)'")))

# Проверка версии Go
GO_VERSION_FULL := $(shell go version 2>/dev/null)
GO_VERSION_CHECK := $(shell go version 2>/dev/null | grep -q "go1\.[0-9]\{2,\}" && echo "ok")
ifneq ($(GO_VERSION_CHECK),ok)
    $(error "Требуется Go версии 1.11 или выше")
endif

# Целевые пути
BIN_DIR = $(DEB_DIR)/usr/local/bin
DEBIAN_DIR = $(DEB_DIR)/DEBIAN
DEB_PACKAGE = $(APP_NAME)_$(VERSION)_amd64.deb

# Компиляция Go-программы
build:
	@echo "===> Компиляция Go-программы..."
	go mod init $(APP_NAME) || true
	go build -o bin/app src/myapp.go

# Запуск программы
run:
	@echo "===> Запуск программы..."
	go run src/myapp.go

# Тестирование
test:
	go test ./src/...

# Упаковка в .deb
package: build
	@echo "===> Подготовка структуры .deb пакета..."
	mkdir -p $(BIN_DIR)
	mkdir -p $(DEBIAN_DIR)
	cp bin/app $(BIN_DIR)/

	@echo "===> Создание файла control..."
	echo "Package: $(APP_NAME)" > $(DEBIAN_DIR)/control
	echo "Version: $(VERSION)" >> $(DEBIAN_DIR)/control
	echo "Section: utils" >> $(DEBIAN_DIR)/control
	echo "Priority: optional" >> $(DEBIAN_DIR)/control
	echo "Architecture: amd64" >> $(DEBIAN_DIR)/control
	echo "Depends: libc6 (>= 2.31)" >> $(DEBIAN_DIR)/control
	echo "Build-Depends: golang (>= 1.11)" >> $(DEBIAN_DIR)/control
	echo "Maintainer: Your Name <email@example.com>" >> $(DEBIAN_DIR)/control
	echo "Description: Программа на Go, которая находит самые длинные слова в тексте." >> $(DEBIAN_DIR)/control
	echo " Это приложение анализирует входной текст и находит самые длинные слова." >> $(DEBIAN_DIR)/control

	@echo "===> Создание .deb пакета..."
	dpkg-deb --build $(DEB_DIR)
	mv $(DEB_DIR).deb $(BUILD_DIR)/$(DEB_PACKAGE)

# Установка пакета
install: package
	@echo "===> Установка .deb пакета..."
	sudo dpkg -i $(BUILD_DIR)/$(DEB_PACKAGE)

# Удаление пакета
remove:
	@echo "===> Удаление пакета..."
	sudo dpkg -r $(APP_NAME)

# Очистка сборки
clean:
	@echo "===> Очистка..."
	rm -rf bin/ $(APP_NAME) $(BUILD_DIR) go.mod go.sum

.PHONY: build run test clean
