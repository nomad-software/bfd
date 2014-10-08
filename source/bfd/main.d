/**
 * Imports.
 */
import core.stdc.stdio : getchar;
import etcetera.collection.stack;
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
	// Read the program from stdin or the first argument if it's used.
	auto source = args.length > 1 ? File(args[1], "r") : stdin;
	string program = source
		.byLine(KeepTerminator.no)
		.join()
		.to!(string);

	// The stack within which to hold program state.
	// A standard Brainfuck interpreter uses a 30k stack.
	ubyte[30_000] stack;

	// The pointer to traverse the program stack.
	char* pointer = cast(char*)stack.ptr;

	// A standard stack type to record loop start positions.
	auto loops = new Stack!(size_t);

	// A counter to handle skipping loops.
	size_t skip;

	// Interpret the program.
	for (size_t x = 0; x < program.length; x++)
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
				writef("%c", *pointer);
				break;
		
			case ',':
				*pointer = cast(char)getchar();
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
					loops.push(x);
				}
				break;
		
			case ']':
				if (*pointer == '\0')
				{
					loops.pop();
				}
				else
				{
					x = loops.peek();
				}
				break;
		
			default:
				break;
		}
	}
}
