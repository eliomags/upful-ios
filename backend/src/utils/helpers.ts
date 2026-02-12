/**
 * Generate a random hex ID (32 chars = 16 bytes)
 */
export function generateId(): string {
  const bytes = new Uint8Array(16);
  crypto.getRandomValues(bytes);
  return Array.from(bytes)
    .map((b) => b.toString(16).padStart(2, '0'))
    .join('');
}

/**
 * Get current UTC datetime in ISO8601 format
 */
export function now(): string {
  return new Date().toISOString();
}

/**
 * Get today's date as YYYY-MM-DD
 */
export function today(): string {
  return new Date().toISOString().split('T')[0];
}

/**
 * Get current month as YYYY-MM
 */
export function currentMonth(): string {
  const d = new Date();
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}`;
}

/**
 * Hash a string with SHA-256
 */
export async function sha256(input: string): Promise<string> {
  const encoder = new TextEncoder();
  const data = encoder.encode(input);
  const hashBuffer = await crypto.subtle.digest('SHA-256', data);
  const hashArray = Array.from(new Uint8Array(hashBuffer));
  return hashArray.map((b) => b.toString(16).padStart(2, '0')).join('');
}

/**
 * Validate email format
 */
export function isValidEmail(email: string): boolean {
  const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return re.test(email);
}

/**
 * Validate username (3-30 chars, alphanumeric + underscore)
 */
export function isValidUsername(username: string): boolean {
  const re = /^[a-zA-Z0-9_]{3,30}$/;
  return re.test(username);
}

/**
 * Validate password (min 8 chars, at least 1 letter and 1 number)
 */
export function isValidPassword(password: string): boolean {
  return password.length >= 8 && /[a-zA-Z]/.test(password) && /[0-9]/.test(password);
}

/**
 * Parse pagination params from query string
 */
export function parsePagination(params: URLSearchParams): { page: number; limit: number; offset: number } {
  const page = Math.max(1, parseInt(params.get('page') || '1', 10));
  const limit = Math.min(100, Math.max(1, parseInt(params.get('limit') || '20', 10)));
  const offset = (page - 1) * limit;
  return { page, limit, offset };
}

/**
 * Extract tickers from message text ($AAPL or standalone AAPL)
 */
export function extractTickers(text: string): string[] {
  const matches = text.match(/\$[A-Z]{1,5}\b/g) || [];
  return [...new Set(matches.map((t) => t.replace('$', '')))];
}

/**
 * Build a success API response
 */
export function success<T>(data: T, message?: string) {
  return { success: true, data, message };
}

/**
 * Build an error API response
 */
export function error(message: string, status = 400) {
  return { success: false, error: message, status };
}

/**
 * Calculate percentage change
 */
export function pctChange(current: number, previous: number): number {
  if (previous === 0) return 0;
  return ((current - previous) / previous) * 100;
}

/**
 * Round to N decimal places
 */
export function round(value: number, decimals = 2): number {
  const factor = Math.pow(10, decimals);
  return Math.round(value * factor) / factor;
}
