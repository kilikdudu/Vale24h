using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Configuration;
using System.Web.Http;
using System.Web.Http.Description;
using Vale24hWebAPI;
using Vale24hWebAPI.Models;

namespace Vale24hWebAPI.Controllers
{
    public class promocaoController : ApiController
    {

        public class parans_InfoPromocao
        {
            public long promocaoId {get; set;}
        }

        public class parans_getPromocoes : ParansLista 
        {
            public string clientId { get; set; }
        }

        private vale24hEntities db = new vale24hEntities();
        [HttpPost]
        public List<InfoPromocao> getPromocoes(parans_getPromocoes parans)
        {
            var lstPro = new List<InfoPromocao>();
            var rowsPro = db.promocao.Include(pro => pro.imagem).Include(pro => pro.cliente).
                Where(pro => (pro.datafim_pro >= DateTime.Now) && 
                             (db.promocaorequerida.Where(req => (req.Promocao_codigo_proreq == pro.codigo_pro) && (req.userCloudId_proreq == parans.clientId)).Count() == 0))
                .OrderByDescending(pro => pro.datacad_pro).Skip(parans.cursor).Take(parans.limite).ToList();
            foreach (promocao  rowPro in rowsPro)
            {
                var pro = new InfoPromocao ();
                pro.urlImagem = WebConfigurationManager.AppSettings["urlImages"] + rowPro.cliente.cloudId_cli + "/promocao/" + rowPro.imagem.urlRelativa_img;
                pro.idPromocao = rowPro.codigo_pro;
                pro.descricao = rowPro.descricao_pro;
                pro.empresa_id = rowPro.cliente.cloudId_cli;
                pro.inicio = rowPro.datainicio_pro ;
                pro.qtdeTickets = rowPro.totalTickets_pro;
                pro.qtdeTicketsUsados = getQuantidadeTicketsPromocao(rowPro.codigo_pro);
                pro.titulo = rowPro.titulo_pro;
                pro.validade = rowPro.datafim_pro;
                pro.nomeEmpresa = rowPro.cliente.nome_cli;
                pro.latitude = rowPro.latitude_pro;
                pro.longitude = rowPro.longitude_pro;
                pro.limitada = rowPro.limitada_pro;
                pro.imagemEmpresa = WebConfigurationManager.AppSettings["urlImages"] + rowPro.cliente.cloudId_cli + "/" + rowPro.cliente.imagem_cli;
                lstPro.Add(pro);
            }
            return lstPro;
        }

        [HttpPost]
        public InfoPromocao getInfoPromocao(parans_InfoPromocao parans)
        {
            var promocao = db.promocao.Include(pro => pro.imagem).Include(pro => pro.cliente).Where(pro => pro.codigo_pro == parans.promocaoId).FirstOrDefault();
            var proInfo = new InfoPromocao();
            proInfo.descricao = promocao.descricao_pro;
            proInfo.urlImagem = WebConfigurationManager.AppSettings["urlImages"] + promocao.cliente.cloudId_cli + "/promocao/" + promocao.imagem.urlRelativa_img;
            proInfo.idPromocao = promocao.codigo_pro;
            proInfo.descricao = promocao.descricao_pro;
            proInfo.empresa_id = promocao.cliente.cloudId_cli;
            proInfo.inicio = promocao.datainicio_pro;
            proInfo.qtdeTickets = promocao.totalTickets_pro;
            proInfo.qtdeTicketsUsados = getQuantidadeTicketsPromocao(promocao.codigo_pro);
            proInfo.titulo = promocao.titulo_pro;
            proInfo.validade = promocao.datafim_pro;
            proInfo.nomeEmpresa = promocao.cliente.nome_cli;
            proInfo.latitude = promocao.latitude_pro;
            proInfo.longitude = promocao.longitude_pro;
            proInfo.limitada = promocao.limitada_pro;
            proInfo.imagemEmpresa = WebConfigurationManager.AppSettings["urlImages"] + promocao.cliente.cloudId_cli + "/" + promocao.cliente.imagem_cli;
            return proInfo;
        }

        public  int getQuantidadeTicketsPromocao(long promocao_id)
        {
            return db.promocaorequerida.Where(t => (t.status_proreq == 0 || t.status_proreq == 1) && (t.validade_proreq >= DateTime.Now) && (t.Promocao_codigo_proreq  == promocao_id)).Count();
        }
        
    }
}