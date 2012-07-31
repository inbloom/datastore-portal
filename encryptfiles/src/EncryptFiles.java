import javax.crypto.SecretKey;
import javax.crypto.KeyGenerator;

import java.security.GeneralSecurityException;
import java.security.Key;
import java.security.KeyStore;
import java.security.NoSuchAlgorithmException;
import java.security.KeyStoreException;
import java.security.UnrecoverableKeyException;
import java.security.cert.CertificateException;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.File;
import java.io.FileInputStream;
import javax.crypto.Cipher;

import java.io.FileReader;
import java.io.FileWriter;
import java.util.Properties;

public class EncryptFiles {

	public static void main(String[] args) throws NoSuchAlgorithmException,
			IOException, CertificateException, KeyStoreException,
			GeneralSecurityException {

		FileReader propertyFile = new FileReader(args[0]);

		Properties p1 = new Properties();
		p1.load(propertyFile);

		EncryptFiles encFiles = new EncryptFiles();
		encFiles.setKeyAlias(p1.getProperty("sli.encryption.keyAlias"));
		encFiles.setKeyLocation(p1.getProperty("sli.encryption.keyLocation"));
		encFiles.setKeyStorePass(p1.getProperty("sli.encryption.keyStorePass"));
		encFiles.setPropertyFileLocation(p1
				.getProperty("sli.encryption.properties.files.location"));
		encFiles.setPropertyFiles(p1
				.getProperty("sli.encryption.properties.files"));

		encFiles.init();
	}

	/*
	 * Generate Key and Encrypt property files
	 */
	public void init() throws NoSuchAlgorithmException, IOException,
			CertificateException, KeyStoreException, GeneralSecurityException {

		try {
			loadKeyStore();
			System.out.println("Loading Key File...");
			System.out.println("Begining Encryption of Files...");
			boolean filesEncrypted = encryptFiles();
			if (!filesEncrypted) {
				System.out.println("No Files found for Encryption...");
			} else {
				System.out.println("Completed Encryption of Files...");
			}
		} catch (FileNotFoundException fne) {
			System.out
					.println("Could not load specified keystore file exiting...");
		} catch (NullPointerException npe) {
			System.out
					.println("Check key.properties, and ensure all property key has values...");
		}
	}

	protected void loadKeyStore() throws NoSuchAlgorithmException, IOException,
			CertificateException, KeyStoreException {

		// Initalise KeyStore with password
		password = new KeyStore.PasswordProtection(getKeyStorePass()
				.toCharArray());

		File keyfile = new File(getKeyLocation());

		if (getKeyLocation() != null && !"".equals(getKeyLocation())
				&& getKeyAlias() != null && !"".equals(getKeyAlias())
				&& getKeyStorePass() != null && !"".equals(getKeyStorePass())
				&& getPropertyFileLocation() != null
				&& !"".equals(getPropertyFileLocation())
				&& getPropertyFiles() != null && !"".equals(getPropertyFiles())) {

			// Check if the keystore file exists.
			if (keyfile.exists()) {
				// Load Keystore if the keystore file exists
				FileInputStream fis = new FileInputStream(getKeyLocation());
				ks = KeyStore.getInstance("JCEKS");
				ks.load(fis, getKeyStorePass().toCharArray());
				fis.close();
			} else {
				throw new FileNotFoundException();
			}
		} else {
			throw new NullPointerException();
		}
	}

	/*
	 * Method:saveKey(String alias, SecretKey mykey) Save a key with alias
	 * "alias" and key "mykey".
	 */
	protected void saveKey(String alias, SecretKey mykey)
			throws KeyStoreException {
		KeyStore.SecretKeyEntry skEntry = new KeyStore.SecretKeyEntry(mykey);
		ks.setEntry(alias, skEntry, password);
	}

	/*
	 * Method:storekey() Write the key entry to the keystore file.
	 */
	protected void storekey() throws IOException, NoSuchAlgorithmException,
			CertificateException, KeyStoreException {
		java.io.FileOutputStream fos = new java.io.FileOutputStream(
				getKeyLocation());
		ks.store(fos, getKeyStorePass().toCharArray());
		fos.close();
	}

