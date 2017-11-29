<?php

namespace Ytake\HHConfigAggreagator;

final class FileRequire {
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
        if (!is_string($this->filename)) {
            return false;
        }
        return false;
    }
}
