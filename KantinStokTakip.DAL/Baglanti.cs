using MySql.Data.MySqlClient;

namespace KantinStokTakip.DAL
{
    public class Baglanti
    {
        public static MySqlConnection BaglantiGetir()
        {
            return new MySqlConnection(
                "Server=localhost;Database=kantin_stok_takip;Uid=root;Pwd=;"
            );
        }
    }
}