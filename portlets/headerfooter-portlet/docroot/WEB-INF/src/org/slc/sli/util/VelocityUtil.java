package org.slc.sli.util;

import java.io.StringWriter;

import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.PropsUtil;
import org.slc.sli.util.PropsKeys;

import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.Writer;

import java.net.URISyntaxException;

import javax.imageio.ImageIO;

import org.apache.commons.codec.binary.Base64;

public class VelocityUtil {

	public static String velocityHeaderRes(String headerRes) {
		String headervm = "";
		try {

			InputStream in = VelocityUtil.class
					.getResourceAsStream("/templates/wheader.vm");
			headervm = convertStreamToString(in);

			headervm = headervm.replace("$header", headerRes);

			headervm = headervm.replace(
					"$menu_arrow1",
					"data:image/png;base64,"
							+ getEncodedImg(GetterUtil.getString(PropsUtil
									.get(PropsKeys.MENU_ARROW))));
			headervm = headervm.replace(
					"$arrow",
					"data:image/png;base64,"
							+ getEncodedImg(GetterUtil.getString(PropsUtil
									.get(PropsKeys.ARROW))));
			headervm = headervm.replace(
					"$arrow_w",
					"data:image/png;base64,"
							+ getEncodedImg(GetterUtil.getString(PropsUtil
									.get(PropsKeys.ARROW_W))));

		} catch (FileNotFoundException fne) {

		} catch (IOException ioe) {

		} catch (Exception e) {
			e.printStackTrace();
		}

		return headervm;
	}

	public static String getEncodedImg(String imageName) throws IOException,
			URISyntaxException {

		InputStream imageIs = VelocityUtil.class.getResourceAsStream(imageName);
		System.out.println(imageIs);
		BufferedImage img = ImageIO.read(imageIs);

		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		ImageIO.write(img, "png", baos);
		baos.flush();
		String encodedImage = Base64.encodeBase64String(baos.toByteArray());

		InputStream is = new ByteArrayInputStream(encodedImage.getBytes());

		BufferedReader bufReader = new BufferedReader(new InputStreamReader(is));

		StringBuilder strBdr = new StringBuilder();

		String line;
		while ((line = bufReader.readLine()) != null) {
			strBdr.append(line);
		}

		baos.close();

		return strBdr.toString();
	}

	public static String velocityFooterRes(String headerRes) {

		String footervm = "";
		try {

			InputStream in = VelocityUtil.class
					.getResourceAsStream("/templates/wfooter.vm");
			footervm = convertStreamToString(in);
			footervm = footervm.replace("$footer", headerRes);

		} catch (FileNotFoundException fne) {

		} catch (IOException ioe) {

		} catch (Exception e) {
			e.printStackTrace();
		}

		return footervm;
	}

	/**
	 * Convert the file contents to string
	 * 
	 */
	protected static String convertStreamToString(InputStream is)
			throws IOException {
		/*
		 * To convert the InputStream to String we use the Reader.read(char[]
		 * buffer) method. We iterate until the Reader return -1 which means
		 * there's no more data to read. We use the StringWriter class to
		 * produce the string.
		 */
		if (is != null) {
			Writer writer = new StringWriter();

			char[] buffer = new char[1024];
			try {
				Reader reader = new BufferedReader(new InputStreamReader(is,
						"UTF-8"));
				int n;
				while ((n = reader.read(buffer)) != -1) {
					writer.write(buffer, 0, n);
				}
			} finally {
				is.close();
			}
			return writer.toString();
		} else {
			return "";
		}
	}

}
