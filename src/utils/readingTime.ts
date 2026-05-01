export function readingTime(text: string): number {
  const charCount = text.replace(/\s/g, "").length;
  const words = text.split(/\s+/).filter(Boolean).length;
  const minZh = charCount / 400;
  const minEn = words / 200;
  const minutes = Math.max(minZh, minEn);
  return Math.max(1, Math.ceil(minutes));
}
