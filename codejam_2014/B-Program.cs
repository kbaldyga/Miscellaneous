using System;
using System.Collections.Generic;
using System.Linq;

namespace B
{
	class MainClass
	{
		static readonly decimal[] cache = new decimal[100000];//null; // set size to 50000 and set 0th el to 0

		public static void Main (string[] args)
		{
			System.Globalization.CultureInfo customCulture = (System.Globalization.CultureInfo)System.Threading.Thread.CurrentThread.CurrentCulture.Clone();
			customCulture.NumberFormat.NumberDecimalSeparator = ".";

			System.Threading.Thread.CurrentThread.CurrentCulture = customCulture;

			int cases = int.Parse (Console.ReadLine ());
			for(int t = 1 ; t <= cases ; t ++) {
				var numbers = Console.ReadLine ()
					.Split (new[]{ ' ' }, StringSplitOptions.RemoveEmptyEntries)
					.Select (n => decimal.Parse (n))
					.ToArray();
				var c = numbers [0];
				var f = numbers [1];
				var x = numbers [2];


				var currentBest = result(0, x, f, c);

				for(uint j = 1 ; j < 100000; j ++) {
					var currentResult = result (j, x, f, c);
					if(currentResult < currentBest ) {
						currentBest = currentResult;
					} else if (currentResult > currentBest) {
						break;
					}
				}

				Console.WriteLine ("Case #{0}: "+ currentBest.ToString("0.0000000").Replace(" ",""), t);
			}
		}

		static decimal result(uint n, decimal x, decimal f, decimal c) {
			return x / (2.0m + (decimal)n * f) + ff (n, c, f);
		}

		static decimal ff(uint n, decimal c, decimal f) {
			if (n == 0)
				return (cache[0] = 0.0m);

			var current = c / (2.0m + (decimal)(n - 1) * f);
			cache [n] = cache [n - 1] + current;
			return cache [n];
		}
	}
}
