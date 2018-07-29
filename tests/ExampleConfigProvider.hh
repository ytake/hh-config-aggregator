<?hh // strict

use type Ytake\HHConfigAggreagator\ConfigProvidable;

class ExampleConfigProvider implements ConfigProvidable {

  public function provide(): array<mixed, mixed> {
    return ['testing' => __CLASS__];
  }
}
