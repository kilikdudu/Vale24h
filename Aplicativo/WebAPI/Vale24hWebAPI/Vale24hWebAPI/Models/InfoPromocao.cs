using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Vale24hWebAPI.Models
{
    public class InfoPromocao
    {
        public long idPromocao { get; set; }
        public string descricao { get; set; }
        public string titulo { get; set; }
        public string urlImagem { get; set; }
        public DateTime validade { get; set; }
        public DateTime inicio { get; set; }
        public int qtdeTickets { get; set; }
        public int qtdeTicketsUsados { get; set; }
        public string empresa_id { get; set; }
        public string nomeEmpresa { get; set; }
        public string imagemEmpresa { get; set; }
        public string latitude { get; set; }
        public string longitude { get; set; }
        public bool limitada { get; set; }

    }
}