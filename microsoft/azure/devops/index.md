# Microsoft software engineering devops improvements

The Microsoft Learn MCP is rate-limiting right now. Let me retry with spaced-out requests.Still rate-limited. Let me fetch the key docs directly — I know the URLs for Microsoft's code quality guidance.Now let me get the Blazor and ASP.NET security guidance:Got rate-limited on those two, but we got the main .NET code analysis doc. Here's a summary of what's relevant for your PR code quality setup:

---

**Key .NET 8 Code Analysis Settings for PRs**

For your `.csproj`, enable stricter analysis:

```xml
<PropertyGroup>
  <AnalysisLevel>8.0-Recommended</AnalysisLevel>
  <EnforceCodeStyleInBuild>true</EnforceCodeStyleInBuild>
  <TreatWarningsAsErrors>true</TreatWarningsAsErrors>
  <CodeAnalysisTreatWarningsAsErrors>false</CodeAnalysisTreatWarningsAsErrors>
</PropertyGroup>
```

This enables the `Recommended` ruleset (more rules than default) while keeping code analysis warnings from breaking the build outright — useful for a gradual adoption path.

**Recommended `.editorconfig` additions for PR quality gates:**

```ini
[*.{cs,vb}]
# Enforce accessibility modifiers
dotnet_style_require_accessibility_modifiers = always:warning

# Enforce style rules at build time
dotnet_analyzer_diagnostic.category-Style.severity = warning

# Key CA rules to escalate for PRs
dotnet_diagnostic.CA1822.severity = warning  # Mark members as static
dotnet_diagnostic.CA1848.severity = warning  # Use LoggerMessage delegates
dotnet_diagnostic.CA2007.severity = warning  # ConfigureAwait
dotnet_diagnostic.CA1062.severity = warning  # Validate arguments of public methods
```

**Recommended third-party analyzers** (from the docs) to add via NuGet for deeper PR checks:

- `Meziantou.Analyzer` — catches common .NET pitfalls (great for Blazor/ASP.NET)
- `Roslynator.Analyzers` — broad code quality coverage
- `SonarAnalyzer.CSharp` — security and reliability rules
- `xunit.analyzers` — if you're using xUnit for testing

**For CI/PR pipelines**, you'd run `dotnet build` with these settings active so analyzer violations fail the PR check. In Azure DevOps or GitHub Actions, this means the standard `dotnet build` task will report CA/IDE warnings as build output, and `TreatWarningsAsErrors` controls whether they block the merge.

Want me to put together a complete `.editorconfig` and `Directory.Build.props` file tuned for your stack (Blazor, ASP.NET, EF Core + Postgres)?


###


Great question — you're referring to **Roslyn**, the .NET Compiler Platform. Here's a full breakdown:

---

## What is Roslyn?

.NET Compiler Platform (Roslyn) analyzers inspect your C# or Visual Basic code for style, quality, maintainability, design, and other issues. This inspection happens during design time in all open files — you can also configure analyzers to inspect code at build time and as you type.

Because these analyzers are powered by the .NET Compiler Platform, they can produce warnings in your code as you type, even before you've finished the line — no more waiting to build your code to discover issues.

---

## 🔧 Two Types of Built-in Rules

**IDE rules** (e.g. `IDE0001`) are built into Visual Studio and configurable via EditorConfig. **CA rules** (e.g. `CA1822`) are included with the .NET 5.0+ SDK and enabled by default — these cover code quality analysis.

---

## 📦 Key NuGet Analyzer Packages

These install into your project and run during builds and CI:

**Roslynator** — A collection of 500+ analyzers, refactorings and fixes for C#, powered by Roslyn, available as both a VS Code extension and NuGet package.

**StyleCop.Analyzers** — An implementation of StyleCop's rules using Roslyn analyzers, downloaded 21M+ times. Enforces consistent code style.

**SonarAnalyzer.CSharp** — The Sonar Roslyn analyzers that power SonarLint, published as a NuGet package.

**SecurityCodeScan** — A vulnerability patterns detector for C# and VB.NET.

**ErrorProne.NET** — A set of Roslyn-based analyzers focusing on correctness and performance of C# programs, similar in philosophy to Google's error-prone.

**AsyncFixer** — Advanced async/await diagnostics and code fixes for C#. Great for catching misused async patterns.

---

## ⚙️ Configuring Severity

Each Roslyn analyzer rule has a default severity and suppression state that you can customise for your project. Severity levels include: **Error**, **Warning**, **Suggestion**, **Silent**, **None**, and **Default**. You control these via an `.editorconfig` file checked into your repo.

---

## 🔗 Connecting to Azure DevOps CI

Roslyn analyzers can be deployed through NuGet, which aligns well to the continuous integration workflow — a NuGet restore is all that's required before a build to ensure the package is available to the project. This means they run automatically in your Azure DevOps pipelines and can **fail builds** on violations.

---

## Recommended Stack for .NET Teams

| Layer | Tool |
|---|---|
| In the editor | Roslynator + SonarQube for IDE |
| Style enforcement | StyleCop.Analyzers |
| Security | SecurityCodeScan |
| Async quality | AsyncFixer |
| CI / PR gate | `.editorconfig` + `EnableNETAnalyzers=true` in your `.csproj` |

This gives you issues caught as you type, enforced at build, and blocked at the PR — covering all three stages.

