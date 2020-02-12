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

use namespace HH\Lib\Dict;
use type HH\Lib\Experimental\File\Path;

class PhpFileProvider implements ConfigProvidable {
  use GlobTrait;

  public function __construct(
    private string $pattern
  ) {}

  public async function provideAsync(): Awaitable<dict<arraykey, mixed>> {
    $readStream = dict[];
    foreach ($this->glob($this->pattern) as $file) {
      $fr = new Filesystem(new Path($file));
      $readStream = Dict\merge($readStream, await $fr->require());
    }
    return dict($readStream);
  }
}
