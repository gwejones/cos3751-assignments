#import "@preview/academic-alt:0.1.0": *

#show: university-assignment.with(
  title: "Assignment 2",
  subtitle: "COS3751",
  author: "50052578 Jones GWE",
  details: (
    course: "COS3751",
    due-date: "22 July 2026",
  )
)

#show heading.where(level: 3): set heading(numbering: none)

= Question 1: Constraint Satisfaction Problems

== 1. Components of a CSP

A constraint satisfaction problem (CSP) represents a problem as variables with values that must satisfy constraints. In the standard notation, a CSP is the triple $(X, D, C)$ @russell2021aima.

- $X = {X_1, ..., X_n}$ is the set of variables.
- $D = {D_1, ..., D_n}$ is the set of domains, where each $D_i$ is the set of possible values for variable $X_i$.
- $C$ is the set of constraints. Each constraint specifies which combinations of values are allowed for the variables in its scope.

A solution is a complete assignment of values to all variables that satisfies every constraint.

== 2. Binary and Higher-Order Constraints

A binary constraint involves exactly two variables. For example, in a map-colouring problem, the constraint `WA != SA` says that Western Australia and South Australia may not be assigned the same colour.

A higher-order constraint involves three or more variables. For example, a university timetable rule might say that three practical sessions `P1`, `P2`, and `P3` must all use different laboratories: `alldiff(P1, P2, P3)`. This single constraint relates all three variables at once, rather than only a pair.

== 3. Backtracking Search

*a)* Backtracking search for CSPs is a depth-first search because it builds one partial assignment at a time, recursively extends it by assigning another variable, and follows that branch until it either finds a complete consistent assignment or reaches failure. When failure occurs, it backs up to the most recent assignment point and tries another value.

*b)* Variable assignments in a CSP are commutative because the final assignment does not depend on the order in which individual variables were assigned. For example, assigning `NSW = red` and then `SA = blue` gives the same partial assignment as doing those two assignments in the opposite order. This matters because the solver does not need to consider every possible ordering of the same assignments. It can choose one unassigned variable at each depth and try values for that variable, reducing the search tree from considering many duplicate orderings to considering the actual possible assignments.

== 4. MRV, Degree Heuristic, and LCV

The Minimum Remaining Values (MRV) heuristic chooses the unassigned variable with the fewest legal values left. Its purpose is to expose failure as early as possible. If a variable has no legal values, the search can backtrack immediately instead of spending time on unrelated variables.

The degree heuristic chooses the variable involved in the largest number of constraints on other unassigned variables. It is especially useful as a tie-breaker when MRV cannot distinguish between variables, such as at the beginning of a map-colouring problem where all regions may initially have the same number of legal colours.

Least Constraining Value (LCV) is different because it orders values after a variable has already been chosen. MRV and the degree heuristic ask, "Which variable should be assigned next?" LCV asks, "Which value should be tried first?" It chooses the value that rules out the fewest choices for neighbouring variables, leaving maximum flexibility for the rest of the search.

== 5. Min-Conflicts

The min-conflicts heuristic is a local-search method for CSPs. It uses a complete-state representation, so every variable has a value at every step, although the current assignment may violate some constraints.

The algorithm repeatedly chooses a variable that is currently involved in a conflict and changes its value to one that minimizes the number of violated constraints, usually breaking ties randomly. It therefore repairs a complete but inconsistent assignment instead of constructing a partial assignment from scratch.

The $n$-queens problem is a classic example where min-conflicts performs exceptionally well. Russell and Norvig note that it can solve very large $n$-queens instances efficiently because solutions are densely distributed in the state space @russell2021aima.

== 6. Arc Consistency and AC-3

An arc $X -> Y$ is consistent when every value in the current domain of $X$ has at least one compatible value in the current domain of $Y$ that satisfies the binary constraint between $X$ and $Y$. If a value of $X$ has no such support in $Y$, that value can be removed from $X$'s domain.

Arc consistency can detect failure earlier than forward checking because it propagates the effects of domain reductions through neighbouring variables. Forward checking removes values from variables directly connected to the variable just assigned, but it does not recursively check whether those removals create new inconsistencies elsewhere. AC-3 continues revising arcs until no more domain values can be removed, or until some variable's domain becomes empty. An empty domain proves that the current CSP cannot be solved, so failure is detected before deeper search is attempted.


= Question 2: Logical Agents

== 1. Knowledge and Implementation Levels

The *knowledge level* describes an agent in terms of what it knows and what its goals are. This is enough to explain the actions that rationally follow. The *implementation level* describes how that knowledge and reasoning are actually realised, for example through particular data structures, code, or a neural network. Thus a given knowledge-level behaviour can have several different implementations @russell2021aima[Sec. 7.1].

