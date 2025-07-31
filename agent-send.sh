#!/bin/bash
CONFIG_FILE="agents.yaml"
YQ_BIN=$(command -v yq)

if [[ -z "$YQ_BIN" || ! -f "$CONFIG_FILE" ]]; then
    echo "❌ Please install 'yq' and ensure agents.yaml exists"
    exit 1
fi

get_agent_target() {
    local agent="$1"
    local window_name=$($YQ_BIN '.multiagent.window_name' "$CONFIG_FILE")
    local names=($($YQ_BIN '.multiagent.panes[].name' "$CONFIG_FILE"))
    for i in "${!names[@]}"; do
        [[ "${names[$i]}" == "$agent" ]] && echo "multiagent:$window_name.$i" && return
    done
    [[ "$agent" == "president" ]] && echo "president" && return
    echo ""
}

send_message() {
    local target="$1"
    local message="$2"
    tmux send-keys -t "$target" C-c
    sleep 0.2
    tmux send-keys -t "$target" "$message"
    sleep 0.2
    tmux send-keys -t "$target" C-m
}

show_agents() {
    echo "📋 Available agents:"
    if tmux has-session -t president 2>/dev/null; then
        echo "  president → president"
    fi
    local window=$($YQ_BIN '.multiagent.window_name' "$CONFIG_FILE")
    local names=($($YQ_BIN '.multiagent.panes[].name' "$CONFIG_FILE"))
    for i in "${!names[@]}"; do
        echo "  ${names[$i]} → multiagent:$window.$i"
    done
}

main() {
    if [[ "$1" == "--list" ]]; then
        show_agents
        exit 0
    fi

    if [[ $# -lt 2 ]]; then
        echo "Usage: $0 [agent_name] [message]"
        echo "       $0 --list"
        exit 1
    fi

    local agent="$1"
    local message="$2"
    local target
    target=$(get_agent_target "$agent")

    if [[ -z "$target" ]]; then
        echo "❌ Unknown agent: $agent"
        exit 1
    fi

    if ! tmux has-session -t "${target%%:*}" 2>/dev/null; then
        echo "❌ Session not running: ${target%%:*}"
        exit 1
    fi

    send_message "$target" "$message"
    echo "✅ Sent '$message' to $agent"
}

main "$@"
