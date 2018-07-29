<?hh // strict

use type PHPUnit\Framework\TestCase;
use type Ytake\HHConfigAggreagator\ArrayProvider;
use type Ytake\HHConfigAggreagator\ConfigAggreagator;
use type Ytake\HHConfigAggreagator\PhpFileProvider;

class ConfigAggreagatorTest extends TestCase {

  public function testShouldReturnExpectedConfigArray(): void {
    $expected = [
      'testing' => 'ExampleConfigProvider',
      'testing1' => 'NestedArrayProvider',
      0 => 1,
      'nested' => ['tk' => 'tv'],
      'php' => 'config',
      'hack' => 'config'
    ];
    $aggregator = new ConfigAggreagator(
      [
        new ExampleConfigProvider(),
        new NestedArrayProvider(),
        new PhpFileProvider(
          __DIR__.'/resources/config/{{,*.}global,{,*.}local}.{hh,php}',
        ),
      ],
    );
    $config = $aggregator->getMergedConfig();
    $this->assertEquals($expected, $config);
  }

  public function testShouldReturnCacheConfigArray(): void {
    $expected = [
      'testing' => 'ExampleConfigProvider',
      'testing1' => 'NestedArrayProvider',
      0 => 1,
      'nested' => ['tk' => 'tv'],
      'config_cache_enabled' => true,
    ];
    $aggregator = new ConfigAggreagator(
      [
        new ExampleConfigProvider(),
        new NestedArrayProvider(),
        new ArrayProvider(['config_cache_enabled' => true]),
      ],
      __DIR__.'/resources/cached.config.cache.hh',
    );
    $config = $aggregator->getMergedConfig();
    $this->assertFileExists(__DIR__.'/resources/cached.config.cache.hh');
    $this->assertInternalType('array', $config);
    $this->assertEquals($expected, $config);
  }

  public function testShouldReturnExpectedOverrideConfigArray(): void {
    $expected = [
      'testing' => 'ExampleConfigOverrideProvider',
      'testing1' => 'NestedArrayProvider',
      0 => 2,
      'nested' => ['tk' => 'tv'],
      'testing2' => 'ArrayProvider',
    ];
    $aggregator = new ConfigAggreagator(
      [
        new ExampleConfigProvider(),
        new NestedArrayProvider(),
        new ArrayProvider(
          [
            0 => 2,
            'testing' => 'ExampleConfigOverrideProvider',
            'testing2' => 'ArrayProvider',
          ],
        ),
      ],
    );
    $config = $aggregator->getMergedConfig();
    $this->assertEquals($expected, $config);
  }

  <<__Override>>
  protected function tearDown(): void {
    if (file_exists(__DIR__.'/resources/cached.config.cache.hh')) {
      unlink(__DIR__.'/resources/cached.config.cache.hh');
    }
  }
}
