<?hh // strict

/**
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * This software consists of voluntary contributions made by many individuals
 * and is licensed under the MIT license.
 *
 * Copyright (c) 2017-2018 Yuuki Takezawa
 *
 */
namespace Ytake\HHConfigAggreagator;

use namespace HH\Lib\Str;

use function is_null;
use function is_array;
use function array_key_exists;
use function file_put_contents;
use function sprintf;
use function date;
use function var_export;

class ConfigAggreagator {
  const string ENABLE_CACHE = 'config_cache_enabled';
  private array<mixed, mixed> $config = [];

  public function __construct(
    vec<ConfigProvidable> $providers = vec[],
    ?string $cachedConfigFile = null,
  ) {
    if ($this->loadConfigFromCache($cachedConfigFile)) {
      return;
    }
    $this->config = $this->loadConfigFromProviders($providers)->toArray();
    $this->cacheConfig($this->config, $cachedConfigFile);
  }

  private function loadConfigFromCache(
    ?string $cachedConfigFile
  ): bool {
    if (is_null($cachedConfigFile)) {
      return false;
    }
    $require = new Filesystem($cachedConfigFile);
    if (!$require->exists()) {
      return false;
    }
    $this->config = $require->require();
    return true;
  }

  private function loadConfigFromProviders(
    vec<ConfigProvidable> $providers,
  ): Map<mixed, mixed> {
    $configArray = vec[];
    foreach ($providers as $provider) {
      $configArray[] = $provider->provide();
    }
    return $this->mergeArrayToMap($configArray);
  }

  private function mergeArrayToMap(
    vec<array<mixed, mixed>> $vec
  ): Map<mixed, mixed> {
    $map = Map{};
    foreach ($vec as $v) {
      if (is_array($v)) {
        foreach ($v as $key => $row) {
          if ($key is int || $key is string) {
            $map->add(Pair {$key, $row});
          }
        }
      }
    }
    return $map;
  }

  public function getMergedConfig(): array<mixed, mixed> {
    return $this->config;
  }

  protected function cacheConfig(
    array<mixed, mixed> $configMap,
    ?string $cachedConfigFile = null,
  ): void {
    if (is_null($cachedConfigFile)) {
      return;
    }
    if (!array_key_exists(static::ENABLE_CACHE, $configMap)) {
      return;
    }
    if ($configMap[static::ENABLE_CACHE] === false) {
      return;
    }
    file_put_contents(
      $cachedConfigFile,
      Str\format(
        '<?hh
        /**
        * This configuration cache file was generated at %s
        */
        return %s;',
        date('c'),
        var_export($configMap, true),
      ),
    );
    return;
  }
}
