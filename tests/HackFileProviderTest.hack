use type Facebook\HackTest\HackTest;
use type Ytake\HHConfigAggreagator\HackFileProvider;

use function Facebook\FBExpect\expect;

class HackFileProviderTest extends HackTest {
  public async function testProviderLoadsConfigFromFiles(): Awaitable<void> {
    $provider = new HackFileProvider(
      __DIR__.'/resources/config/{{,*.}global,{,*.}local}.{hackpartial}',
    );
    expect(await $provider->provideAsync())->toInclude(
      dict[
        'php' => 'config',
        'hack' => 'config'
      ]
    );
  }
}
