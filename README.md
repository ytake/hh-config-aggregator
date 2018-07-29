# HH-Config-Aggregator

[![Build Status](https://travis-ci.org/ytake/hh-config-aggregator.svg?branch=master)](https://travis-ci.org/ytake/hh-config-aggregator)

Aggregates and merges configuration, Supports caching for fast bootstrap in production environments.

[zendframework/zend-config-aggregator](https://github.com/zendframework/zend-config-aggregator) converted for hack

## Installation

```bash
$ hhvm $(which composer) require ytake/hh-config-aggregator
```

## Usage

```hack
use Ytake\HHConfigAggreagator\ArrayProvider;
use Ytake\HHConfigAggreagator\ConfigAggreagator;
use Ytake\HHConfigAggreagator\PhpFileProvider;

$aggregator = new ConfigAggreagator(
  [
    new PhpFileProvider(
      __DIR__.'/resources/config/{{,*.}global,{,*.}local}.{hh,php}',
    ),
    new ArrayProvider(['config_cache_enabled' => true])
  ],
  __DIR__.'/resources/cached.config.cache.hh'
);
$aggregator->getMergedConfig();
```
