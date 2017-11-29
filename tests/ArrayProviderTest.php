<?hh // strict

use PHPUnit\Framework\TestCase;
use Ytake\HHConfigAggreagator\ArrayProvider;

class ArrayProviderTest extends TestCase {
  public function testProviderReturnsArrayProvidedAtConstruction(): void {
    $expected = ['foo' => 'bar'];
    $provider = new ArrayProvider($expected);

    $this->assertSame($expected, $provider->provide());
  }
}
