namespace KantinStokTakip.Entity
{
    public class Urun
    {
        public int UrunId { get; set; }

        public int KategoriId { get; set; }

        public string UrunAd { get; set; }

        public string BarkodNo { get; set; }

        public decimal BirimFiyat { get; set; }

        public int StokMiktar { get; set; }

        public int KritikStok { get; set; }

        public string Birim { get; set; }

        public string Durum { get; set; }
    }
}
