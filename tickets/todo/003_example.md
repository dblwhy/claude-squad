# 3: Implement ChatGPT-like UI

Build a Chat interface within the `dashboard` project that mimics the look and feel of ChatGPT, focusing on layout and interaction — not the backend logic (which will be handled separately).

> 📌 This ticket focuses on the **UI only** — no backend or AI integration is required.

## Requirements

1. Create a chat interface directly at the `/` route (home page).
   - Please refer `@tickets/reference/screenshot-chatgpt-ui.jpg` for layout and styling inspiration:
2. Implement the following UI elements:
   - Message input box fixed at the bottom
   - Scrollable chat history above the input
   - Left/right alignment for user vs agent messages
   - Optional: “loading” message bubble placeholder
3. Ensure mobile responsiveness and keyboard accessibility

## Ticket Dependency

- This ticket is blocked by 001_example.md.

## Acceptance Criteria:

A functional, styled ChatGPT-like UI on the home page that is ready to integrate with a backend model in a future ticket.
