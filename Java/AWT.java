import java.awt.*;
import java.awt.event.*;


/*
 * @author <+AUTHOR+>
 */
public class <+FILEBASE+> extends Frame {
	/*
	 * @brief Entry point of the program
	 * @param args  Command-line arguments
	 */
	public static void main(String[] args) {
		new <+FILEBASE+>("<+FILEBASE+>").setVisible(true);
	}

	public <+FILEBASE+>(String title) {
		super(title);
		Label label = new Label("<+FILEBASE+>");
		add(label);

		addWindowListener(new WindowAdapter() {
			@Override
			public void windowClosing(WindowEvent ex)  {
				System.exit(0);
			}
		});
		pack();
		setLocation(200, 200);
		setResizable(false);
	}
}
