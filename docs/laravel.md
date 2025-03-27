# ⚙️ Laravel Stack

This section outlines all Laravel-related automation commands provided by the **Sange** toolkit.

These commands are defined in:

```
src/makefiles/laravel.mk
```

---

## ✅ Laravel Commands

| Command                   | Description                                  |
|---------------------------|----------------------------------------------|
| `make artisan`            | Run a custom Artisan command via `FLAGS=`    |
| `make laravel_migrate`    | Run database migrations                      |
| `make laravel_seed`       | Seed the database                            |
| `make laravel_key`        | Generate application key                     |
| `make laravel_test`       | Run test suite                               |
| `make laravel_optimize`   | Optimize framework loading                   |
| `make laravel_storage_link` | Create symbolic link to storage directory   |
| `make laravel_cache_clear` | Clear route, config, and view caches        |

---

## 🛠️ Usage Example

```bash
# Run migrations
make laravel_migrate

# Run custom Artisan command
make artisan FLAGS="tinker"
```

---

These commands rely on Laravel being properly configured in the working project.
