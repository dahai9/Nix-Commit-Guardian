import { execSync } from 'child_process';

export function isGitRepository(): boolean {
    try {
        execSync('git rev-parse --is-inside-work-tree', { stdio: 'ignore' });
        return true;
    } catch {
        return false;
    }
}

export function getStagedDiff(): string | null {
    try {
        const diff = execSync('git diff --cached').toString();
        return diff.trim().length > 0 ? diff : null;
    } catch (error) {
        console.error('Error getting git diff:', error);
        return null;
    }
}
