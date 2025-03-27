# 🔗 Git Stack

This section documents all Git-related automation commands provided by the **Sange** toolkit.

These commands are included via the Git Makefile modules:

```
src/makefiles/git/git_config.mk
src/makefiles/git/git_safe.mk
src/makefiles/git/git_danger.mk
```

---

## ✅ Safe Git Commands

| Command              | Description                             |
|----------------------|-----------------------------------------|
| `make git_status`    | Show current repo status                |
| `make git_add`       | Stage all modified/untracked files      |
| `make git_commit`    | Interactively prompt for commit message |
| `make git_log`       | Show Git log history                    |
| `make git_diff`      | Show changes between commits or files   |

---

## ⚠️ Destructive Git Commands

| Command               | Description                            |
|-----------------------|----------------------------------------|
| `make git_reset_hard` | Discard all changes (DANGER!)          |
| `make git_clean`      | Remove untracked files                 |
| `make git_revert`     | Revert the last commit                 |

---

## 🔧 Customization

You can override Git configuration per project using your Makefile:

```makefile
GIT_REPO := $(CURDIR)
GIT_BRANCH := main
DEFAULT_COMMIT_MESSAGE := 📦 chore(my-app): routine update
```

These values are referenced by all Git-related commands inside Sange.

---

## 💬 Interactive Commit Prompt

Running:

```bash
make git_commit
```

Will:
- Check if there are staged changes
- Prompt the user for a message
- Fall back to the `DEFAULT_COMMIT_MESSAGE` if left blank

---

## 🌐 Remote Utilities

The toolkit also includes helpers for managing remotes:

```bash
make git_remote_get     # Show current Git remote
make git_remote_set     # Prompt to set or update the Git remote
make git_init           # Initialize repo if not already
```

These are powered by logic in:

```
src/scripts/all/git.sh
```

---

This stack is safe to use across all projects and can be extended or customized as needed.