	protected boolean encryptFiles() throws NoSuchAlgorithmException,
			IOException, CertificateException, KeyStoreException,
			GeneralSecurityException {
		// Load the KeyStore object if the file exists
		FileInputStream fis = new FileInputStream(getKeyLocation());
		ks = KeyStore.getInstance("JCEKS");
		ks.load(fis, getKeyStorePass().toCharArray());
		fis.close();

		String propertyFiles[] = getPropertyFiles().split(",");
		System.out.println("property files list is ..." + propertyFiles[0]);
		if (propertyFiles.length >= 1 && propertyFiles[0] != null
				&& !"".equals(propertyFiles[0])) {
			for (int i = 0; i < propertyFiles.length; i++) {
				try{
				FileReader propertyFile = new FileReader(
						getPropertyFileLocation() + "/" + propertyFiles[i]);
				FileWriter encryptedPropertyFile = new FileWriter(
						getPropertyFileLocation() + "/" + propertyFiles[i]
								+ ".encrypted");

				Properties p1 = new Properties();
				p1.load(propertyFile);

				String apiClient = p1.getProperty("api.client");
				String apiServerUrl = p1.getProperty("api.server.url");
				String securityServerUrl = p1
						.getProperty("security.server.url");
				String oauthClientId = p1.getProperty("portal.oauth.client.id");
				String oauthClientSecret = p1
						.getProperty("portal.oauth.client.secret");
				String oauthRedirect = p1.getProperty("portal.oauth.redirect");

				String encryptedClientId = encrypt(oauthClientId);
				String encryptedClientSecret = encrypt(oauthClientSecret);

				Properties p2 = new Properties();
				p2.put("api.client", apiClient);
				p2.put("api.server.url", apiServerUrl);
				p2.put("security.server.url", securityServerUrl);
				p2.put("portal.oauth.client.id", encryptedClientId);
				p2.put("portal.oauth.client.secret", encryptedClientSecret);
				p2.put("portal.oauth.redirect", oauthRedirect);
				p2.store(encryptedPropertyFile, "");
				System.out.println("Encrypted [" + propertyFiles[i] + "] to ["
						+ propertyFiles[i] + ".encrypted" + "]");
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			return true;
		} else {
			return false;
		}

	}

	/*
	 * Method:getkey(String alias) Get key from keystore with the given alias
	 */
	public Key getkey(String alias) throws NoSuchAlgorithmException,
			UnrecoverableKeyException, KeyStoreException {

		Key k = ks.getKey(alias, getKeyStorePass().toCharArray());

		return k;
	}

	public String encrypt(String value) throws GeneralSecurityException,
			IOException {

		// get key
		Key mykey = getkey(getKeyAlias());
		// Create a cipher object and use the generated key to initialize it
		Cipher cipher = Cipher.getInstance("AES");
		cipher.init(Cipher.ENCRYPT_MODE, mykey);
		byte[] encrypted = cipher.doFinal(value.getBytes());
		return byteArrayToHexString(encrypted);
	}

	public String decrypt(String message) throws GeneralSecurityException,
			IOException {
		// get key
		Key mykey = getkey(getKeyAlias());
		Cipher cipher = Cipher.getInstance("AES");
		cipher.init(Cipher.DECRYPT_MODE, mykey);
		byte[] decrypted = cipher.doFinal(hexStringToByteArray(message));
		return new String(decrypted);
	}

	private static String byteArrayToHexString(byte[] b) {
		StringBuffer sb = new StringBuffer(b.length * 2);
		for (int i = 0; i < b.length; i++) {
			int v = b[i] & 0xff;
			if (v < 16) {
				sb.append('0');
			}
			sb.append(Integer.toHexString(v));
		}
		return sb.toString().toUpperCase();
	}

	private static byte[] hexStringToByteArray(String s) {
		byte[] b = new byte[s.length() / 2];
		for (int i = 0; i < b.length; i++) {
			int index = i * 2;
			int v = Integer.parseInt(s.substring(index, index + 2), 16);
			b[i] = (byte) v;
		}
		return b;
	}

	public String getKeyStorePass() {
		return keyStorePass;
	}

	public void setKeyStorePass(String keyStorePass) {
		this.keyStorePass = keyStorePass;
	}

	public String getKeyAlias() {
		return keyAlias;
	}

	public void setKeyAlias(String keyAlias) {
		this.keyAlias = keyAlias;
	}

	public String getKeyLocation() {
		return keyLocation;
	}

	public void setKeyLocation(String keyLocation) {
		this.keyLocation = keyLocation;
	}

	public String getPropertyFileLocation() {
		return propertyFileLocation;
	}

	public void setPropertyFileLocation(String propertyFileLocation) {
		this.propertyFileLocation = propertyFileLocation;
	}

	public String getPropertyFiles() {
		return propertyFiles;
	}

	public void setPropertyFiles(String propertyFiles) {
		this.propertyFiles = propertyFiles;
	}

	private String propertyFileLocation;
	private String propertyFiles;
	private String keyStorePass;
	private String keyAlias;
	private String keyLocation;

	KeyStore ks;
	KeyStore.PasswordProtection password;

}
