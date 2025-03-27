# 📄 `sed` Command Documentation: Makefile Template Generator

## 🔧 Command
```bash
sed "s/{{PACKAGE_NAME}}/assets/g" path/to/sange/templates/makefile.template > path/to/project-root/Makefile
```

## 🧠 What This Command Does

This command takes a reusable `Makefile` template and replaces a placeholder (`{{PACKAGE_NAME}}`) with your actual package name (`assets`), then writes the result to your project directory as a real `Makefile`.

## 🧩 Breakdown

| Segment | Purpose |
|--------|---------|
| `sed` | Stream editor for parsing and transforming text |
| `"s/{{PACKAGE_NAME}}/assets/g"` | Substitution command:<br>**s** → substitute<br>**{{PACKAGE_NAME}}** → the placeholder to find<br>**assets** → the actual project/package name<br>**g** → global (replace all occurrences) |
| `path/to/sange/templates/makefile.template` | The source template file |
| `>` | Redirects the result into a new file |
| `path/to/project-root/Makefile` | The destination where the new Makefile is saved (top-level of your package) |

## ✅ Example

```bash
cd packages/frontend
sed "s/{{PACKAGE_NAME}}/frontend/g" ../../__dev/sange/templates/makefile.template > Makefile
```

- Replaces all `{{PACKAGE_NAME}}` in the template with `frontend`
- Creates a new `Makefile` directly in the `frontend` package root (no nesting)

## 📝 Use Case

- Scaffolding Makefiles across multiple packages in a monorepo
- Promotes DRY config with centralized templating
- Ensures consistency across all `Makefile`s
