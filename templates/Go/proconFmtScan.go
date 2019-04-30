package main

import (
  "fmt"
)


func main() {
  var n int
  for _, err := fmt.Scan(&n); err == nil; _, err = fmt.Scan(&n) {
    <+CURSOR+>
  }
}

