package org.slc.sli.util;

import java.io.StringWriter;

import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.PropsUtil;
 

import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.Reader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.Writer;
import java.net.URL;
import java.io.*;
import java.net.URISyntaxException;
import java.io.IOException;
import javax.imageio.ImageIO;
import java.util.Iterator;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.imageio.ImageIO;
import javax.imageio.ImageReadParam;
import javax.imageio.ImageReader;
import javax.imageio.stream.ImageInputStream;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
 
import org.apache.commons.codec.binary.Base64;

public class VelocityUtil {

	 
 
	public static String base64Encode(File stringToEncode) throws IOException{  
		 BufferedImage image = ImageIO.read(stringToEncode);
		 ByteArrayOutputStream baos = new ByteArrayOutputStream();
		 ImageIO.write(image, "png", baos);
		 baos.flush();
         String encodedImage = Base64.encodeBase64String(baos.toByteArray());
		 System.out.println(">>>>>>>>>>>>>>>"+encodedImage);
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

	 public static String base64Decode(String stringToDecode){  
			byte [] decodedBytes = Base64.decodeBase64(stringToDecode);  
			return new String(decodedBytes);  
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
