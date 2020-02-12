use type Facebook\HackTest\HackTest;
use type Ytake\HHConfigAggreagator\PhpFileProvider;

use function Facebook\FBExpect\expect;

class PhpFileProviderTest extends HackTest {
  public async function testProviderLoadsConfigFromFiles(): Awaitable<void> {
    $provider = new PhpFileProvider(
      __DIR__.'/resources/config/{{,*.}global,{,*.}local}.{hh,php,hack}',
    );

    expect(await $provider->provideAsync())->toInclude(
      dict[
        'php' => 'config',
        'hack' => 'config'
      ]
    );
  }
}
