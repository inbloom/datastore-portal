package com.liferay.webform.util;

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

/**
 * Encryption util class to decrypt the email credentials
 */
public class EncryptUtils {

    /*
     * Generate Key and Encrypt property files
     */
    public void init() throws NoSuchAlgorithmException, IOException,
            CertificateException, KeyStoreException, GeneralSecurityException {

        // Initalise KeyStore with password
        password = new KeyStore.PasswordProtection(getKeyStorePass()
                .toCharArray());

        File keyfile = new File(getKeyLocation());

        if (getKeyLocation() != null && !"".equals(getKeyLocation())
                && getKeyAlias() != null && !"".equals(getKeyAlias())
                && getKeyStorePass() != null && !"".equals(getKeyStorePass())
                && getKeyPass() != null && !"".equals(getKeyPass())) {

            if (keyfile.exists()) {
                // Load Keystore if the keystore file exists
                FileInputStream fis = new FileInputStream(getKeyLocation());
                ks = KeyStore.getInstance("JCEKS");
                ks.load(fis, getKeyStorePass().toCharArray());
                fis.close();
            } else {
                throw new FileNotFoundException(
                        "Specify a valid keystore file in the property...");
            }
        } else {
            throw new NullPointerException(
                    "Check keystore.properties, and ensure all properties are set properly.");
        }
    }

    /*
     * Get key from keystore with the given alias
     */
    public Key getkey(String alias, String password) throws NoSuchAlgorithmException,
            UnrecoverableKeyException, KeyStoreException {

        Key k = ks.getKey(alias, password.toCharArray());

        return k;
    }

    public String encrypt(String value) throws GeneralSecurityException,
            IOException {

        // get key
        Key mykey = getkey(getKeyAlias(), getKeyPass());
        // Create a cipher object and use the generated key to initialize it
        Cipher cipher = Cipher.getInstance("AES");
        cipher.init(Cipher.ENCRYPT_MODE, mykey);
        byte[] encrypted = cipher.doFinal(value.getBytes());

        return byteArrayToHexString(encrypted);
    }

    public String decrypt(String message) throws GeneralSecurityException,
            IOException {
        // get key
        Key mykey = getkey(getKeyAlias(), getKeyPass());
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
    
    public String getKeyPass() {
        return keyPass;
    }

    public void setKeyPass(String keyPass) {
        this.keyPass = keyPass;
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

    private String keyStorePass;
    private String keyPass;
    private String keyAlias;
    private String keyLocation;

    KeyStore ks;
    KeyStore.PasswordProtection password;

}
