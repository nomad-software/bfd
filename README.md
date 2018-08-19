# bfd

**A Brainfuck interpreter written in the D programming language.**

---

## Overview

Brainfuck is an esoteric programming language noted for its extreme minimalism. The language consists of only eight simple commands and an instruction pointer. It is designed to challenge and amuse programmers, and was not made to be suitable for practical use. It was created in 1993 by Urban Müller. [See wikipedia page.](https://en.wikipedia.org/wiki/Brainfuck)

### Usage

Programs can be run by bfd reading stdin or the file declared as the first argument to the program.

#### Stdin

```
cat program.bf | bfd
```

#### Argument

```
bfd program.bf
```
