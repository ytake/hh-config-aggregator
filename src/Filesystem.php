<?php

namespace Ytake\HHConfigAggreagator;

final class Filesystem {
  private $filename = '';
  public function __construct($filename) {
    $this->filename = $filename;
  }
  /**
   * @return bool
   */
  public function exists() {
    return file_exists($this->filename);
  }
  /**
   * @return mixed|bool
   */
  public function require() {
    return require $this->filename;
  }
}
