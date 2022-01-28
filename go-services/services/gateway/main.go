package main

import (
	"encoding/json"
	"fmt"
	"github.com/gin-gonic/gin"
	"io/ioutil"
	"net/http"
	"os"
)

var serviceProductsUrl = "http://products"
var serviceUsersUrl = "http://users"

func main() {
	if "" != os.Getenv("SERVICE_PRODUCTS_URL") {
		serviceProductsUrl = os.Getenv("SERVICE_PRODUCTS_URL")
	}
	if "" != os.Getenv("SERVICE_USERS_URL") {
		serviceUsersUrl = os.Getenv("SERVICE_USERS_URL")
	}

	r := gin.Default()
	r.GET("/ping", pingHandler)

	products := r.Group("/products")
	{
		products.GET("/", productsHandler)
		products.GET("/ping", pingRemoteHandler(serviceProductsUrl))
	}

	users := r.Group("/users")
	{
		users.GET("/", usersHandler)
		users.GET("/ping", pingRemoteHandler(serviceUsersUrl))
	}

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

func pingRemoteHandler(url string) func(c *gin.Context) {
	return func(c *gin.Context) {
		var payload json.RawMessage
		url := fmt.Sprintf("%s/ping", url)
		err := callHttp(url, &payload)
		if err != nil {
			fmt.Println(err)
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		c.JSON(200, payload)
	}
}

func productsHandler(c *gin.Context) {
	var payload json.RawMessage
	url := fmt.Sprintf("%s/products", serviceProductsUrl)
	err := callHttp(url, &payload)
	if err != nil {
		fmt.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(200, payload)
}

func usersHandler(c *gin.Context) {
	var payload json.RawMessage
	url := fmt.Sprintf("%s/users", serviceUsersUrl)
	err := callHttp(url, &payload)
	if err != nil {
		fmt.Println(err)
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
