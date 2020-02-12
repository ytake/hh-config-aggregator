use type Facebook\HackTest\HackTest;
use type Ytake\HHConfigAggreagator\{
  Cache,
  CacheConfig,
  ConfigAggreagator,
  DictProvider,
  PhpFileProvider,
};
use function Facebook\FBExpect\expect;

class ConfigAggregatorTest extends HackTest {

  public function testShouldReturnExpectedConfigArray(): void {
    $expected = dict[
      'testing' => 'ExampleConfigProvider',
      'testing1' => 'NestedArrayProvider',
      0 => 1,
      'nested' => dict['tk' => 'tv'],
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
      'nested' => dict['tk' => 'tv'],
      CacheConfig::KEYNAME => Cache::ENABLE,
    ];
    $aggregator = new ConfigAggreagator(
      vec[
        new ExampleConfigProvider(),
        new NestedArrayProvider(),
        new DictProvider(dict[CacheConfig::KEYNAME => Cache::ENABLE]),
      ],
      __DIR__.'/resources/cached.config.cache.hh',
    );
    $config = $aggregator->getMergedConfig();
    expect($config)->toBeType('dict');
    expect($config)->toInclude($expected);
  }

  public function testShouldReturnExpectedOverrideConfigArray(): void {
    $expected = dict[
      'testing' => 'ExampleConfigOverrideProvider',
      'testing1' => 'NestedArrayProvider',
      0 => 2,
      'nested' => dict['tk' => 'tv'],
      'testing2' => 'ArrayProvider',
    ];
    $aggregator = new ConfigAggreagator(
      vec[
        new ExampleConfigProvider(),
        new NestedArrayProvider(),
        new DictProvider(
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
