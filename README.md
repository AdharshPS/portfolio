# Adharsh P S — Developer Portfolio

A modern, responsive, and high-performance developer portfolio web application built with **Flutter Web** and **Dart**. Designed with clean architecture, dynamic remote content configuration via JSON, dual DEV/PROD CI/CD pipelines, and fluid responsive design across mobile, tablet, and desktop viewports.

---

## 📌 Environment & Versions

| Tool | Version | Notes |
| :--- | :--- | :--- |
| **Flutter** | `3.38.5` (CI/CD) / `3.x` Stable | Specified in `.github/workflows/deploy.yml` |
| **Dart SDK** | `^3.8.1` (`>=3.8.1 <4.0.0`) | Specified in `pubspec.yaml` environment SDK |
| **Channel** | `stable` | Recommended for all production builds |

---

## 🚀 How to Update Portfolio Content

The portfolio content is decoupled from the UI code and managed dynamically via [portfolio.json](file:///c:/Users/adhar/Desktop/Flutter/portfolio_new/portfolio.json).

### 1. Dynamic Live Updates (No Rebuild Required)
The web application fetches the latest data at runtime directly from the public GitHub repository:
```
https://raw.githubusercontent.com/AdharshPS/portfolio_new/main/portfolio.json
```
- **Instant Changes:** When you edit [portfolio.json](file:///c:/Users/adhar/Desktop/Flutter/portfolio_new/portfolio.json) and push to `main`, visitors receive the updated content immediately upon reloading (cached with local storage fallback).
- **Fast CI/CD:** Changes to `portfolio.json` **do not** trigger a Flutter build or deployment pipeline run because `.github/workflows/deploy.yml` has `paths-ignore: - 'portfolio.json'`.

### 2. Content Structure Overview
Open [portfolio.json](file:///c:/Users/adhar/Desktop/Flutter/portfolio_new/portfolio.json) in your editor. You can update any of the following blocks:

- **`profile`**:
  - `name`, `role`, `tagline`, `headlineGreeting`
  - `email`, `phone`, `location`, `github`, `linkedin`
  - `cv`: Set `fileName` and `downloadUrl` (e.g. direct Google Drive download link)
  - `avatarImage`: Path to local asset (`assets/images/me.png`) or remote image URL
- **`about`**:
  - `intro`: Elevator pitch and summary
  - `journey`: Detailed background, career transition, and experience
- **`stats`**:
  - Array of key highlights (e.g. `[{"value": "1.5+", "label": "Years experience"}]`)
- **`skills`**:
  - Grouped categories (`Core Flutter`, `Backend & Data`, `Security & Storage`, `Delivery & Tools`) containing lists of skill tags
- **`projects`**:
  - Each item contains `title`, `description`, `type` (e.g. `"Open Source"`), `tags`, `github`, `thumbnail`, `accentColor`, and `deploy` links (`web`, `playstore`, `appstore`, `apk`)
- **`experience`**:
  - Work history entries with `role`, `company`, `period`, and bullet `points`
- **`testimonials`**:
  - Feedback entries with `quote`, `name`, and `role`
- **`seoAndMeta`**:
  - `siteTitle`, `metaDescription`, `canonicalUrl`, and theme colors

### 3. Adding New Images
1. Save your image into `assets/images/` or `assets/images/projects/`.
2. Reference the path in [portfolio.json](file:///c:/Users/adhar/Desktop/Flutter/portfolio_new/portfolio.json) (or provide an external `https://` URL).
3. If adding a new asset file, commit and push to trigger a deployment so the asset bundle is updated.

---

## 🔄 CI/CD & Automated Deployment

Deployment is fully automated using **GitHub Actions** defined in [.github/workflows/deploy.yml](file:///c:/Users/adhar/Desktop/Flutter/portfolio_new/.github/workflows/deploy.yml).

### Trigger Keyword in CI/CD: `push`
The workflow is triggered automatically on **`push`** to specific target branches and release tags:

```yaml
on:
  push:
    branches:
      - dev
      - main
    tags:
      - 'v*.*.*'
    paths-ignore:
      - 'portfolio.json'
```

### Environments & Deployment Commands

| Environment | Target Branch / Tag | Trigger Command | Base URL | GitHub Pages Destination |
| :--- | :--- | :--- | :--- | :--- |
| **Development** | `dev` | `git push origin dev` | `/portfolio_new/dev/` | `gh-pages` branch (`dev/` directory) |
| **Production** | `main` or `v*.*.*` tag | `git push origin main` or `git push origin v1.0.1` | `/portfolio_new/` | `gh-pages` branch (root `/`) |

#### Step-by-Step Push Examples

**Deploying to Development (`dev`):**
```bash
git checkout dev
git add .
git commit -m "Your dev changes"
git push origin dev
```
> The `deploy-dev` job compiles with `--dart-define=ENV=dev` and deploys to `https://<username>.github.io/<repo>/dev/`.

**Deploying to Production (`main`):**
```bash
git checkout main
git merge dev      # Or merge via Pull Request on GitHub
git push origin main
```
> The `deploy-prod` job compiles with `--dart-define=ENV=prod` and deploys to `https://<username>.github.io/<repo>/`.

#### Pushing with Tags (Release Tags)
Release tags (`v*.*.*`) automatically trigger the production deployment (`deploy-prod`) pipeline:
```bash
git tag v1.0.1
git push origin v1.0.1
```

### Automatic Cache Invalidation
The CI/CD pipeline injects the unique GitHub run number during the build:
```bash
--dart-define=BUILD_VERSION=${{ github.run_number }}
```
When visitors load the web app, it checks `BUILD_VERSION` against `localStorage`. If a new version is detected, it automatically refreshes the browser window to purge stale cached scripts.

---

## 💻 Local Development

### Prerequisites
- Flutter SDK `3.38.5` or later
- Dart SDK `^3.8.1`
- Google Chrome (for web debugging)

### Commands
```bash
# Clone the repository
git clone https://github.com/AdharshPS/portfolio_new.git
cd portfolio_new

# Install dependencies
flutter pub get

# Run on Chrome locally
flutter run -d chrome

# Run with custom environment define
flutter run -d chrome --dart-define=ENV=dev

# Run tests
flutter test

# Build for Web manually
flutter build web --release --base-href="/portfolio_new/"
```
