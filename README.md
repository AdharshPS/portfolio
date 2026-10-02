# Adharsh P S — Flutter Developer Portfolio

A responsive, high-performance portfolio web application built with **Flutter Web** and **Dart**. Powered by dynamic JSON content, clean architecture, and automated CI/CD deployment to GitHub Pages.

---

## ⚡ Live URLs

* **Production:** [https://adharshps.github.io/portfolio_new/](https://adharshps.github.io/portfolio_new/)
* **Development:** [https://adharshps.github.io/portfolio_new/dev/](https://adharshps.github.io/portfolio_new/dev/)

---

## 📝 Updating Portfolio Content (No Rebuild Needed)

Content is managed dynamically via [`portfolio.json`](portfolio.json) and fetched live at runtime from GitHub:

```text
https://raw.githubusercontent.com/AdharshPS/portfolio_new/main/portfolio.json
```

* **Instant Updates:** Changes pushed to `portfolio.json` appear on the live site immediately upon refresh without needing to recompile Flutter.
* **Key Sections in `portfolio.json`:**
  * **`profile`**: Name, role, contact links, resume URL (`cv`), and profile picture.
  * **`about`**: Professional summary and career journey.
  * **`stats`**: Quick highlights (`2+` Years experience, `8+` Projects shipped, `20+` Tech & tools).
  * **`skills`**: Categorized technical skills (`Core Flutter`, `Backend & Data`, `Security & Storage`, `Hardware & Integrations`, `Design & AI Tools`, `Delivery & Tools`).
  * **`projects`**: Featured apps with descriptions, tags, GitHub links, and deployment URLs.
  * **`experience`**: Career timeline, companies, roles, and key achievements.
  * **`education` & `testimonials`**: Academic qualifications and client/team recommendations.

---

## 🚀 CI/CD & Deployment Workflow

Deployments to GitHub Pages are automated via GitHub Actions ([`.github/workflows/deploy.yml`](.github/workflows/deploy.yml)).

### ⚠️ Trigger Condition: Version / Build Number Change Only
To save build time and avoid unnecessary pipeline runs, **CI/CD will only trigger when the version or build number in [`pubspec.yaml`](pubspec.yaml) is updated**. Regular code or asset pushes without a version bump will not trigger a deployment.

```yaml
# In pubspec.yaml:
version: 1.0.1+2   # Increment the build number (e.g. +3) or version to trigger CI/CD
```

### Branches & Environments

| Environment | Branch | Live Path | Deployment Trigger |
| :--- | :--- | :--- | :--- |
| **Development** | `dev` | `/portfolio_new/dev/` | Push to `dev` with an updated version/build number |
| **Production** | `main` | `/portfolio_new/` | Push/merge to `main` with an updated version/build number |

#### How to Deploy:

**1. Deploy to Development (`dev`):**
```bash
git checkout dev
# Bump version or build number in pubspec.yaml (e.g., 1.0.1+3)
git add .
git commit -m "feat: new updates"
git push origin dev
```

**2. Deploy to Production (`main`):**
```bash
git checkout main
git merge dev
# Ensure pubspec.yaml has the updated version/build number
git push origin main
```

---

## 💻 Local Development

### Requirements
* **Flutter SDK:** `3.47.5` (channel stable)
* **Dart SDK:** `^3.13.4`

### Commands
```bash
# Get dependencies
flutter pub get

# Run on Chrome
flutter run -d chrome

# Run tests
flutter test

# Build for Web
flutter build web --release --base-href="/portfolio_new/"
```
