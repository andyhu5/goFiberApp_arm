package main

import (
	"fmt"
	"time"

	"github.com/gofiber/fiber/v2"
)

func main() {

	fmt.Println("Listenning on 9000.")

	// http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
	// 	currentTime := time.Now().Format(time.RFC1123)
	// 	w.Write([]byte("Current time: " + currentTime + "\n"))
	// })

	// err := http.ListenAndServe(":9000", nil)
	// if err != nil {
	// 	log.Fatal("ListenAndServe: ", err)
	// }

	app := fiber.New()
	app.Get("/", func(c *fiber.Ctx) error {
		currentTime := time.Now().Format(time.RFC1123)
		return c.SendString("Fiber Current time: " + currentTime + "\n")
	})
	app.Listen(":9000")
}
