#import "@preview/academic-alt:0.1.0": *

#show: university-assignment.with(
  title: "Assignment 3",
  subtitle: "COS3751",
  author: "50052578 Jones GWE",
  details: (
    course: "COS3751",
    due-date: "11 September 2026",
  )
)

#show heading.where(level: 3): set heading(numbering: none)

= Question 1

== 1. The 8-puzzle

*a)* Let $square$ denote the blank.  Using rows from top to bottom, the initial
state and goal state are respectively

$ S_0 = mat(2, 8, 3; 1, 6, 4; 7, square, 5) $

$ G = mat(1, 2, 3; 4, 5, 6; 7, 8, square) $

This representation specifies the location of every tile (including the blank), as
in the standard problem formulation @russell2021aima[Sec. 3.2.1].

*b)* The blank is at row 3, column 2.  Its legal moves are:

- *Left:* slide tile 7 right into the blank (equivalently, move the blank left).
- *Right:* slide tile 5 left into the blank (move the blank right).
- *Up:* slide tile 6 down into the blank (move the blank up).

Moving the blank down is illegal because it is already on the bottom edge.

*c)* A breadth-first search is suitable when each slide has the same unit cost, since it
would find a solution with the fewest slides if one existed @russell2021aima[Sec. 3.4.1].
However, for the states printed in the question, it must return *failure*. There is
no legal sequence from $S_0$ to $G$ because the initial state is not reachable from the goal state.

An inversion is a pair of tiles that are out of numerical order, and the parity of the number of inversions is either even or odd. The tile order in $S_0$ is $[2, 8, 3, 1, 6, 4, 7, 5]$, which has 11 inversions,
whereas the goal order $[1, 2, 3, 4, 5, 6, 7, 8]$ has 0.  On a $3 times 3$ board, every
legal slide preserves the parity of this count. Thus an odd-parity state cannot reach an
even-parity state. This is exactly the parity partition noted for the 8-puzzle in the
textbook where it states that a specified goal is reachable from only half of all possible initial states
@russell2021aima[Sec. 3.2.1].
See the the related exercise for deriving a procedure for determining a state's class @aimaexercise36[AIMA Exercise 3.6].

*d)* The 8-puzzle is a useful AI search benchmark because it has a precise state
representation, a small set of clearly defined legal actions, and a simple unit action
cost, while still having a sufficiently large, branching state space to expose the
differences among search strategies and heuristics. It is therefore a good example
of the general search-problem components such as states, initial state, actions, transition
model, goal test, and path cost @russell2021aima[Sec. 3.2.1].

== 2. Numbered state space

*1.1* For every state $k$, the left and right successors are $2k$ and $2k + 1$.
The required portion of the state space is:

#figure(
  align(center)[
    #image("assets/numbered-state-space.svg", width: 85%)
  ],
  caption: [State-space tree for states 1 to 15. Each left edge is $2k$ and each right edge is $2k + 1$.],
)

*1.2.1* I assume successors are considered in increasing numerical order (the $2k$
successor before $2k+1$), and that "visited" means the node is selected for the goal
test. With goal state 11:

- *Breadth-first search:* $1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11$.
- *Depth-limited search, limit 3:* $1, 2, 4, 8, 9, 5, 10, 11$.
- *Iterative deepening search:* it repeats depth-limited search with successively larger
  limits @russell2021aima[Sec. 3.4.4]:
  - limit 0: $1$
  - limit 1: $1, 2, 3$
  - limit 2: $1, 2, 4, 5, 3, 6, 7$
  - limit 3: $1, 2, 4, 8, 9, 5, 10, 11$ (goal found).

= Question 2

== 1. Minimax values

The levels alternate between MAX and MIN: $A$ is MAX; $B$ and $C$ are MIN;
and $D$, $E$, $F$, and $G$ are MAX.  Applying minimax bottom-up gives:

