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

        private vale24hEntities db = new vale24hEntities();
        [HttpPost]
        public List<InfoPromocao> getPromocoes(ParansLista parans)
        {
            var lstPro = new List<InfoPromocao>();
            var rowsPro = db.promocao.Include(pro => pro.imagem).Include(pro => pro.cliente).
                Where(pro => (
                                (db.promocaorequerida.Where
                                    (t => 
                                        t.ativa_proreq 
                                        && ( t.validade_proreq >= DateTime.Now ) 
                                        && ( t.promocao_proreq == pro.codigo_pro) )
                                    .Count() < pro.totalTickets_pro
                                ) 
                                || pro.limitada_pro == false
                            ) 
                                && pro.fim_pro >= DateTime.Now && pro.codigo_pro > parans.cursor).Take(parans.limite).ToList();
            foreach (promocao  rowPro in rowsPro)
            {
                var pro = new InfoPromocao ();
                pro.urlImagem = WebConfigurationManager.AppSettings["urlImages"] + rowPro.cliente.cloudId_cli + "/promocao/" + rowPro.imagem.urlRelativa_img;
                pro.Row = rowPro.codigo_pro;
                pro.idPromocao = rowPro.codigo_pro;
                pro.descricao = rowPro.descricao_pro;
                pro.empresa_id = rowPro.cliente.cloudId_cli;
                pro.inicio = rowPro.inicio_pro;
                pro.qtdeTickets = rowPro.totalTickets_pro;
                pro.qtdeTicketsUsados = getQuantidadeTicketsPromocao(rowPro.codigo_pro);
                pro.titulo = rowPro.titulo_pro;
                pro.validade = rowPro.fim_pro;
                pro.nomeEmpresa = rowPro.cliente.nomeFantasia_cli;
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
            proInfo.Row = promocao.codigo_pro;
            proInfo.idPromocao = promocao.codigo_pro;
            proInfo.descricao = promocao.descricao_pro;
            proInfo.empresa_id = promocao.cliente.cloudId_cli;
            proInfo.inicio = promocao.inicio_pro;
            proInfo.qtdeTickets = promocao.totalTickets_pro;
            proInfo.qtdeTicketsUsados = getQuantidadeTicketsPromocao(promocao.codigo_pro);
            proInfo.titulo = promocao.titulo_pro;
            proInfo.validade = promocao.fim_pro;
            proInfo.nomeEmpresa = promocao.cliente.nomeFantasia_cli;
            proInfo.latitude = promocao.latitude_pro;
            proInfo.longitude = promocao.longitude_pro;
            proInfo.limitada = promocao.limitada_pro;
            proInfo.imagemEmpresa = WebConfigurationManager.AppSettings["urlImages"] + promocao.cliente.cloudId_cli + "/" + promocao.cliente.imagem_cli;
            return proInfo;
        }

        public  int getQuantidadeTicketsPromocao(long promocao_id)
        {
            return db.promocaorequerida.Where(t => t.ativa_proreq && t.validade_proreq >= DateTime.Now && t.promocao_proreq == promocao_id).Count();
        }
        
    }
}