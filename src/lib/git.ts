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
        // 排除 flake.lock 文件，因为它会因 flake update 而自动变化
        // 使用 pathspec :!flake.lock 来排除特定文件
        const diff = execSync("git diff --cached -- . ':!flake.lock'").toString();
        return diff.trim().length > 0 ? diff : null;
    } catch (error) {
        console.error('Error getting git diff:', error);
        return null;
    }
}
