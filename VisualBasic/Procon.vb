Imports System
Imports System.IO

Public Class MainClass
    Shared Sub Main()
        Console.SetOut(New StreamWriter(Console.OpenStandardOutput()) With { .AutoFlush = false })

        Dim inputtedLine As String = Console.ReadLine()
        While (Not inputtedLine Is Nothing)
            Dim tokens As Integer() = inputtedLine.Split(" ").Select(Function(token) Integer.Parse(token)).ToArray()
            Console.WriteLine("{0} {1}", tokens(0), tokens(1))
            <+CURSOR+>
            inputtedLine = Console.ReadLine()
        End While

        Console.Out.Flush()
    End Sub
End Class

