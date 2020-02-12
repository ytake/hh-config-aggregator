use type Ytake\HHConfigAggreagator\ConfigProvidable;

class ExampleConfigProvider implements ConfigProvidable {

  public async function provideAsync(): Awaitable<dict<arraykey, mixed>> {
    return await async {
      return dict['testing' => __CLASS__];
    };
  }
}
