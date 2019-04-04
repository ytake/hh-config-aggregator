use type Facebook\HackTest\HackTest;
use type Ytake\HHConfigAggreagator\ArrayProvider;
use type Ytake\HHConfigAggreagator\ArrayProvider;
use type Ytake\HHConfigAggreagator\ConfigAggreagator;
use type Ytake\HHConfigAggreagator\PhpFileProvider;
use type Ytake\HHConfigAggreagator\Cache;
use type Ytake\HHConfigAggreagator\CacheConfig;
use function Facebook\FBExpect\expect;

class ConfigAggregatorTest extends HackTest {

  public function testShouldReturnExpectedConfigArray(): void {
    $expected = [
      'testing' => 'ExampleConfigProvider',
      'testing1' => 'NestedArrayProvider',
      0 => 1,
      'nested' => ['tk' => 'tv'],
      'hack' => 'config',
      'php' => 'config',
    ];
    $aggregator = new ConfigAggreagator(
      vec[
        new ExampleConfigProvider(),
        new NestedArrayProvider(),
        new PhpFileProvider(
          __DIR__.'/resources/config/{{,*.}global,{,*.}local}.{hh,php}',
        ),
      ],
    );
    $config = $aggregator->getMergedConfig();
    expect($config)->toInclude($expected);
  }

  public function testShouldReturnCacheConfigArray(): void {
    $expected = dict[
      'testing' => 'ExampleConfigProvider',
      'testing1' => 'NestedArrayProvider',
      0 => 1,
      'nested' => ['tk' => 'tv'],
      CacheConfig::KEYNAME => Cache::ENABLE,
    ];
    $aggregator = new ConfigAggreagator(
      vec[
        new ExampleConfigProvider(),
        new NestedArrayProvider(),
        new ArrayProvider(dict[CacheConfig::KEYNAME => Cache::ENABLE]),
      ],
      __DIR__.'/resources/cached.config.cache.hh',
    );
    $config = $aggregator->getMergedConfig();
    expect($config)->toBeType('dict');
    expect($config)->toInclude($expected);
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
      vec[
        new ExampleConfigProvider(),
        new NestedArrayProvider(),
        new ArrayProvider(
          dict[
            0 => 2,
            'testing' => 'ExampleConfigOverrideProvider',
            'testing2' => 'ArrayProvider',
          ],
        ),
      ],
    );
    $config = $aggregator->getMergedConfig();
    expect($config)->toInclude($expected);
  }

  <<__Override>>
  public async function afterEachTestAsync(): Awaitable<void>{
    if (file_exists(__DIR__.'/resources/cached.config.cache.hh')) {
      unlink(__DIR__.'/resources/cached.config.cache.hh');
    }
  }
}