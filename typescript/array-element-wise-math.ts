/***
 * Array utility functions for simple element-wise calculations.
 * There may be a better way to do these, such as using a library.
 */

/**
 * Add arrays element-wise.
 * @example arrayAdd([1, 2, 3], [4, 5, 6]) => [5, 7, 9]
 * @param {number[]} a - array 1.
 * @param {number[]} b - array 2.
 */
function arrayAdd(a: number[], b: number[]): number[] {
    if (a.length != b.length) throw new RangeError("a.length: ${a.length} != b.length: ${b.length}");
    return a.map((_, i) => a[i] + b[i]);
}

/**
 * Subtract arrays element-wise.
 * @example arraySubtract([1, 2, 3], [4, 5, 6]) => [-3, -3, -3]
 * @param {number[]} a - array 1.
 * @param {number[]} b - array 2.
 */
function arraySubtract(a: number[], b: number[]): number[] {
    if (a.length != b.length) throw new RangeError("a.length: ${a.length} != b.length: ${b.length}");
    return a.map((_, i) => a[i] - b[i]);
}

/**
 * Multiply arrays element-wise.
 * @example arraySubtract([1, 2, 3], [4, 5, 6]) => [4, 10, 18]
 * @param {number[]} a - array 1.
 * @param {number[]} b - array 2.
 */
function arrayMultiply(a: number[], b: number[]): number[] {
    if (a.length != b.length) throw new RangeError("a.length: ${a.length} != b.length: ${b.length}");
    return a.map((_, i) => a[i] * b[i]);
}

/**
 * Divide arrays element-wise.
 * @example arraySubtract([1, 2, 3], [4, 5, 6]) => [0.25, 0.4, 0.5]
 * @param {number[]} a - array 1.
 * @param {number[]} b - array 2.
 */
function arrayDivide(a: number[], b: number[]): number[] {
    if (a.length != b.length) throw new RangeError("a.length: ${a.length} != b.length: ${b.length}");
    return a.map((_, i) => a[i] / b[i]);
}
