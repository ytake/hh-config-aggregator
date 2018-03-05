<?hh // strict

namespace Ytake\HHConfigAggreagator;

trait GlobTrait {
  /**
   * @param string $pattern
   * @return array
   */
  private function glob(string $pattern): ImmVector<string> {
    $result = glob($pattern, GLOB_BRACE);
    if ($result === false) {
      $result = [];
    }
    return new ImmVector($result);
  }
}
