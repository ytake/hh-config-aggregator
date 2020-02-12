use type Facebook\HackTest\HackTest;
use type Ytake\HHConfigAggreagator\DictProvider;

use function Facebook\FBExpect\expect;

class ArrayProviderTest extends HackTest {
  public async function testProviderReturnsArrayProvidedAtConstruction(): Awaitable<void> {
    $expected = dict['foo' => 'bar'];
    $provider = new DictProvider($expected);
    expect(await $provider->provideAsync())->toBeSame($expected);
  }
}
