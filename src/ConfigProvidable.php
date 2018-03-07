<?hh // strict

namespace Ytake\HHConfigAggreagator;

interface ConfigProvidable {
  public function provide(): array<mixed, mixed>;
}
