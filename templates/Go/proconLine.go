package main

import (
  "bufio"
  "fmt"
  "os"
  "strconv"
  "strings"
)


func main() {
  scanner := bufio.NewScanner(os.Stdin)

  for scanner.Scan() {
    tokens := strings.Split(scanner.Text(), " ")
    a, _ := strconv.Atoi(tokens[0])
    b, _ := strconv.Atoi(tokens[1])
    <+CURSOR+>
  }
  if err := scanner.Err(); err != nil {
    fmt.Fprintln(os.Stderr, "reading standard input:", err)
  }
}
