using KantinStokTakip.Entity;
using MySql.Data.MySqlClient;
using System.Collections.Generic;

namespace KantinStokTakip.DAL
{
    public class UrunDAL
    {
        public List<Urun> UrunleriGetir()
        {
            List<Urun> urunler = new List<Urun>();

            MySqlConnection baglanti = Baglanti.BaglantiGetir();

            baglanti.Open();

            MySqlCommand komut =
                new MySqlCommand("SELECT * FROM urunler", baglanti);

            MySqlDataReader dr = komut.ExecuteReader();

            while (dr.Read())
            {
                Urun urun = new Urun();

                urun.UrunId = int.Parse(dr["urun_id"].ToString());

                urun.KategoriId =
                    int.Parse(dr["kategori_id"].ToString());

                urun.UrunAd = dr["urun_ad"].ToString();

                urun.BarkodNo = dr["barkod_no"].ToString();

                urun.BirimFiyat =
                    decimal.Parse(dr["birim_fiyat"].ToString());

                urun.StokMiktar =
                    int.Parse(dr["stok_miktar"].ToString());

                urun.KritikStok =
                    int.Parse(dr["kritik_stok"].ToString());

                urun.Birim = dr["birim"].ToString();

                urun.Durum = dr["durum"].ToString();

                urunler.Add(urun);
            }

            baglanti.Close();

            return urunler;
        }
        public void UrunEkle(Urun urun)
        {
            MySqlConnection baglanti = Baglanti.BaglantiGetir();

            baglanti.Open();

            MySqlCommand komut = new MySqlCommand(
                "INSERT INTO urunler(kategori_id, urun_ad, barkod_no, birim_fiyat, stok_miktar, kritik_stok, birim, durum) VALUES(@kategori, @ad, @barkod, @fiyat, @stok, @kritik, @birim, @durum)",
                baglanti);

            komut.Parameters.AddWithValue("@kategori", urun.KategoriId);
            komut.Parameters.AddWithValue("@ad", urun.UrunAd);
            komut.Parameters.AddWithValue("@barkod", urun.BarkodNo);
            komut.Parameters.AddWithValue("@fiyat", urun.BirimFiyat);
            komut.Parameters.AddWithValue("@stok", urun.StokMiktar);
            komut.Parameters.AddWithValue("@kritik", urun.KritikStok);
            komut.Parameters.AddWithValue("@birim", urun.Birim);
            komut.Parameters.AddWithValue("@durum", urun.Durum);

            komut.ExecuteNonQuery();

            baglanti.Close();
        }

        public void UrunSil(int urunId)
        {
            MySqlConnection baglanti = Baglanti.BaglantiGetir();

            baglanti.Open();

            MySqlCommand komut = new MySqlCommand(
                "DELETE FROM urunler WHERE urun_id = @id",
                baglanti);

            komut.Parameters.AddWithValue("@id", urunId);

            komut.ExecuteNonQuery();

            baglanti.Close();
        }
        public List<Urun> UrunAra(string aranan)
        {
            List<Urun> urunler = new List<Urun>();

            MySqlConnection baglanti = Baglanti.BaglantiGetir();
            baglanti.Open();

            MySqlCommand komut = new MySqlCommand(
                "SELECT * FROM urunler WHERE urun_ad LIKE @aranan OR barkod_no LIKE @aranan",
                baglanti);

            komut.Parameters.AddWithValue("@aranan", "%" + aranan + "%");

            MySqlDataReader dr = komut.ExecuteReader();

            while (dr.Read())
            {
                Urun urun = new Urun();

                urun.UrunId = int.Parse(dr["urun_id"].ToString());
                urun.KategoriId = int.Parse(dr["kategori_id"].ToString());
                urun.UrunAd = dr["urun_ad"].ToString();
                urun.BarkodNo = dr["barkod_no"].ToString();
                urun.BirimFiyat = decimal.Parse(dr["birim_fiyat"].ToString());
                urun.StokMiktar = int.Parse(dr["stok_miktar"].ToString());
                urun.KritikStok = int.Parse(dr["kritik_stok"].ToString());
                urun.Birim = dr["birim"].ToString();
                urun.Durum = dr["durum"].ToString();

                urunler.Add(urun);
            }

            baglanti.Close();

            return urunler;
        }
    }
}
