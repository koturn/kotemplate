import java.awt.*;
import java.awt.event.*;
import java.awt.image.BufferedImage;
import java.io.*;
import java.net.*;
import javax.imageio.ImageIO;
import javax.swing.*;
import javax.swing.UIManager.*;


/**
 * Sample Swing application
 * @author koturn
 */
public class <+FILEBASE+> extends JFrame {
	private CanvasLabel canvas;
	private LookAndFeelInfo[] lf;

	/**
	 * Entry point of the program
	 * @param args  Command-line arguments
	 */
	public static void main(String[] args) {
		UIManager.put("swing.boldMetal", Boolean.FALSE);
		SwingUtilities.invokeLater(() -> {
			new <+FILEBASE+>("<+FILEBASE+>").setVisible(true);
		});
		<+CURSOR+>
	}

	/**
	 * Create Swing frame
	 * @param title  Frame-title
	 */
	public <+FILEBASE+>(String title) {
		super(title);

		JMenuBar menuBar = new JMenuBar();
		setJMenuBar(menuBar);

		// JMenu - File(F)
		JMenu menu = new JMenu("File(F)");
		menuBar.add(menu);
		menu.setMnemonic(KeyEvent.VK_F);

		JMenuItem menuItem = new JMenuItem("Open image file");
		menu.add(menuItem);
		menuItem.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_O, KeyEvent.CTRL_DOWN_MASK));
		menuItem.addActionListener(new ImageFileChooseEventHandler());

		menu.addSeparator();

		menuItem = new JMenuItem("Save image");
		menu.add(menuItem);
		menuItem.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_S, KeyEvent.CTRL_DOWN_MASK));
		menuItem.addActionListener(new ImageFileSaveEventHandler());


		// JMenu - Preferences (P)
		menu = new JMenu("Preferences(P)");
		menuBar.add(menu);
		menu.setMnemonic(KeyEvent.VK_P);

		JMenu childMenu = new JMenu("Look & Feel");
		menu.add(childMenu);
		lf = UIManager.getInstalledLookAndFeels();
		JCheckBoxMenuItem[] LFMenuItems = new JCheckBoxMenuItem[lf.length];
		LFChangeEventHandler lfceh = new LFChangeEventHandler();
		ButtonGroup bg = new ButtonGroup();
		for (int i = 0; i < lf.length; i++) {
			LFMenuItems[i] = new JCheckBoxMenuItem(lf[i].getName());
			LFMenuItems[i].addActionListener(lfceh);
			bg.add(LFMenuItems[i]);
			childMenu.add(LFMenuItems[i]);
		}
		LFMenuItems[0].setSelected(true);


		// Set components
		Container container = getContentPane();
		JPanel panel = new JPanel();
		panel.setLayout(new GridLayout(1, 2));
		container.add(panel, BorderLayout.SOUTH);

		JButton bt = new JButton("Color");
		bt.addActionListener(new ColorChooseEventHandler());
		panel.add(bt);

		bt = new JButton("Thickness");
		bt.addActionListener(new ThicknessChooseEventHandler());
		panel.add(bt);

		canvas = new CanvasLabel();
		canvas.setPreferredSize(new Dimension(400, 400));
		container.add(canvas, BorderLayout.CENTER);


		// setBounds(this.getX() + 100, this.getY() + 100, 400, 400);
		pack();
		setLocation(200, 200);
		setResizable(false);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		// setIconImage(getImageIconInJar("icon.png").getImage());
	}

	/**
	 * Get ImageIcon object of image which specified path in Jar.
	 * If the image doesn't exist in Jar, try to find from current directory with the same path.
	 * Even if the image is not found, return null.
	 * @param filePath  Path to image file
	 * @return  ImageIcon object of specified path
	 */
	public ImageIcon getImageIconInJar(String filePath) {
		URL url = getClass().getClassLoader().getResource(filePath);
		return url != null ? new ImageIcon(url) : new ImageIcon(filePath);
	}

	/**
	 * Canvas label class
	 */
	private class CanvasLabel extends JLabel implements MouseListener, MouseMotionListener {
		private int x1;
		private int y1;
		private int x2;
		private int y2;
		private Color color;
		private BasicStroke wideStroke;
		private BufferedImage canvasImage;
		private Graphics2D canvasGraphics;

		CanvasLabel() {
			addMouseListener(this);
			addMouseMotionListener(this);
			color = Color.BLACK;
			wideStroke = new BasicStroke(1.0f);
			canvasImage = new BufferedImage(400, 400, BufferedImage.TYPE_INT_RGB);
			canvasGraphics = canvasImage.createGraphics();
			canvasGraphics.fillRect(0, 0, canvasImage.getWidth(), canvasImage.getHeight());
			repaint();
		}
		@Override
		public void paintComponent(Graphics g){
			g.drawImage(canvasImage, 0, 0, null);
		}
		@Override
		public void mouseClicked(MouseEvent ev) {
			// Do nothing
		}
		@Override
		public void mouseEntered(MouseEvent ev) {
			// Do nothing
		}
		@Override
		public void mouseExited(MouseEvent ev) {
			// Do nothing
		}
		@Override
		public void mousePressed(MouseEvent ev) {
			x1 = ev.getX();
			y1 = ev.getY();
			canvasGraphics.setStroke(wideStroke);
			canvasGraphics.setColor(color);
		}
		@Override
		public void mouseReleased(MouseEvent ev) {
			// Do nothing
		}
		@Override
		public void mouseDragged(MouseEvent ev) {
			x2 = x1;
			y2 = y1;
			x1 = ev.getX();
			y1 = ev.getY();
			canvasGraphics.drawLine(x2, y2, x1, y1);
			repaint();
		}
		@Override
		public void mouseMoved(MouseEvent ev) {
			// Do nothing
		}
	}

	/**
	 * Event handler for choosing color
	 */
	private class ColorChooseEventHandler implements ActionListener {
		@Override
		public void actionPerformed(ActionEvent ev) {
			Color newColor = JColorChooser.showDialog(<+FILEBASE+>.this, "Choose color", <+FILEBASE+>.this.canvas.color);
			if (newColor != null) {
				<+FILEBASE+>.this.canvas.color = newColor;
			}
		}
	}

	/**
	 * Event handler for choosing thickness of line
	 */
	private class ThicknessChooseEventHandler implements ActionListener {
		private JSpinner js;
		private float value;
		ThicknessChooseEventHandler() {
			SpinnerNumberModel snm = new SpinnerNumberModel(1.0, 1.0, 10.0, 0.5);
			js = new JSpinner(snm);
			value = 1;
		}
		@Override
		public void actionPerformed(ActionEvent ev) {
			js.setValue(value);
			int ret = JOptionPane.showConfirmDialog(<+FILEBASE+>.this, js, "Choose thickness", JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);
			if (ret != JOptionPane.YES_OPTION) return;
			try {
				value = Float.parseFloat(js.getValue().toString());
				<+FILEBASE+>.this.canvas.wideStroke = new BasicStroke(value);
			} catch (NumberFormatException ex) {
				JOptionPane.showMessageDialog(<+FILEBASE+>.this, "Invalid value", "Warning", JOptionPane.WARNING_MESSAGE);
			}
		}
	}

	/**
	 * Event handler for opening file
	 */
	private class ImageFileChooseEventHandler implements ActionListener {
		private String[] suffixes = {".png", ".jpg", ".jpeg", ".jpe", ".jfif", ".gif"};
		@Override
		public void actionPerformed(ActionEvent ev) {
			JFileChooser fc = new JFileChooser(".");
			fc.setFileSelectionMode(JFileChooser.FILES_ONLY);
			fc.setDialogTitle("Oepn image file");
			fc.setFileFilter(new FileChooserFilter("Image file", suffixes));
			int ret = fc.showOpenDialog(<+FILEBASE+>.this);
			if (ret != JFileChooser.APPROVE_OPTION) {
				return;
			}
			String filePath = fc.getSelectedFile().getAbsolutePath();
			try {
				BufferedImage image = ImageIO.read(new File(filePath));
				<+FILEBASE+>.this.canvas.canvasGraphics.drawImage(image, 0, 0, null);
				repaint();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	/**
	 * Event handler for saving image
	 */
	private class ImageFileSaveEventHandler implements ActionListener {
		private String[] suffixes = {".png", ".jpg", ".jpeg", ".jpe", ".jfif", ".gif"};
		@Override
		public void actionPerformed(ActionEvent ev) {
			JFileChooser fc = new JFileChooser(".");
			fc.setFileSelectionMode(JFileChooser.FILES_ONLY);
			fc.setDialogTitle("Save image");
			fc.setFileFilter(new FileChooserFilter("Image file", suffixes));
			int ret = fc.showSaveDialog(<+FILEBASE+>.this);
			if (ret != JFileChooser.APPROVE_OPTION) {
				return;
			}
			String filePath = fc.getSelectedFile().getAbsolutePath();
			try {
				ImageIO.write(canvas.canvasImage, "jpeg", new File(filePath));
			} catch (IOException ex) {
				ex.printStackTrace();
			}
		}
	}

	/**
	 * File filter class
	 */
	private class FileChooserFilter extends javax.swing.filechooser.FileFilter {
		private String[] suffixes;
		private String description;

		FileChooserFilter(String description, String[] suffixes) {
			this.suffixes = suffixes;
			this.description = description + "(";
			for (int i = 0; i < suffixes.length - 1; i++) {
				this.description += "*" + suffixes[i] + ";";
			}
			this.description += "*" + suffixes[suffixes.length - 1] + ")";
		}

		@Override
		public boolean accept(File file) {
			if (file.isDirectory()) {
				return true;
			}
			String name = file.getName().toLowerCase();
			for (String s : suffixes) {
				if (name.endsWith(s)) {
					return true;
				}
			}
			return false;
		}
		@Override
		public String getDescription() {
			return description;
		}
	}

	/**
	 * Class for changing Look and Feel
	 */
	private class LFChangeEventHandler implements ActionListener {
		@Override
		public void actionPerformed(ActionEvent ev) {
			setLookAndFeel(ev.getActionCommand());
		}
		public void setLookAndFeel(String LFName) {
			String newLFClassName = "";
			for (LookAndFeelInfo info : lf) {
				if (LFName.equals(info.getName())) {
					newLFClassName = info.getClassName();
					break;
				}
			}
			try {
				UIManager.setLookAndFeel(newLFClassName);
				SwingUtilities.updateComponentTreeUI(<+FILEBASE+>.this);
				<+FILEBASE+>.this.pack();
			} catch (ClassNotFoundException | InstantiationException | IllegalAccessException | UnsupportedLookAndFeelException ex) {
				ex.printStackTrace();
			}
		}
	}
}
