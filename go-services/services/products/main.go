package main

import (
	"encoding/json"
	"github.com/gin-gonic/gin"
	"io/ioutil"
	"net/http"
)

var serviceProductsUrl = "https://fakestoreapi.com/products"

func main() {
	r := gin.Default()
	r.GET("/ping", pingHandler)
	r.GET("/products", productsHandler)

	err := r.Run()
	if err != nil {
		panic(err)
		return
	}
}

func pingHandler(c *gin.Context) {
	c.JSON(200, gin.H{
		"message": "pong",
	})
}

func productsHandler(c *gin.Context) {
	var payload json.RawMessage
	err := callHttp(serviceProductsUrl, &payload)
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
