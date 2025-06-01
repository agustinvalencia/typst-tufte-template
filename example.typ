#import "tufte.typ": *

#show: tufte.with(
  title: [An Example using Tufte],
  authors: (
    (
      name: "Name Lastname",
      affiliation: "Institute",
      email: "name.lastname@institute.com",
    ),
    (
      name: "Name Lastname",
      affiliation: "Institute",
      email: "name.lastname@institute.com",
    ),
  ),
  abstract: lorem(100),
)

= Introduction

#lorem(100)

$ cal(A) := { x in RR | x "is natural" } $

$
  sum_(k=0)^n k
  &= 1 + ... + n \
  &= (n(n+1)) / 2
$

#lorem(50)

== Another
#narrow[
  #lorem(10)
  #note[#lorem(20)
    `Dictionary<waton> https://www.google.com`]
  #lorem(100)
]

`Dictionary<Type>(waton)=>{ return; }`

= #lorem(5)

#lorem(200)
