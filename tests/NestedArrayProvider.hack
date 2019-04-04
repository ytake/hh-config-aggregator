use type Ytake\HHConfigAggreagator\ConfigProvidable;

class NestedArrayProvider implements ConfigProvidable {

  public function provide(): dict<arraykey, mixed> {
    return dict['testing1' => __CLASS__, 0 => 1, 'nested' => ['tk' => 'tv']];
  }
}
