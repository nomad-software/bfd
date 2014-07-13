/**
 * Imports.
 */
import std.stdio;
import etcetera.collection;

/**
 * Main entry point.
 *
 * Params:
 *     args = An array of command line arguments passed to this program.
 */
void main(string[] args)
{
	// The stack within which to hold program state.
	ubyte[32_000] stack;

	// The pointer to the stack.
	char* pointer = cast(char*)stack.ptr;

	// A stack to record the loops.
	auto loops = new Stack!(size_t);
	size_t skip;

	// The program to run.
	auto program = ">++++++++[<+++++++++>-]<.>>+>+>++>[-]+<[>[->+<<++++>]<<]>.+++++++..+++.>>+++++++.<<<[[-]<[-]>]<+++++++++++++++.>>.+++.------.--------.>>+.>++++.";

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
