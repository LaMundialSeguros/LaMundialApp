import 'package:encrypt/encrypt.dart' as encrypt;

class CipherUtils {
  static final key = encrypt.Key.fromUtf8('tu_clave_aes_de_32_bytes');
  static final iv = encrypt.IV.fromLength(16);

  static encrypt.Encrypter getEncrypter() {
    return encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  }
}
