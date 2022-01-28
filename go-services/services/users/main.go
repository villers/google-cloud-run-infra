package main

import (
	"encoding/json"
	"github.com/gin-gonic/gin"
	"io/ioutil"
	"net/http"
)

var serviceUsersUrl = "https://fakestoreapi.com/users"

func main() {
	r := gin.Default()
	r.GET("/ping", pingHandler)
	r.GET("/users", usersHandler)

	err := r.Run()
	if err != nil {
		panic(err)
		return
	}
}

func pingHandler(c *gin.Context) {
	c.JSON(200, gin.H{
		"name":    "users",
		"message": "pong",
	})
}

func usersHandler(c *gin.Context) {
	var payload json.RawMessage
	err := callHttp(serviceUsersUrl, &payload)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(200, payload)

}

func callHttp(url string, output *json.RawMessage) error {
	r, err := http.Get(url)
	if err != nil {
		return err
	}
	defer r.Body.Close()

	data, _ := ioutil.ReadAll(r.Body)

	return json.Unmarshal(data, output)
}
