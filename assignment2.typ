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

#let answer = [#block(
  fill: rgb("#f7f7f7"),
  inset: 8pt,
  radius: 2pt,
  [TODO: Answer.]
)]

= Question 1: Constraint Satisfaction Problems



#bibliography("references.bib", title: "References")
