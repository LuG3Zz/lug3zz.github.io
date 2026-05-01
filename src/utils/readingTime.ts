export function readingTime(text: string): number {
  const cjkChars = (text.match(/[\u4e00-\u9fff\u3400-\u4dbf\uf900-\ufaff]/g) || []).length;
  const enWords = text.replace(/[\u4e00-\u9fff\u3400-\u4dbf\uf900-\ufaff]/g, " ").split(/\s+/).filter(Boolean).length;
  const codeBlocks = (text.match(/```/g) || []).length / 2;
  const minCJK = cjkChars / 300;
  const minEN = enWords / 160;
  const minCode = codeBlocks * 0.5;
  return Math.max(1, Math.ceil(Math.max(minCJK, minEN) + minCode));
}
