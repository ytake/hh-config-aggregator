<?hh // strict

namespace Ytake\HHConfigAggreagator;

class ArrayProvider implements ConfigProvidable {
  /**
   * @param array $config
   */
  public function __construct(private array<mixed, mixed> $config) {}

  /**
   * @return array
   */
  public function provide(): array<mixed, mixed> {
    return $this->config;
  }
}
