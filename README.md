# HH-Config-Aggregator

[![Build Status](https://travis-ci.org/ytake/hh-config-aggregator.svg?branch=master)](https://travis-ci.org/ytake/hh-config-aggregator)

Aggregates and merges configuration, Supports caching for fast bootstrap in production environments.

[zendframework/zend-config-aggregator](https://github.com/zendframework/zend-config-aggregator) converted for hack

## Installation

```bash
$ composer require ytake/hh-config-aggregator
```

## Usage

```hack
use type Ytake\HHConfigAggreagator\ArrayProvider;
use type Ytake\HHConfigAggreagator\ConfigAggreagator;
use type Ytake\HHConfigAggreagator\PhpFileProvider;

$aggregator = new ConfigAggreagator(
  vec[
    new PhpFileProvider(
      __DIR__.'/resources/config/{{,*.}global,{,*.}local}.{hack,hackpartial}',
    ),
    new ArrayProvider(['config_cache_enabled' => true])
  ],
  __DIR__.'/resources/cached.config.cache.hackpartial'
);
$aggregator->getMergedConfig();
```
