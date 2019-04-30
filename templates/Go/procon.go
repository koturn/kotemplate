package main

import (
  "bufio"
  "fmt"
  "os"
  "strconv"
)


func main() {
  scanner := bufio.NewScanner(os.Stdin)
  scanner.Split(bufio.ScanWords)

  for scanner.Scan() {
    x, _ := strconv.Atoi(scanner.Text())
    <+CURSOR+>
  }
  if err := scanner.Err(); err != nil {
    fmt.Fprintln(os.Stderr, "reading standard input:", err)
  }
}
