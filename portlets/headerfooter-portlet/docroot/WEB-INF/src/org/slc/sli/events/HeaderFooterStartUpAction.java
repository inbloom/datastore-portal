package org.slc.sli.events;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.StringWriter;
import java.io.Writer;
import java.io.InputStream;

import org.slc.sli.headerfooter.model.HeaderFooter;
import org.slc.sli.headerfooter.service.HeaderFooterLocalServiceUtil;
import org.slc.sli.util.PropsKeys;

import com.liferay.portal.kernel.events.SimpleAction;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.PropsUtil;
import com.liferay.portal.kernel.util.Validator;

/**
 * HeaderFooterStartUpAction.java
 * 
 * Purpose: This is a application startup event class which will fired when the
 * application is deployed.
 * 
 * @author
 * @version 1.0
 */

public class HeaderFooterStartUpAction extends SimpleAction {

	@Override
	public void run(String[] ids) {
		long companyId = GetterUtil.getLong(ids[0]);
	_log.info("inside header event...");
		processHeader();

		processFooter();

	}

	/**
	 * Read the text from the header_pref.txt file and create that as header
	 * record.
	 * 
	 */
	protected void processHeader() {
		try {

			InputStream in = HeaderFooterStartUpAction.class
					.getResourceAsStream("/content/header_pref.txt");

			_log.info("Reading Header Preferences File...");

			String headerText = convertStreamToString(in);

			HeaderFooter headerFooter = HeaderFooterLocalServiceUtil
					.getCurrentHeader();

			if (Validator.isNull(headerFooter)) {
				HeaderFooterLocalServiceUtil.addHeader(headerText);
				_log.info("Header Created...");
			} else if (Validator.isNotNull(headerFooter)
					&& !(headerFooter.getData().equals(headerText))) {
				HeaderFooterLocalServiceUtil.editHeader(headerFooter.getId(),
						headerText);
				_log.info("Updated Header...");
			}
		} catch (FileNotFoundException fne) {
			_log.info("Footer Preferences File Not Found...");
		} catch (IOException ioe) {
			_log.info("I/O error occured");
		} catch (SystemException e) {

		} catch (PortalException e) {

		}
	}

	/**
	 * Read the text from the footer_pref.txt file and create that as footer
	 * record.
	 * 
	 */
	protected void processFooter() {
		try {
			
			String footerFile = "/content/footer_pref.txt";
			boolean is_sandbox = GetterUtil.getBoolean(PropsUtil.get("is_sandbox"));

			if(is_sandbox){
				footerFile = "/content/footer_pref_sandbox.txt";
			}
			
			
			InputStream in = HeaderFooterStartUpAction.class
					.getResourceAsStream(footerFile);

			_log.info("Reading Footer Preferences File...");

			String footerText = convertStreamToString(in);

			HeaderFooter headerFooter = HeaderFooterLocalServiceUtil
					.getCurrentFooter();

			if (Validator.isNull(headerFooter)) {
				HeaderFooterLocalServiceUtil.addFooter(footerText);
				_log.info("Footer Created...");
			} else if (Validator.isNotNull(headerFooter)
					&& !(headerFooter.getData().equals(footerText))) {
				HeaderFooterLocalServiceUtil.editFooter(headerFooter.getId(),
						footerText);
				_log.info("Updated Footer...");
			}
		} catch (FileNotFoundException fne) {
			_log.info("Footer Preferences File Not Found...");
		} catch (IOException ioe) {
			_log.info("I/O error occured");
		} catch (SystemException e) {

		} catch (PortalException e) {

		}
	}

	/**
	 * Convert the file contents to string
	 * 
	 */
	protected String convertStreamToString(InputStream is) throws IOException {
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

	private static Log _log = LogFactoryUtil
			.getLog(HeaderFooterStartUpAction.class);

}