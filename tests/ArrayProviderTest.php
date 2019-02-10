<?hh // strict

use type Facebook\HackTest\HackTest;
use type Ytake\HHConfigAggreagator\ArrayProvider;

use function Facebook\FBExpect\expect;

class ArrayProviderTest extends HackTest {
  public function testProviderReturnsArrayProvidedAtConstruction(): void {
    $expected = dict['foo' => 'bar'];
    $provider = new ArrayProvider($expected);
    expect($provider->provide())->toBeSame($expected);
  }
}
