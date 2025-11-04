import heapq

class PuzzleState:
    def __init__(self, board, g, parent=None):
        self.board = board                  # List of 9 elements (0 = blank)
        self.g = g                          # Cost so far
        self.h = self.manhattan_distance()  # Heuristic
        self.f = self.g + self.h
        self.parent = parent

    def manhattan_distance(self):
        """Calculate Manhattan distance heuristic."""
        distance = 0
        for idx, value in enumerate(self.board):
            if value != 0:  # Ignore blank
                goal_row, goal_col = divmod(value - 1, 3)
                curr_row, curr_col = divmod(idx, 3)
                distance += abs(goal_row - curr_row) + abs(goal_col - curr_col)
        return distance

    def get_neighbors(self):
        """Generate neighbors by sliding tiles."""
        neighbors = []
        zero_index = self.board.index(0)
        zero_row, zero_col = divmod(zero_index, 3)

        # Possible moves: up, down, left, right
        moves = [(-1, 0), (1, 0), (0, -1), (0, 1)]
        for dr, dc in moves:
            new_row, new_col = zero_row + dr, zero_col + dc
            if 0 <= new_row < 3 and 0 <= new_col < 3:
                new_index = new_row * 3 + new_col
                new_board = self.board[:]
                new_board[zero_index], new_board[new_index] = new_board[new_index], new_board[zero_index]
                neighbors.append(PuzzleState(new_board, self.g + 1, self))
        return neighbors

    def __lt__(self, other):
        """Priority Queue uses this for comparison."""
        return self.f < other.f

    def __eq__(self, other):
        return self.board == other.board

    def __hash__(self):
        return hash(tuple(self.board))


def reconstruct_path(state):
    """Backtrack to get the solution path."""
    path = []
    while state:
        path.append(state.board)
        state = state.parent
    return path[::-1]


def a_star(start_board, goal_board):
    start_state = PuzzleState(start_board, 0)
    goal_state = tuple(goal_board)

    open_set = []
    heapq.heappush(open_set, start_state)
    closed_set = set()

    while open_set:
        current = heapq.heappop(open_set)

        if tuple(current.board) == goal_state:
            return reconstruct_path(current)

        closed_set.add(tuple(current.board))

        for neighbor in current.get_neighbors():
            if tuple(neighbor.board) in closed_set:
                continue
            heapq.heappush(open_set, neighbor)

    return None  # No solution


if __name__ == "__main__":
    # Example input
    start = [1, 2, 3,
             4, 0, 6,
             7, 5, 8]  # 0 is the blank

    goal = [1, 2, 3,
            4, 5, 6,
            7, 8, 0]

    solution = a_star(start, goal)
    if solution:
        print(f"Solution found in {len(solution) - 1} moves:")
        for step in solution:
            print(step[0:3])
            print(step[3:6])
            print(step[6:9])
            print()
    else:
        print("No solution found.")