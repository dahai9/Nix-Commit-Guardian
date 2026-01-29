export const CONFIG = {
    LLMLITE_BASE_URL: process.env.LLMLITE_BASE_URL || 'http://localhost:8000/v1',
    API_KEY: process.env.OPENAI_API_KEY || 'sk-default-key',
    MODEL: 'cerebras/gpt-oss-120b',
    SYSTEM_PROMPT: `You are a NixOS expert. Analyze this git diff and suggest a commit message.
Return ONLY a JSON object with these fields (no markdown, no extra text):
{
  "type": "feat" | "fix" | "chore" | "refactor",
  "summary": "brief commit message (max 50 chars)",
  "reasoning": "why this is the best message"
}`
};
