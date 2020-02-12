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
 * Copyright (c) 2017-2020 Yuuki Takezawa
 *
 */
namespace Ytake\HHConfigAggreagator;

use namespace HH\Lib\{C, Str, Vec};
use type HH\Lib\Experimental\File\Path;
use function file_put_contents;
use function date;
use function var_export;

class ConfigAggreagator {

  private dict<arraykey, mixed> $config = dict[];

  public function __construct(
    vec<ConfigProvidable> $providers = vec[],
    ?string $cachedConfigFile = null,
  ) {
    if ($this->loadConfigFromCache($cachedConfigFile)) {
      return;
    }
    $this->config = $this->loadConfigFromProviders($providers);
    $this->cacheConfig($this->config, $cachedConfigFile);
  }

  private function loadConfigFromCache(
    ?string $cachedConfigFile
  ): bool {
    if (!$cachedConfigFile is nonnull) {
      return false;
    }
    $require = new Filesystem(new Path($cachedConfigFile));
    if (!$require->exists()) {
      return false;
    }
    $this->config = \HH\Asio\join($require->require());
    return true;
  }

  private function loadConfigFromProviders(
    vec<ConfigProvidable> $providers,
  ): dict<arraykey, mixed> {
    $configAsyncVec = Vec\map_async($providers, ($p) ==> $p->provideAsync());
    return $this->mergeDict(\HH\Asio\join($configAsyncVec));
  }

  <<__Rx>>
  private function mergeDict(
    vec<dict<arraykey, mixed>> $vec
  ): dict<arraykey, mixed> {
    $map = dict[];
    foreach ($vec as $v) {
      if ($v is dict<_, _>) {
        foreach ($v as $key => $row) {
          if ($key is arraykey) {
            $map[$key] = $row;
          }
        }
      }
    }
    return $map;
  }

  <<__Rx>>
  public function getMergedConfig(): dict<arraykey, mixed> {
    return $this->config;
  }

  protected function cacheConfig(
    dict<arraykey, mixed> $configMap,
    ?string $cachedConfigFile = null,
  ): void {
    if (!$cachedConfigFile is nonnull) {
      return;
    }
    if (!C\contains_key($configMap, CacheConfig::KEYNAME)) {
      return;
    }
    if ($configMap[CacheConfig::KEYNAME] === Cache::DISABLE) {
      return;
    }
    file_put_contents(
      $cachedConfigFile,
      Str\format(
        '<?hh // partial
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
