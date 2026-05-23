// main.go
package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"runtime"
	"time"
)

// AppInfo - структура для нашої JSON-відповіді
type AppInfo struct {
	Message     string    `json:"message"`
	Version     string    `json:"version"`
	Environment string    `json:"environment"`
	PodName     string    `json:"pod_name"`
	GoVersion   string    `json:"go_version"`
	Timestamp   time.Time `json:"timestamp"`
}

// Поточна версія додатку (змінюй це значення при нових релізах)
const AppVersion = "v1.0.0"
const WelcomeMessage = "DevOps Diploma Project API, Hello World!"

func HealthCheckHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	w.Write([]byte(`{"status":"ok"}`))
}

func RootHandler(w http.ResponseWriter, r *http.Request) {
	// Отримуємо ім'я пода (Kubernetes завжди записує його в змінну HOSTNAME)
	podName, err := os.Hostname()
	if err != nil {
		podName = "Unknown"
	}

	// Отримуємо середовище з кастомної змінної (яку можна передати через маніфест)
	envName := os.Getenv("APP_ENV")
	if envName == "" {
		envName = "Production"
	}

	info := AppInfo{
		Message:     WelcomeMessage,
		Version:     AppVersion,
		Environment: envName,
		PodName:     podName,
		GoVersion:   runtime.Version(),
		Timestamp:   time.Now(),
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(info)
		
	// Логуємо запит у консоль пода (буде видно в логах K8s)
	log.Printf("Request received from %s, handled by pod: %s", r.RemoteAddr, podName)
}

func main() {
	// Ендпоінт для перевірки стану (Liveness/Readiness probes в K8s)
	http.HandleFunc("/health", HealthCheckHandler)

	// Головний ендпоінт, який віддає інформацію
	http.HandleFunc("/", RootHandler)

	fmt.Printf("Starting server version %s on port 8080...\n", AppVersion)
	log.Fatal(http.ListenAndServe(":8080", nil))
}
