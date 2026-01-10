package main

import (
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("order created"))
}

func main() {
	http.HandleFunc("/orders", handler)
	http.ListenAndServe(":8080", nil)
}
