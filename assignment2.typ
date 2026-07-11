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



#bibliography("references.bib", title: "References")
