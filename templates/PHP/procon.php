#!/usr/bin/env php
<?php
if (basename(__FILE__) == basename($_SERVER['PHP_SELF'])) {
  while ($line = fgets(STDIN)) {
    $tokens = split(' +', $line);
    <+CURSOR+>
  }
}
?>
