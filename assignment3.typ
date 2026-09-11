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
differences among search strategies and heuristics.  It is therefore a compact example
of the general search-problem components: states, initial state, actions, transition
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

// Add your answer here.

= Question 3

// Add your answer here.

= Question 4

// Add your answer here.

#bibliography("references.bib", title: "References")
