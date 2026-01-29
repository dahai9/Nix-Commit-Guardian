import { isGitRepository, getStagedDiff } from './lib/git';
import { generateCommitSuggestion } from './lib/llm';
import { z } from 'zod';

async function main() {
  if (!isGitRepository()) {
    console.error("❌ Error: Current directory is not a git repository.");
    process.exit(1);
  }

  // 2. 获取 Diff
  const diff = getStagedDiff();

  if (!diff) {
    console.log("No staged changes found. Go edit some nix files!");
    return;
  }

  console.log("📝 分析 git diff 中...");
  console.log("---");
  console.log(diff.substring(0, 200) + "...");
  console.log("---");

  try {
    // 4. 调用 OpenAI API via Helper
    const validated = await generateCommitSuggestion(diff);

    console.log("🤖 LLM 回复:");
    console.log("\n✅ 验证通过!");
    console.log(`类型: ${validated.type}`);
    console.log(`提交信息: ${validated.summary}`);
    console.log(`理由: ${validated.reasoning}`);

  } catch (error) {
    if (error instanceof z.ZodError) {
      console.error("❌ 验证失败:", error.errors);
    } else if (error instanceof SyntaxError) {
      console.error("❌ JSON 解析失败:", error.message);
    } else if (error instanceof Error) {
      console.error("❌ Error:", error.message);
    } else {
      console.error("❌ 未知错误:", error);
    }
    process.exit(1);
  }
}

main();