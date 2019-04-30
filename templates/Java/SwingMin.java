import javax.swing.*;


/**
 * @author koturn
 */
public class <+FILEBASE+> extends JFrame {
	/**
	 * @brief Entry point of the program
	 * @param args  Command-line arguments
	 */
	public static void main(String[] args) {
		UIManager.put("swing.boldMetal", Boolean.FALSE);
		SwingUtilities.invokeLater(new Runnable() {
			@Override
			public void run() {
				new <+FILEBASE+>("<+FILEBASE+>").setVisible(true);
			}
		});
	}

	/**
	 * Create Swing frame
	 * @param title  Frame-title
	 */
	public <+FILEBASE+>(String title) {
		super(title);
		Container container = getContentPane();
		JLabel label = new JLabel("<+FILEBASE+>");
		container.add(label);
		<+CURSOR+>
		pack();
		setLocation(200, 200);
		setResizable(false);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
	}
}
