import { z } from 'zod';

export const SuggestionSchema = z.object({
    type: z.enum(['feat', 'fix', 'chore', 'refactor']),
    summary: z.string().max(50),
    reasoning: z.string()
});

export type Suggestion = z.infer<typeof SuggestionSchema>;
