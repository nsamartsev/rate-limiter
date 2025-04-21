package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"golang.org/x/time/rate"
)

const (
	limitPerSecond = 1
	burstCapacity  = 5
)

var limiter = rate.NewLimiter(limitPerSecond, burstCapacity)

func rateLimiter(c *gin.Context) {
	if !limiter.Allow() {
		c.JSON(http.StatusTooManyRequests, gin.H{"error": "too many requests"})
		c.Abort()
		return
	}
	c.Next()
}

func main() {

	r := gin.Default()

	r.Use(rateLimiter)

	r.GET("/", func(c *gin.Context) {
		c.String(http.StatusOK, "Welcome to the rate-limited endpoint!")
	})

	r.Run(":8080")

}