== 2. Declarative Approach

The declarative approach is useful because the designer can tell sentences containing facts, rules, or goals to the knowledge base and then ask what action follows. This makes the agent easier to adapt when knowledge changes, without rewriting each desired behaviour as program code. One limitation is that general-purpose inference over declarative knowledge can be less efficient than specialised procedural code. Declarative knowledge is often compiled into more efficient procedural code @russell2021aima[Sec. 7.1].

== 3. Wumpus World Properties

- *a) Observable:* No. It is *partially observable*, since the agent's local percepts do not reveal the complete world state, such as the locations of all of the pits and the Wumpus @russell2021aima[Sec. 7.2].
- *b) Deterministic:* Yes. Given the current state and an action, its outcome is predictable. For example, moving forward either moves the agent one square or causes a bump at a wall @russell2021aima[Sec. 7.2].
- *c) Episodic:* No. It is sequential because a current action changes the state and can affect the consequences and rewards of later actions. For example, firing the arrow permanently uses it @russell2021aima[Sec. 7.2].
- *d) Static:* Yes. The world does not change while the agent is still deciding the next action. In particular, the Wumpus does not move @russell2021aima[Sec. 7.2].

== 4. Entailment

A knowledge base $"KB"$ entails a sentence $alpha$ when $alpha$ is true in every model in which $"KB"$ is true. Using model sets, this is written as $"KB" models alpha$ if and only if $M("KB") subset.eq M(alpha)$ @russell2021aima[Sec. 7.3].

== 5. Wumpus-World Entailment

No, $alpha = not P_(1,2)$ is not entailed by the given $"KB"$. The breeze rule for $(2,1)$ mentions only $P_(1,1)$, $P_(2,2)$, and $P_(3,1)$; together with $not P_(1,1)$ and $B_(2,1)$. It establishes only that at least one of $P_(2,2)$ or $P_(3,1)$ is true. It places no restriction on $P_(1,2)$, so there is a model in which the KB is true and $P_(1,2)$ is also true. Therefore $M("KB")$ is not a subset of $M(not P_(1,2))$ @russell2021aima[Secs. 7.3, 7.4.3--7.4.4].

== 6. Propositional Logic

*a)* $S arrow W$

*b)* $(G and not S) or not W$

*c)* In the given model, $G$ is true and $S$ is false, so $G and not S$ is true. Although $not W$ is false, the whole disjunction is true.

== 7. Soundness and Completeness

An inference procedure $i$ is *sound* if it derives only sentences that are entailed, ie. $"KB" tack_i alpha$ implies $"KB" models alpha$. It is *complete* if it can derive every sentence that is entailed, ie. if $"KB" models alpha$, then $"KB" tack_i alpha$ @russell2021aima[Sec. 7.3].

== 8. Completeness of Resolution

Resolution being *complete* means that it will not miss any sentence that logically follows from a propositional knowledge base. Whenever a knowledge base logically entails a conclusion, resolution can eventually prove it by deriving a contradiction. To test whether $"KB"$ entails a query $alpha$, resolution uses proof by contradiction. It adds $not alpha$ to the $"KB"$, converts the resulting sentences to CNF and repeatedly applies the resolution rule.

If $"KB" models alpha$, then $"KB" and not alpha$ has is unsatisfiable. Therefore repeated resolution must eventually derive the empty clause, which represents a contradiction and proves that the assumption $not alpha$ is impossible. Hence $"KB" models alpha$. If the procedure terminates with no new clauses and no empty clause, the query is not entailed @russell2021aima[Sec. 7.5.2].

== 9. Forward Chaining

Forward chaining starts from the known facts and adds a rule's conclusion once all of its premises have been processed @russell2021aima[Sec. 7.5.4]. Using the initial agenda order `[A, B, M]`, the derivation is:

#table(
  columns: (auto, 1fr, 1fr),
  align: (left, left, left),
  stroke: 0.5pt,
  inset: 5pt,
  table.header([*Step*], [*Agenda after the step*], [*Inferred set after the step*]),
  [Initial], [`[A, B, M]`], [$emptyset$],
  [Process $A$], [`[B, M]`], [$A$],
  [Process $B$; infer $L$ from $A and B arrow L$], [`[M, L]`], [$A, B$],
  [Process $M$], [`[L]`], [$A, B, M$],
  [Process $L$; infer $P$ from $L and M arrow P$], [`[P]`], [$A, B, M, L$],
  [Process $P$; infer $Q$ from $P arrow Q$], [`[Q]`], [$A, B, M, L, P$],
  [Pop $Q$; return true], [`[]`], [$A, B, M, L, P$],
)



#bibliography("references.bib", title: "References")
