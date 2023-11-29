#set page(numbering: "1.", number-align: right)
#set table(align: left)

// ---

#align(horizon)[
  #heading(outlined: false)[Hashing: How do servers store passwords?]
  Alexandra Reaves (2023-2024)
  
  / Topic: Cryptography
  / Stimulus: Computer Science
  / Source: https://github.com/NyxAlexandra/ib-internal-asessment

  #pagebreak()

  #outline(depth: 2, indent: 1em)
]

#pagebreak()

= Introduction

How do servers store passwords?

The natural answer is a structure like this:

#figure(
  table(
    columns: (auto, auto),
    
    [`username`], [`password`],
    [`alice@foo.bar`], [`sorry-bob-321`],
  ),
  caption: [A snippet of a hypothetical database],
) <naive-database>

When a user attempts to log in, they transmit their credentials. If the provided
password matches the password for the requested username, authentication succeeds.

While this works, there are glaring security issues with this model. Consider the
consequences of a data leak: anyone with the data can now access every leaked user's
accounts and the user's accounts on other servers, given how common non-unique
passwords are.

To solve this conundrum, break the question into it's parts:

- Authentication involves the user inputting their username and password
- The server checks whether the received password is correct for the requested user

We know that we can compare the value of the sent password and the password in the
database, but that involves the server knowing the password.

What if the value of the password could be stored without knowing the original password?
To avoid the security problems, this encoded version would have to be non-reversible. A
function like this would have a very useful property:

#figure(
  [\
    if $f(a) = f(b)$, then $a = b$ and vice versa\
    \
  ],
  caption: [The fundamental property of crytographic hash functions]
) <hash-function-property>

where $f$ is the encoding function.

= Hashing

A _Hash Function_ is a function that maps inputs of any size to a fixed-size value.
This output is called the "Digest".

#figure(
  table(
    columns: (auto, auto),
    
    [`username`], [`password`],
    [`alice@foo.bar`], [`eba9b6657ebb2ca702ba6feba680140a55f983523975a86ad8f7b812cab7be2c`],
  ),
  caption: [@naive-database using SHA-256-encoded passwords],
)

Via hashing, the server never receives raw passwords from users. When the user inputs
their password, the password is hashed with the same algorithm used by the server and
is only then transmitted.

While there are many hash functions, the overall structure is as so:

#figure(
  [\
    ```
    hash(bytes: Bytes): Digest;
    ```\
  ],
  caption: [Psuedocode signature of a hash function],
)

A _Cryptographic Hash Function_ is a hash function which has additional security properties.
For any length $n$, these include:

- The probability of any one digest being output by the function decreases exponentially
  as $n$ increases (at least $2^(-n)$)
- It is unfeasible to derive the input string given a digest
- It is unfeasible to find 2 inputs that produce the same digest

Non-cryptographic hash functions are widely used for non-security-critical infrastructure.
Common use cases include unique identifiers in a "Hash Map", a datastructure that maps
hashes of keys to values.

Cryptographic hash functions are widely used for digital security. Besides passwords, they
are used to verify integrity. When a server sends a request to another computer, the
response usually contains the hash of the response. If the hashed response does not match
the provided hash, there is an issue with the integrity of the message.

= Attacks

#quote(block: true)[
  *NOTICE*

  I'm not sure how to work this part. I have done a lot of experimenting and have read the
  paper on MD5 collision attacks @colision-attacks-md5 but don't know the best way to
  connect that to this paper.

  I'm considering using a simple algorithm to show the importance of cryptographic algorithms,
  but I feel like putting focus on the security of algorithms like SHA-256 helps reinforce
  the above sections.

  Some keywords:

  - collision attack
  - brute-force attack
  - birthday attack
  - dictionary/rainbow table attack
]

#pagebreak()

= Definitions

/ Bit:
  The fundamental component of computer memory. A Bit can hold two values: on or off.
  This is represented numerically as `1` or `0` or logically as `true` or `false`.
/ Byte:
  A byte is a collection of 8 bits. It is the most common way of measuring an amount
  of bits.
/ Psuedocode:
  In lieu of actual code, psuedocode describes in language and common programming
  paradigms what the actual code would be like.

= Bibliography

#bibliography(
  "sources.yml",
  title: none,
  full: true,
)