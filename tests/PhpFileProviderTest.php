<?hh // strict

use type PHPUnit\Framework\TestCase;
use type Ytake\HHConfigAggreagator\PhpFileProvider;

class PhpFileProviderTest extends TestCase {
  public function testProviderLoadsConfigFromFiles(): void {
    $provider = new PhpFileProvider(
      __DIR__.'/resources/config/{{,*.}global,{,*.}local}.{hh,php}',
    );
    $this->assertEquals(['php' => 'config', 'hack' => 'config'], $provider->provide());
  }
}
