<?hh // strict

use Ytake\HHConfigAggreagator\ConfigProvidable;

class ExampleConfigProvider implements ConfigProvidable {

  public function provide(): array<mixed, mixed> {
    return ['testing' => __CLASS__];
  }
}
