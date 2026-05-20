# Dockerfile

# Стейдж 1: Збірка (Builder)
# Використовуємо офіційний образ Go
FROM golang:1.21-alpine AS builder

# Встановлюємо робочу директорію
WORKDIR /app

# Копіюємо файли залежностей (якщо є) і завантажуємо їх
COPY go.mod ./
# RUN go mod download # Розкоментуй, якщо додаси сторонні бібліотеки

# Копіюємо вихідний код
COPY *.go ./

# Компілюємо додаток
# CGO_ENABLED=0 робить бінарник статичним (працюватиме в порожньому середовищі)
# GOOS=linux вказує цільову ОС
RUN CGO_ENABLED=0 GOOS=linux go build -o /go-app

# ---------------------------------------------------

# Стейдж 2: Продакшен образ
# Беремо чистий і легкий alpine linux (~5 MB)
FROM alpine:3.19

# Створюємо непривілейованого користувача з міркувань безпеки (DevSecOps)
RUN adduser -D -g '' appuser
USER appuser

WORKDIR /home/appuser

# Копіюємо тільки готовий бінарник з першого стейджу
COPY --from=builder /go-app .

# Вказуємо порт, який слухає додаток
EXPOSE 8080

# Запускаємо додаток
CMD ["./go-app"]
