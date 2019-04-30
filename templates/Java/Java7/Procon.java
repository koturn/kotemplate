import java.io.*;

public class <+FILEBASE+> {
	public static void main(String[] args) throws Exception {
		try (BufferedReader br = new BufferedReader(new InputStreamReader(System.in))) {
			String line = null;
			while ((line = br.readLine()) != null) {
				String[] tokens = line.split(" ");
				<+CURSOR+>
			}
		}
	}
}
