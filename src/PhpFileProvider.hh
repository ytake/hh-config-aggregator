<?hh // strict

namespace Ytake\HHConfigAggreagator;

class PhpFileProvider implements ConfigProvidable {
  use GlobTrait;
  /**
   * @param string $pattern A glob pattern by which to look up config files.
   */
  public function __construct(private string $pattern) {}

  public function provide(): array<mixed, mixed> {
    $readStream = [];
    foreach ($this->glob($this->pattern) as $file) {
      $fr = new Filesystem($file);
      $readStream[] = $fr->require();
    }
    return $readStream;
  }
}
