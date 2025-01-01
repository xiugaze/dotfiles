package main

import (
  "fmt"
  "net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
  fmt.Fprintln(w, "Hello, World!")
}

func main() {
  http.HandleFunc("/", handler)

  fmt.Println("Server is starting on port 9999...")
  err := http.ListenAndServe(":9999", nil)
  if err != nil {
    fmt.Println("Error starting server:", err)
  }
}
