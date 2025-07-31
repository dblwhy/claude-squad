# 🤖 claude-squad

**claude-squad** is a terminal-based multi-agent system where Claude agents collaborate to complete markdown-defined tasks (called "tickets"). Each agent runs in a separate tmux pane, follows role-specific instructions, and communicates using natural language through a message-sending CLI.

---

## ✨ Features

- 🧠 Multi-agent coordination using Claude in each pane
- 📄 Ticket-based task system powered by Markdown
- ⚙️ YAML-based agent configuration
- 🖥️ Pane orchestration via `tmux`
- 📬 Inter-agent messaging via CLI
- 🪪 Role-based behavior: president, leader, coder, tester, etc.

---

## 📦 Setup

### 1. Install dependencies

Ensure you have the following installed:

```bash
brew install tmux yq # macOS
```

### 2. Clone the repo

```bash
git clone https://github.com/your-username/claude-squad.git
cd claude-squad
```

### 3. Define your agents
Edit agents.yaml to define agent roles, names, and instruction files:

```yaml
president:
  enabled: true
  instruction: instructions/president.md

multiagent:
  window_name: agents
  panes:
    - name: leader1
      instruction: instructions/leader.md
    - name: coder1
      instruction: instructions/coder.md
    - name: coder2
      instruction: instructions/coder.md
```

## 🚀 Run the system
```bash
./setup.sh
```

This will:
- Clean up any old multiagent sessions
- Launch a multiagent tmux session
- Launch a president session (if enabled)
- Assign titles and instructions to each pane
- Start Claude in each pane with the correct prompt

## 🧠 How It Works

Each agent:

- Loads its identity and task from agents.yaml
- Follows instructions in instructions/{agent}.md
- Uses ./agent-send.sh or ./test.sh to message other agents

Tickets live under:

```bash
tickets/
├── reference/ # Images or whatever you want reference in the ticket
├── todo/    # Incoming tasks
└── done/    # Completed tasks
```

## 💬 Example: Send a message
```bash
./test.sh coder1 "Please start working on ticket_001.txt"
```

```bash
./agent-send.sh leader1 "ticket ticket_001.txt completed"
```

## ✅ Best Practices

- Keep ticket file names sortable (e.g., 001_ticket.md, 0002_ticket.md)
- Keep roles focused on responsibilities

## 🪐 Origin

This project is a fork of [Claude-Code-Communication](https://github.com/nishimoto265/Claude-Code-Communication), adapted and expanded into a Claude-based multi-agent coordination system.

## 📜 License
MIT License. Use, remix, and extend freely.

## 👥 Contributing
Pull requests are welcome! If you have ideas for plugins, visual dashboards, or alternate AI backends, feel free to open an issue or PR.

## 🙌 Credits
Built with ❤️ by humans, orchestrated by Claude.
