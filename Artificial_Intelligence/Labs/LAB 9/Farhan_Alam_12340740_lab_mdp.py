"""
Policy Iteration for MDP

This module implements Policy Iteration to solve the given MDP.
States: S1, S2, S3, S4, G (goal)
Actions as specified
Transitions with probabilities
Cost: 2 per transition (reward = -2)
Gamma: 0.9

Algorithm:
- Initialize policy arbitrarily (all a1)
- Repeat until convergence:
  - Policy Evaluation: compute V for current policy
  - Policy Improvement: update policy to greedy w.r.t. V
- Output final policy, V, iterations
"""

import copy

# MDP definition
states = ['S1', 'S2', 'S3', 'S4', 'G']
actions = {
    'S1': ['a1', 'a2'],
    'S2': ['a1', 'a2'],
    'S3': ['a1', 'a2'],
    'S4': ['a1'],
    'G': []
}

# Transitions: state -> action -> list of (next_state, prob)
transitions = {
    'S1': {
        'a1': [('S2', 0.8), ('S3', 0.2)],
        'a2': [('S3', 0.7), ('S4', 0.3)]
    },
    'S2': {
        'a1': [('S1', 0.5), ('S3', 0.4), ('G', 0.1)],
        'a2': [('S3', 0.9), ('S4', 0.1)]
    },
    'S3': {
        'a1': [('S2', 0.6), ('G', 0.4)],
        'a2': [('S4', 1.0)]
    },
    'S4': {
        'a1': [('G', 1.0)]
    },
    'G': {}
}

# Reward: -2 for transitions, 0 at goal
reward = -2
gamma = 0.9

def policy_evaluation(policy, V, theta=1e-6):
    """Policy Evaluation: iterate until V converges for current policy."""
    while True:
        delta = 0
        for s in states:
            if s == 'G':
                continue  # absorbing state, V=0
            v = V[s]
            # V[s] = sum over next states of prob * (reward + gamma * V[next])
            action = policy[s]
            expected_value = 0
            for next_s, prob in transitions[s][action]:
                expected_value += prob * (reward + gamma * V[next_s])
            V[s] = expected_value
            delta = max(delta, abs(v - V[s]))
        if delta < theta:
            break

def policy_improvement(policy, V):
    """Policy Improvement: make policy greedy w.r.t. current V."""
    policy_stable = True
    for s in states:
        if s == 'G':
            continue
        old_action = policy[s]
        # Find action that minimizes expected cost (since reward negative, minimize expected value)
        min_value = float('inf')
        best_action = None
        for a in actions[s]:
            expected_value = 0
            for next_s, prob in transitions[s][a]:
                expected_value += prob * (reward + gamma * V[next_s])
            if expected_value < min_value:
                min_value = expected_value
                best_action = a
        policy[s] = best_action
        if old_action != best_action:
            policy_stable = False
    return policy_stable

def policy_iteration():
    """Main Policy Iteration algorithm."""
    # Initialize policy: all a1
    policy = {s: 'a1' for s in states if s != 'G'}
    policy['G'] = None  # no action

    # Initialize V: 0 for all
    V = {s: 0 for s in states}

    iterations = 0
    while True:
        iterations += 1
        policy_evaluation(policy, V)
        stable = policy_improvement(policy, V)
        if stable:
            break

    return policy, V, iterations

if __name__ == '__main__':
    final_policy, final_V, iters = policy_iteration()
    print("Final Policy:")
    for s in ['S1', 'S2', 'S3', 'S4']:
        print(f"π({s}) = {final_policy[s]}")
    print("\nFinal Value Function:")
    for s in ['S1', 'S2', 'S3', 'S4', 'G']:
        print(f"V({s}) = {final_V[s]:.4f}")
    print(f"\nNumber of iterations: {iters}")
