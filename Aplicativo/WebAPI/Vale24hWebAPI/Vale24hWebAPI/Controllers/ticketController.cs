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
    public class ticketController : ApiController
    {
        public class parans_TicketInfo
        {
            public long promocaoId { get; set; }
            public string clienteId { get; set; }
        }

        private vale24hEntities db = new vale24hEntities();

        [HttpPost]
        public TicketInfo getInfoTicket(parans_TicketInfo parans)
        {
            var ticket = new TicketInfo();
            var promController = new promocaoController();
            var promParans = new promocaoController.parans_InfoPromocao();
            promParans.promocaoId = parans.promocaoId;
            ticket.promocao = promController.getInfoPromocao(promParans);
            var ticketRow = db.promocaorequerida.Where(p => p.promocao_proreq == parans.promocaoId && p.userCloudId_proreq == parans.clienteId).FirstOrDefault();
            if (ticketRow != null)
            {
                ticket.ativo = ticketRow.ativa_proreq;
                ticket.dataAquisicao = ticketRow.datacad_proreq;
                ticket.id = ticketRow.codigo_proreq;
                ticket.validade = ticketRow.validade_proreq;
                ticket.voucher = ticketRow.codVoucher_proreq;
                ticket.promocao = promController.getInfoPromocao(promParans);
            }
            return ticket;
        }

        [HttpPost]
        public StatusRequisicao pegaTicket(parans_TicketInfo parans)
        {
            var resposta = new StatusRequisicao();
            resposta.sucesso = false;
            using (var dbTrans = db.Database.BeginTransaction())
            {
                try
                {
                    var prom = db.promocao.Where(pro => pro.codigo_pro == parans.promocaoId ).FirstOrDefault();
                    prom.ticketsAlocados_pro = prom.ticketsAlocados_pro + 1;
                    db.SaveChanges();
                    if (prom.ticketsAlocados_pro > prom.totalTickets_pro)
                    {
                        dbTrans.Rollback();
                        resposta.sucesso = false;
                        resposta.mensagem = "Desculpe, outra pessoa pegou o ticket primeiro.";
                        return resposta;
                    }
                    promocaorequerida myTicket = db.promocaorequerida.Create();
                    DateTime dtCadastro = DateTime.Now;
                    myTicket.datacad_proreq = dtCadastro;
                    myTicket.promocao_proreq = parans.promocaoId;
                    myTicket.userCloudId_proreq = parans.clienteId;
                    myTicket.codVoucher_proreq = geraVoucher(parans.clienteId, parans.promocaoId, dtCadastro.ToString());
                    //Por isso Vale24h ^_^
                    myTicket.validade_proreq = dtCadastro.AddHours(24);
                    db.promocaorequerida.Add(myTicket);
                    db.SaveChanges();
                    dbTrans.Commit();
                    resposta.sucesso = true;
                    TicketInfo retInfo = new TicketInfo();
                    retInfo.ativo = myTicket.ativa_proreq;
                    retInfo.dataAquisicao = myTicket.datacad_proreq;
                    retInfo.id = myTicket.codigo_proreq;
                    retInfo.validade = myTicket.validade_proreq;
                    retInfo.voucher = myTicket.codVoucher_proreq;
                    resposta.dados = retInfo;
                }
                catch (Exception e)
                {
                    dbTrans.Rollback();
                    resposta.sucesso = false;
                    resposta.mensagem = e.Message;
                }
            }
            return resposta;
        }

        private string geraVoucher(string clienteId, long promocaoId, string dataVoucher)
        {
            string dadosVoucher = clienteId + promocaoId + dataVoucher;
            byte[] aux = GetBytes(dadosVoucher);
            long codigoNumerico = BitConverter.ToInt64(aux, 0);
            return codigoNumerico.ToString();
        }

        static byte[] GetBytes(string str)
        {
            byte[] bytes = new byte[str.Length * sizeof(char)];
            System.Buffer.BlockCopy(str.ToCharArray(), 0, bytes, 0, bytes.Length);
            return bytes;
        }
    }
}