#table(
  columns: (auto, 1fr, auto),
  align: (left, left, center),
  stroke: 0.5pt,
  inset: 4pt,
  table.header([*Node*], [*Calculation*], [*Value*]),
  [$D$], [$max(2, 9)$], [$9$],
  [$E$], [$max(10, 1)$], [$10$],
  [$F$], [$max(5, 8)$], [$8$],
  [$G$], [$max(4, 3)$], [$4$],
  [$B$], [$min(D, E) = min(9, 10)$], [$9$],
  [$C$], [$min(F, G) = min(8, 4)$], [$4$],
  [$A$], [$max(B, C) = max(9, 4)$], [$9$],
)

Thus: *a)* $D = 9$; *b)* $E = 10$; *c)* $F = 8$; *d)* $G = 4$;
*e)* $B = 9$; *f)* $C = 4$; and *g)* $A = 9$.  At a MAX node the largest
child value is selected, while at a MIN node the smallest is selected
@russell2021aima[Sec. 5.2].

== 2. Alpha-beta pruning

I evaluate children from left to right, as drawn.  The evaluated terminal leaves, in
order, are $H:10$, $H:5$, $I:7$, $I:11$, $J:12$, $J:8$, $L:5$, and $L:12$.

The pruned branches are:

- $E -> K$, including K's terminal leaves 9 and 8.
- $C -> G$, including the whole G subtree (N and O and their terminal leaves).

The final minimax value is $A = 7$.  The essential alpha-beta updates are:

- At $B$, evaluating $D$ gives $D = 7$, so $B$ has $beta = 7$.  At $E$,
  evaluating $J$ gives $J = 8$, hence $alpha_E = 8$.  Since $alpha_E >= beta_E$
  ($8 >= 7$), $K$ cannot affect B's choice and is pruned.
- At the root, evaluating $B$ gives $alpha_A = 7$.  In $C$, evaluating $F$
  gives $F = 5$, hence $beta_C = 5$.  Since $alpha_C >= beta_C$ ($7 >= 5$),
  the G subtree cannot affect A's choice and is pruned.

Alpha-beta search maintains $alpha$ as MAX's best guaranteed value and $beta$ as
MIN's best guaranteed value; a cutoff is valid once $alpha >= beta$
@russell2021aima[Sec. 5.2.3].

== 3. MCTS and a high branching factor

MCTS does not need to expand and evaluate the full game tree.  It uses simulations to
concentrate computation on promising moves, balancing exploration and exploitation.
This makes it practical for games with very high branching factors, where minimax (even
with alpha-beta pruning) can examine too many positions @russell2021aima[Sec. 5.4].

== 4. Meaning of $alpha >= beta$

The condition means that the current path is already no better than an alternative that a
previous MAX or MIN node can force.  Therefore, none of the current node's unexplored
successors can change the final choice.  The algorithm performs a cutoff: it stops exploring
the remaining successors of that node and prunes their branches @russell2021aima[Sec. 5.2.3].

== 5. Definitions

*a) Backpropagation:* In MCTS, backpropagation is the phase after a simulation in which
the simulation outcome updates the visit counts and value estimates of every node on the
selected path back to the root @russell2021aima[Sec. 5.4].

*b) Heuristic evaluation function:* A function that estimates the expected utility or
desirability of a nonterminal game state.  It lets a depth-limited game-tree search treat a
nonterminal state as an approximate terminal state when searching to the true end of the
game is impractical @russell2021aima[Sec. 5.3].

= Question 3

== 1. Translate into First-Order Logic

Using the vocabulary supplied in the question:

*a)* $"Mayor"("David") and not "Senator"("David")$

*b)* $forall p ("Senator"(p) arrow "Politician"(p))$

*c)* $"VotesFor"("David", "Clara") and not "VotesFor"("Clara", "David")$

*d)* $exists p ("Politician"(p) and forall q ("VotesFor"(q, p) arrow ("Citizen"(q) and not "Politician"(q))))$

*e)* $forall p (("Citizen"(p) and not "Senator"(p)) arrow exists q ("Mayor"(q) and "VotesFor"(p, q)))$

== 2. Translate into English

*a)* Ben is an athlete and is not a coach.

*b)* Every Olympian is an athlete.

*c)* Anna trains Ben, but Ben does not train Anna.

*d)* There is a coach who trains only professionals.

*e)* Every athlete who is not a professional is trained by at least one coach.

= Question 4

// Add your answer here.

#bibliography("references.bib", title: "References")
