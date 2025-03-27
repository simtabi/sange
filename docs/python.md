# 🐍 Python Stack (Optional)

This is an example of how you can extend the **Sange** toolkit to support Python-related automation using Makefiles.

You can define custom commands in a new stack file like:

```
src/makefiles/python.mk
```

---

## 🐍 Sample Python Commands

| Command               | Description                          |
|-----------------------|--------------------------------------|
| `make python_install` | Install Python dependencies          |
| `make python_run`     | Run your main Python script          |
| `make python_lint`    | Lint Python files using flake8       |
| `make python_test`    | Run tests using pytest               |

---

## 🛠️ Example Stack Definition (`python.mk`)

```makefile
.PHONY: python_install python_run python_lint python_test

python_install:
	@pip install -r requirements.txt

python_run:
	@python main.py

python_lint:
	@flake8 .

python_test:
	@pytest
```

Include this stack in your master Makefile:

```makefile
include $(dir $(lastword $(MAKEFILE_LIST)))stacks/python.mk
```

Now you can run:
```bash
make python_install
make python_run
```

---

This is entirely optional and only relevant for Python-based projects.
