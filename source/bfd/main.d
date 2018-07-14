/**
 * Imports.
 */
import core.memory;
import core.stdc.stdio : printf, getchar;
import std.array;
import std.conv;
import std.stdio;

/**
 * Main entry point.
 *
 * Params:
 *     args = An array of command line arguments passed to this program.
 */
void main(string[] args)
{
	// Disable garbage collections.
	GC.disable();

	// Read the program from stdin or the first argument if it's used.
	auto source = args.length > 1 ? File(args[1], "r") : stdin;
	string program = source
		.byLine(KeepTerminator.no)
		.join()
		.to!(string);

	// The stack within which to hold program state.
	// A standard Brainfuck interpreter uses a 30k stack.
	char[30_720] stack = 0;

	// The pointer to traverse the program stack.
	char* pointer = stack.ptr;

	// A standard stack type to record loop start positions.
	int[1_024] loops; int loop = -1;

	// A counter to handle skipping loops.
	int skip;

	// Interpret the program.
	for (int x = 0; x < program.length; x++)
	{
		switch(program[x])
		{
			case '>':
				pointer++;
				break;
		
			case '<':
				pointer--;
				break;
		
			case '+':
				(*pointer)++;
				break;
		
			case '-':
				(*pointer)--;
				break;
		
			case '.':
				printf("%c", *pointer);
				break;
		
			case ',':
				*pointer = cast(char) getchar();
				break;
		
			case '[':
				if (*pointer == '\0')
				{
					skip++;
					while (skip > 0)
					{
						x++;
						if (program[x] == '[')
						{
							skip++;
						}
						else if (program[x] == ']')
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
		
			case ']':
				if (*pointer == '\0')
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
