using System;
using System.Linq;
using System.Collections.Generic;

namespace A
{
	class MainClass
	{
		public static void Main (string[] args)
		{
			int repetitions = int.Parse(Console.ReadLine ());
			for(int i = 1 ; i <= repetitions ; i ++) {
				uint bitSet1 = 0;
				uint bitSet2 = 0;

				for (int question = 0; question < 2; question++) { 
					var selectedLine = int.Parse (Console.ReadLine ());
					for (int row = 0; row < 4; row++) {
						if (row != selectedLine - 1) {
							Console.ReadLine ();
						} else {
							var numbers = Console.ReadLine ().Split (new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries)
							.Select (n => int.Parse (n));
							foreach (var number in numbers) {
								if (question == 1) {
									bitSet1= bitSet1 | (uint)(1 << number);
								} else {
									bitSet2 = bitSet2 | (uint)(1 << number);
								}
							}
						}
					}
				}

				var numberOfBits = NumberOfSetBits (bitSet1 & bitSet2);

				switch(numberOfBits) {
					case 0:
					Console.WriteLine ("Case #{0}: Volunteer cheated!", i);
						break;
					case 1:
						uint v = bitSet1 & bitSet2;
						int number = MultiplyDeBruijnBitPosition[((uint)((v & -v) * 0x077CB531U)) >> 27];
						Console.WriteLine ("Case #{0}: {1}", i, number);
						break;
					default:
						Console.WriteLine ("Case #{0}: Bad magician!", i);
						break;
				}
			}

		}

		static readonly int[] MultiplyDeBruijnBitPosition =  {
				0, 1, 28, 2, 29, 14, 24, 3, 30, 22, 20, 15, 25, 17, 4, 8, 
				31, 27, 13, 23, 21, 19, 16, 7, 26, 12, 18, 6, 11, 5, 10, 9
			};

		static uint NumberOfSetBits(uint i)
		{
			i = i - ((i >> 1) & 0x55555555);
			i = (i & 0x33333333) + ((i >> 2) & 0x33333333);
			return (((i + (i >> 4)) & 0x0F0F0F0F) * 0x01010101) >> 24;
		}
	}
}
