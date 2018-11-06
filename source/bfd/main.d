/**
 * Imports.
 */
import core.memory;
import core.stdc.stdio : printf, getchar;
import std.array;
import std.conv;
import std.stdio;

/**
 * Brainfuck operators.
 */
enum bf
{
	right  = '>',
	left   = '<',
	add    = '+',
	sub    = '-',
	input  = ',',
	output = '.',
	open   = '[',
	close  = ']',
}

/**
 * Read the operators from the program and count the number of times they are
 * used consecutively.
 *
 * Params:
 *     program = The program to parse.
 */
auto parseOperators(string program)
{
	static struct Operator
	{
		char token;
		int count;
	}

	Operator[] ops;
	Operator current;

	for (int x = 0; x < program.length; x++)
	{
		auto op = program[x];

		switch(op)
		{
			case bf.right: goto case;
			case bf.left: goto case;
			case bf.add: goto case;
			case bf.sub:
				if (op == current.token)
				{
					current.count++;
					break;
				}

				if (current.token != char.init)
				{
					ops ~= current;
				}

				current = Operator(op, 1);
				break;

			case bf.input: goto case;
			case bf.output: goto case;
			case bf.open: goto case;
			case bf.close:
				ops ~= current;
				current = Operator(op, 1);
				break;

			default:
				break;
		}
	}

	ops ~= current;
	return ops;
}

/**
 * Main entry point.
 *
 * Params:
 *     args = An array of command line arguments passed to this program.
 */
void main(string[] args)
{
	GC.disable();

	auto source = args.length > 1 ? File(args[1], "r") : stdin;
	string program = source
		.byLine(KeepTerminator.no)
		.join()
		.to!(string);

	char[30_720] stack = 0;
	int cell;

	int[2_056] loops;
	int loop = -1;
	int skip;

	auto ops = parseOperators(program);

	for (int x = 0; x < ops.length; x++)
	{
		switch(ops[x].token)
		{
			case bf.right:
				cell += ops[x].count;
				break;

			case bf.left:
				cell -= ops[x].count;
				break;

			case bf.add:
				stack[cell] += ops[x].count;
				break;

			case bf.sub:
				stack[cell] -= ops[x].count;
				break;

			case bf.input:
				stack[cell] = cast(char) getchar();
				break;

			case bf.output:
				printf("%c", stack[cell]);
				break;

			case bf.open:
				if (stack[cell] == '\0')
				{
					skip++;
					while (skip > 0)
					{
						x++;
						if (ops[x].token == '[')
						{
							skip++;
						}
						else if (ops[x].token == ']')
						{
							skip--;
						}
					}
					break;
				}
				else
				{
					loops[++loop] = x;
				}
				break;

			case bf.close:
				if (stack[cell] == '\0')
				{
					loop--;
				}
				else
				{
					x = loops[loop];
				}
				break;

			default:
				break;
		}
	}
}
