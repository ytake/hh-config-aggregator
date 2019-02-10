<?hh // strict

use type Ytake\HHConfigAggreagator\ConfigProvidable;

class ExampleConfigProvider implements ConfigProvidable {

  public function provide(): dict<arraykey, mixed> {
    return dict['testing' => __CLASS__];
  }
}
