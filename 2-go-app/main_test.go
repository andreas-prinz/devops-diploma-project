// main_test.go
package main

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
	"os"
	"time"
)

// 1. Тестуємо наш ендпоінт /health
func TestHealthCheckHandler(t *testing.T) {
	// Створюємо фейковий HTTP-запит
	req, err := http.NewRequest("GET", "/health", nil)
	if err != nil {
		t.Fatal(err)
	}

	// Створюємо Recorder для запису відповіді (замість реального сервера)
	rr := httptest.NewRecorder()
	
	// Припускаємо, що у твоєму main.go є функція HealthCheckHandler
	handler := http.HandlerFunc(HealthCheckHandler)

	// Виконуємо запит
	handler.ServeHTTP(rr, req)

	// 1. Перевіряємо статус код (має бути 200)
	if status := rr.Code; status != http.StatusOK {
		t.Errorf("Ендпоінт повернув неправильний статус: отримано %v, очікувалося %v",
			status, http.StatusOK)
	}

	// 2. Перевіряємо тіло відповіді (опціонально, наприклад перевірка версії)
	expected := `{"status":"ok"}`
	if rr.Body.String() != expected {
		t.Errorf("Ендпоінт повернув неправильне тіло: отримано %v, очікувалося %v",
			rr.Body.String(), expected)
	}
}

// 2. НОВИЙ ТЕСТ: Перевіряємо головний обробник "/" та логіку всередині нього
func TestRootHandler_Success(t *testing.T) {
	// Встановлюємо змінні оточення, щоб перевірити гілки if/else у коді
	os.Setenv("APP_ENV", "Staging")
	defer os.Unsetenv("APP_ENV") // Очищаємо після тесту

	// Робимо запит до кореня тестового сервера
	req, err := http.NewRequest("GET", "/", nil)
	if err != nil {
		t.Fatal(err)
	}

	// Створює віртуальний приймач відповіді
	rr := httptest.NewRecorder()
	
	// Бере вашу справжню функцію з main.go
	handler := http.HandlerFunc(RootHandler)
	// Безпосередньо передає до неї фейковий HTTP-запит
	handler.ServeHTTP(rr, req)

	// Перевіряємо статус-код (має бути 200)
	if res.StatusCode != http.StatusOK {
		t.Errorf("Очікувався статус 200, отримали %d", res.StatusCode)
	}

	// Декодуємо JSON-відповідь у структуру AppInfo, щоб перевірити поля
	var info AppInfo
	err = json.NewDecoder(res.Body).Decode(&info)
	if err != nil {
		t.Fatal("Не вдалося розпарити JSON-відповідь:", err)
	}

	// Проверяем корректность данных, которые сформировал обработчик
	if info.Environment != "Staging" {
		t.Errorf("Очікувалося оточення Staging, отримали %s", info.Environment)
	}
	if info.Version != AppVersion {
		t.Errorf("Очікувалася версія %s, отримали %s", AppVersion, info.Version)
	}
	if info.Message != WelcomeMessage {
		t.Errorf("Очікувалося повідомлення %s, отримали %s", WelcomeMessage, info.Message)
	}
}
