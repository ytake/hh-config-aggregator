<?hh // decl

/**
 * @license http://www.opensource.org/licenses/mit-license.php MIT (see the LICENSE file)
 */

namespace Ytake\HHConfigAggreagator;

final class Filesystem {
    public function __construct(string $filename);

    public function exists(): bool;
    /**
     * @return array<mixed, mixed>
     */
    public function require(): array<mixed, mixed>;
}
