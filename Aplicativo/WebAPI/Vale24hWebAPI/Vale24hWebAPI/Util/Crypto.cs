using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;

namespace Vale24hWebAPI.Util
{
    public static class Crypto
    {
        public static string encriptar(string texto, string key)
        {
            AesCryptoServiceProvider aes = new AesCryptoServiceProvider();
            MD5 md5Hash = MD5.Create();
            string chave = GetMd5Hash(md5Hash, key);
            aes.Key = System.Text.Encoding.UTF8.GetBytes(chave);
            aes.BlockSize = 128;
            aes.IV = System.Text.Encoding.UTF8.GetBytes("6abraswa+hep&#Ac");
            ICryptoTransform encryptor = aes.CreateEncryptor(aes.Key, aes.IV);

            byte[] encrypted;

            // Create the streams used for encryption.
            using (MemoryStream msEncrypt = new MemoryStream())
            {
                using (CryptoStream csEncrypt = new CryptoStream(msEncrypt, encryptor, CryptoStreamMode.Write))
                {
                    using (StreamWriter swEncrypt = new StreamWriter(csEncrypt))
                    {

                        //Write all data to the stream.
                        swEncrypt.Write(texto);
                    }
                    encrypted = msEncrypt.ToArray();
                }
            }

            return Convert.ToBase64String(encrypted);
        }

        public static string GetMd5Hash(MD5 md5Hash, string input)
        {

            // Convert the input string to a byte array and compute the hash.
            byte[] data = md5Hash.ComputeHash(Encoding.UTF8.GetBytes(input));

            // Create a new Stringbuilder to collect the bytes
            // and create a string.
            StringBuilder sBuilder = new StringBuilder();

            // Loop through each byte of the hashed data 
            // and format each one as a hexadecimal string.
            for (int i = 0; i < data.Length; i++)
            {
                sBuilder.Append(data[i].ToString("x2"));
            }

            // Return the hexadecimal string.
            return sBuilder.ToString();
        }
    }
}