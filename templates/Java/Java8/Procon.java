import java.io.*;
import java.util.*;

public class <+FILEBASE+> {
	public static void main(String[] args) throws Exception {
		try (BufferedReader br = new BufferedReader(new InputStreamReader(System.in))) {
			br.lines()
				.map(line -> Arrays.stream(line.split(" "))
						.mapToInt(Integer::parseInt)
						.toArray())
				.forEach(intArray -> {
					<+CURSOR+>
				});
		}
	}
}
