<?hh // strict

use PHPUnit\Framework\TestCase;
use Ytake\HHConfigAggreagator\PhpFileProvider;

class PhpFileProviderTest extends TestCase {
  public function testProviderLoadsConfigFromFiles(): void {
    $provider = new PhpFileProvider(
      __DIR__.'/resources/config/{{,*.}global,{,*.}local}.{hh,php}',
    );
    $merged = [];
    foreach ($provider->provide() as $v) {
      $merged = array_merge($merged, $v);
    }
    $this->assertEquals(['php' => 'config', 'hack' => 'config'], $merged);
  }
}
