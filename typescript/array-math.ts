function arrayAdd(a: number[], b: number[]): number[] {
    if (a.length != b.length) throw new RangeError("a.length: ${a.length} != b.length: ${b.length}");
    return a.map((_, i) => a[i] + b[i]);
}

function arraySubtract(a: number[], b: number[]): number[] {
    if (a.length != b.length) throw new RangeError("a.length: ${a.length} != b.length: ${b.length}");
    return a.map((_, i) => a[i] - b[i]);
}

function arrayMultiply(a: number[], b: number[]): number[] {
    if (a.length != b.length) throw new RangeError("a.length: ${a.length} != b.length: ${b.length}");
    return a.map((_, i) => a[i] * b[i]);
}

function arrayDivide(a: number[], b: number[]): number[] {
    if (a.length != b.length) throw new RangeError("a.length: ${a.length} != b.length: ${b.length}");
    return a.map((_, i) => a[i] / b[i]);
}
