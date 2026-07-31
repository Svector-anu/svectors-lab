.matches | map({id: .id, title: .title, reward: .rewardUsd, seen_at: $now})
