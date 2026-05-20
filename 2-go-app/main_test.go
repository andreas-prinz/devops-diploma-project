// main_test.go
package main

import (
	"net/http"
	"net/http/httptest"
	"testing"
)

// Тестуємо наш ендпоінт /health
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
