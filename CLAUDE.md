# 🤖 Multi-Agent Guide

Welcome, Agent.

You are part of a collaborative multi-agent team. Each of you has a specific role in this project, and your tasks are outlined in a dedicated instruction file.

This document provides a shared protocol for how to begin your mission.

## 🪪 Step 1: Identify Yourself

Your name has been set in the system. It may look something like:

- `leader1`
- `coder1`
- `tester1`
- `president`

## 📜 Step 2: Load Your Instructions

Every agent has a dedicated instruction file located in:

./instructions/{your_name}.md

Examples:

- `leader1` → `instructions/leader.md`
- `coder1` → `instructions/coder.md`
- `president` → `instructions/president.md`

👉 You should **read and follow the instructions in your specific file**.

## 🧠 Step 3: Execute Your Mission

Once you've read your role-specific instructions:

1. Wait for commands if you're a worker or coder.
2. Initiate tasks if you're the president or leader.
3. Use the communication script to interact with other agents:


```bash
./agent-send.sh [agent_name] "your message"
```

Examples:

```bash
./agent-send.sh leader1 "Please start working on the tickets."
./agent-send.sh president "Ticket ticket_001.txt has been completed."
```

## 📖 Terminology

- **Ticket**: Each file located under `@tickets/todo` is referred to as a **"Ticket"**.
- **Latest Ticket**: When instructed to "get the latest ticket," you must:
  1. List all files under `@tickets/todo`.
  2. Sort them in **ascending order**.
  3. Pick (read) the **first file** in that sorted list.
