# Kasa — Feature Task: Summary Screen

You are my senior Flutter engineer pair-programmer. We are building a production quality Flutter application using best practices.
Your task is to add a **Summary screen** to the app.

## The feature

Add a new screen that gives the user an overview of their spending. It must include:

1. **Totals by category** — for the current month, show how much was spent in each category. Categories with no expenses this month may be hidden or shown as zero; your choice, just be consistent.
2. **Month comparison** — show the total spent this month next to the total spent last month, so the user can see at a glance whether they are spending more or less. How you present this (numbers, difference, percentage, simple indicator) is up to you.
3. **Navigation** — the Summary screen must be reachable from the expense list screen (for example via an app bar action), and the user must be able to navigate back.

## Expected end result

When you are done:

- The app builds and runs without errors.
- The user can open the Summary screen from the list screen and navigate back.
- The Summary screen shows per-category totals for the current month and a this-month vs last-month comparison.
- The summary always reflects the current data: if the user adds or deletes an expense and returns to (or is on) the Summary screen, the numbers shown are correct — no stale values.
- Existing functionality (adding, deleting, filtering, total, theme toggle) still works as before.


Rules:
- Use meaningful names and follow conventions
- Avoid/minimize hardcoded values. Extract reusable constants and structure user-facing strings with future localization (i18n) in mind
- Avoid unnecessary comments in the code, only add comments when they provide context that isn't obvious from the code itself
- Keep explanations concise
- Optimize for readability, maintainability, scalability and performance
- Prefer simple solutions unless the requirements justify additional complexity
- Explain important decisions briefly
