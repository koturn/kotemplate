using System;
using System.IO;


class MainClass
{
    private static void Main()
    {
        Console.SetOut(new StreamWriter(Console.OpenStandardOutput()) { AutoFlush = false });

        string line;
        while ((line = Console.ReadLine()) != null)
        {
            var tokens = line.Split(' ');
            <+CURSOR+>
        }

        Console.Out.Flush();
    }
}
