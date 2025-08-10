// <r:package>
package main

// <r:imports>
import (
	"fmt"
	"encoding/json"
	"net/http"
)

// <r:types>
type User struct {
	ID    int    `json:"id"`
	Name  string `json:"name"`
	Email string `json:"email"`
}

type UserService struct {
	users map[int]User
}

// <r:methods>
func NewUserService() *UserService {
	return &UserService{
		users: make(map[int]User),
	}
}

func (us *UserService) AddUser(user User) {
	us.users[user.ID] = user
}

func (us *UserService) GetUser(id int) (User, bool) {
	user, exists := us.users[id]
	return user, exists
}

// <r:handlers>
func (us *UserService) HandleGetUser(w http.ResponseWriter, r *http.Request) {
	// Implementation here
	fmt.Fprintf(w, "User handler")
}

// <r:main>
func main() {
	service := NewUserService()
	service.AddUser(User{ID: 1, Name: "Alice", Email: "alice@example.com"})
	
	user, exists := service.GetUser(1)
	if exists {
		fmt.Printf("Found user: %+v\n", user)
	}
}