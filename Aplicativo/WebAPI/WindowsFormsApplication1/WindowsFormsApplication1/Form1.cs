using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace WindowsFormsApplication1
{
    public partial class Form1 : Form
    {
        private string[] titulos = { "Tudo 20% OFF", "Super desconto", "Quem pegar pegou", "Semana maluca", "O gerente ficou louco", "Encha as sacolas", "É para acabar", "Chance de ouro", "Promoção", "Cabe no bolso", "Nunca mais", "Venha conhecer", "Seja nosso cliente", 
                                   "Fique na moda", "Estilo", "Imperdível", "50% OFF", ""};
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            Random rdn= new Random();
            for (var i = 1; i < 200; i++)
            {
                Console.WriteLine("insert into usuario values("+i+", 'usuario "+i+"', 1);");
                for (var j = 1; j < 20; j++ )
                {
                    Console.WriteLine("insert into post values(" + (((i - 1) * 200) + j) + ", 'Descricao do post " + (((i - 1) * 200) + j) + "', '" + rdn.Next(2010, 2015) + "-" + rdn.Next(1, 12) + "-" + rdn.Next(1, 28) + "', " + i + ");");
                    for (var m = 1; m < 10; m++)
                    {
                        Console.WriteLine("insert into comentario values(" + (((((i - 1) * 200) + (j - 1)) * 10) + m) + ", 'Descricao do comentario do usuario " + i + " no post " + (((i - 1) * 200) + j) + "', '" + rdn.Next(2010, 2015) + "-" + rdn.Next(1, 12) + "-" + rdn.Next(1, 28) + "', " + (((i - 1) * 200) + j) + ");");
                    }
                }
            }
        }
    }
}
