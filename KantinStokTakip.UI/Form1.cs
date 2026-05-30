using KantinStokTakip.DAL;
using KantinStokTakip.Entity;
using System;
using System.Windows.Forms;

namespace KantinStokTakip.UI
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            this.Load += Form1_Load;
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            UrunDAL urunDAL = new UrunDAL();

            dataGridView1.DataSource = urunDAL.UrunleriGetir();
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            Urun urun = new Urun();

            urun.KategoriId = 1;
            urun.UrunAd = textBox1.Text;
            urun.BarkodNo = textBox2.Text;
            urun.BirimFiyat = decimal.Parse(textBox3.Text);
            urun.StokMiktar = int.Parse(textBox4.Text);
            urun.KritikStok = 5;
            urun.Birim = "Adet";
            urun.Durum = "Aktif";

            UrunDAL urunDAL = new UrunDAL();

            urunDAL.UrunEkle(urun);

            dataGridView1.DataSource = null;
            dataGridView1.DataSource = urunDAL.UrunleriGetir();

            MessageBox.Show("Ürün eklendi!");
        }

        private void button3_Click(object sender, EventArgs e)
        {
            if (dataGridView1.CurrentRow == null)
            {
                MessageBox.Show("Lütfen silinecek ürünü seçin.");
                return;
            }

            int urunId = Convert.ToInt32(dataGridView1.CurrentRow.Cells["UrunId"].Value);

            UrunDAL urunDAL = new UrunDAL();

            urunDAL.UrunSil(urunId);

            dataGridView1.DataSource = null;
            dataGridView1.DataSource = urunDAL.UrunleriGetir();

            MessageBox.Show("Ürün silindi!");
        }

        private void label5_Click(object sender, EventArgs e)
        {

        }

        private void btnAra_Click(object sender, EventArgs e)
        {
            UrunDAL urunDAL = new UrunDAL();

            dataGridView1.DataSource = null;
            dataGridView1.DataSource = urunDAL.UrunAra(txtAra.Text);
        }

        private void button2_Click(object sender, EventArgs e)
        {
            UrunDAL urunDAL = new UrunDAL();

            dataGridView1.DataSource = null;
            dataGridView1.DataSource = urunDAL.UrunleriGetir();

            txtAra.Clear();
        }
    }
}