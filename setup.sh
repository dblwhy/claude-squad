#!/bin/bash
set -e

CONFIG_FILE="agents.yaml"
REQUIRED_KEYS=("multiagent.panes" "multiagent.window_name")
YQ_BIN=$(command -v yq)

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "❌ Missing config file: $CONFIG_FILE"
    exit 1
fi

if [[ -z "$YQ_BIN" ]]; then
    echo "❌ Please install 'yq' to parse YAML. (https://github.com/mikefarah/yq)"
    exit 1
fi

log() {
    echo "\033[1;32m[INFO]\033[0m $1"
}

log_success() {
    echo "\033[1;34m[SUCCESS]\033[0m $1"
}

echo "🤖 Setting up Multi-Agent Communication"
echo "==========================================="

# Cleanup
log "Cleaning up existing tmux sessions..."
tmux kill-session -t multiagent 2>/dev/null || true
tmux kill-session -t president 2>/dev/null || true
mkdir -p tmp

# President session (if enabled)
if [[ "$($YQ_BIN '.president.enabled' "$CONFIG_FILE")" == "true" ]]; then
    log "Creating president session..."
    tmux new-session -d -s president
    tmux send-keys -t president "cd $(pwd)" C-m
    tmux send-keys -t president "echo '=== PRESIDENT ==='" C-m
    log_success "President session ready"
fi

# Multiagent session
log "Creating multiagent session..."
AGENT_WINDOW=$($YQ_BIN '.multiagent.window_name' "$CONFIG_FILE")
AGENT_NAMES=($($YQ_BIN '.multiagent.panes[].name' "$CONFIG_FILE"))

tmux new-session -d -s multiagent -n "$AGENT_WINDOW"

# Create pane layout
tmux split-window -h -t "multiagent:$AGENT_WINDOW"
tmux select-pane -t "multiagent:$AGENT_WINDOW".0
tmux split-window -v
tmux select-pane -t "multiagent:$AGENT_WINDOW".1
tmux split-window -v

# Assign names and init
PANE_IDS=($(tmux list-panes -t "multiagent:$AGENT_WINDOW" -F "#{pane_id}" | sort))
for i in "${!AGENT_NAMES[@]}"; do
    pane_id="${PANE_IDS[$i]}"
    name="${AGENT_NAMES[$i]}"

    tmux select-pane -t "$pane_id" -T "$name"
    tmux send-keys -t "$pane_id" "cd $(pwd)" C-m
    tmux send-keys -t "$pane_id" "echo '=== $name agent ==='" C-m
done

log_success "Multiagent session created with agents: ${AGENT_NAMES[*]}"

echo ""
log_success "✅ Setup complete!"

log "Starting agents..."

if [[ "$($YQ_BIN '.president.enabled' "$CONFIG_FILE")" == "true" ]]; then
    instruction=$($YQ_BIN '.president.instruction' "$CONFIG_FILE")
    tmux send-keys -t president "claude \"follow the instruction in $instruction_path\"" C-m
fi
for i in "${!AGENT_NAMES[@]}"; do
    pane_id="${PANE_IDS[$i]}"
    name="${AGENT_NAMES[$i]}"
    instruction_path=$($YQ_BIN ".multiagent.panes[$i].instruction" "$CONFIG_FILE")

    tmux send-keys -t "$pane_id" "claude \"follow the instruction in $instruction_path\"" C-m
done

echo ""
echo "🎉 Agent setup complete! Your multi-agent team is ready to roll."
echo "You can say hello to them:"
echo ""
echo "💬 Example:"
echo "  sh agent-send.sh leader1 \"Hello Leader!\"" # leader1 is the agent name specified in agents.yaml
echo "  sh agent-send.sh coder1 \"Hello coder1!\"" # coder1 is the agent name specified in agents.yaml
echo ""
echo "🖥️ To open the agent console, run this in another terminal window:"
echo "  tmux attach-session -t multiagent"
echo ""
