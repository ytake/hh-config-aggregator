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

use namespace HH\Lib\Vec;
use type HH\Lib\File\Path;

class HackFileProvider implements ConfigProvidable {
  use GlobTrait;

  public function __construct(
    private string $pattern
  ) {}

  public async function provideAsync(): Awaitable<dict<arraykey, mixed>> {
    $readStream = dict[];
    $fv = vec[];
    foreach ($this->glob($this->pattern) as $file) {
      $fv[] = new Filesystem(new Path($file));
    }
    $read = Vec\map_async($fv, ($f) ==> $f->require());
    $stream = await $read;
    foreach ($stream as $value) {
      foreach ($value as $key => $v) {
        $readStream[$key] = $v;
      }
    }
    return dict($readStream);
  }
}
