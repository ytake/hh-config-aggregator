use type Ytake\HHConfigAggreagator\ConfigProvidable;

class NestedArrayProvider implements ConfigProvidable {

  public async function provideAsync(): Awaitable<dict<arraykey, mixed>> {
    return dict[
      'testing1' => __CLASS__,
      0 => 1,
      'nested' => dict[
        'tk' => 'tv'
      ]
    ];
  }
}
