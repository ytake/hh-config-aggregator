use type Facebook\HackTest\HackTest;
use type Ytake\HHConfigAggreagator\PhpFileProvider;

use function Facebook\FBExpect\expect;

class PhpFileProviderTest extends HackTest {
  public function testProviderLoadsConfigFromFiles(): void {
    $provider = new PhpFileProvider(
      __DIR__.'/resources/config/{{,*.}global,{,*.}local}.{hh,php,hack}',
    );

    expect($provider->provide())->toInclude(dict['php' => 'config', 'hack' => 'config']);
  }
}
