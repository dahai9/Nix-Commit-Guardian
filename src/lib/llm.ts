import OpenAI from 'openai';
import { SuggestionSchema, type Suggestion } from './schema';
import { z } from 'zod';
import { CONFIG } from './config';

console.log(`🔌 连接到 llmlite: ${CONFIG.LLMLITE_BASE_URL}`);

const client = new OpenAI({
    baseURL: CONFIG.LLMLITE_BASE_URL,
    apiKey: CONFIG.API_KEY
});

export async function generateCommitSuggestion(diff: string): Promise<Suggestion> {
    const prompt = `${CONFIG.SYSTEM_PROMPT}

Git diff:
${diff}`;

    try {
        const response = await client.chat.completions.create({
            model: CONFIG.MODEL,
            max_tokens: 1024,
            messages: [
                {
                    role: 'user',
                    content: prompt
                }
            ]
        });

        const responseText = response.choices[0].message.content;
        if (!responseText) {
            throw new Error('Empty response from OpenAI');
        }

        // Robust JSON parsing: strip Markdown code blocks if present
        const jsonString = responseText.replace(/```json\n|\n```/g, '').replace(/```/g, '').trim();

        const parsedResponse = JSON.parse(jsonString);
        return SuggestionSchema.parse(parsedResponse);

    } catch (error) {
        if (error instanceof Error) {
            // Enhance error message for common issues
            if (error.message.includes('ECONNREFUSED')) {
                throw new Error(`Connection refused to ${CONFIG.LLMLITE_BASE_URL}. Is the service running?`);
            }
        }
        throw error;
    }
}
