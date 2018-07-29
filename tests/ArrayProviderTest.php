<?hh // strict

use type PHPUnit\Framework\TestCase;
use type Ytake\HHConfigAggreagator\ArrayProvider;

class ArrayProviderTest extends TestCase {
  public function testProviderReturnsArrayProvidedAtConstruction(): void {
    $expected = ['foo' => 'bar'];
    $provider = new ArrayProvider($expected);

    $this->assertSame($expected, $provider->provide());
  }
}
