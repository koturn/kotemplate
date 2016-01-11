using System;
using System.IO;

class MainClass {
	static void Main() {
		Console.SetOut(new StreamWriter(Console.OpenStandardOutput()) { AutoFlush = false });

		string line;
		while ((line = Console.ReadLine()) != null) {
			string[] tokens = line.Split(' ');
			<+CURSOR+>
		}

		Console.Out.Flush();
	}
}
