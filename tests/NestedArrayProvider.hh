<?hh // strict

use type Ytake\HHConfigAggreagator\ConfigProvidable;

class NestedArrayProvider implements ConfigProvidable {

  public function provide(): array<mixed, mixed> {
    return ['testing1' => __CLASS__, 0 => 1, 'nested' => ['tk' => 'tv']];
  }
}
