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
using Vale24hWebAPI.Util;

namespace Vale24hWebAPI.Controllers
{
    public class ticketController : ApiController
    {
        public class parans_TicketInfo
        {
            public long promocaoId { get; set; }
            public string clienteId { get; set; }
        }

        public class parans_LiberaTicket
        {
            public long idTicket { get; set; }
        }

        public class parans_MeusTickets : ParansLista 
        {
            public string clienteId{ get; set; }
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
        public List<TicketInfo> getMeusTickets(parans_MeusTickets parans)
        {
            var lstTickets = new List<TicketInfo>();
            var rowsTickets = db.promocaorequerida.Where(p => (p.userCloudId_proreq == parans.clienteId) && (p.codigo_proreq > parans.cursor)).Take(parans.limite).ToList();
            foreach (promocaorequerida row in rowsTickets)
            {
                var infoParans = new parans_TicketInfo();
                infoParans.clienteId = parans.clienteId;
                infoParans.promocaoId = row.promocao_proreq;
                lstTickets.Add(getInfoTicket(infoParans));
            }
            return lstTickets;
        }

        [HttpPost]
        public StatusRequisicao pegaTicket(parans_TicketInfo parans)
        {
            var resposta = new StatusRequisicao();
            resposta.sucesso = false;
            
                var prom = db.promocao.Where(pro => pro.codigo_pro == parans.promocaoId ).FirstOrDefault();
                var proControl = new promocaoController();
                if ((proControl.getQuantidadeTicketsPromocao(prom.codigo_pro) > prom.totalTickets_pro) && prom.limitada_pro == true)
                {
                    resposta.sucesso = false;
                    resposta.mensagem = "Desculpe, outra pessoa pegou o ticket primeiro.";
                    return resposta;
                }
                using (var dbTrans = db.Database.BeginTransaction())
                {
                    try{
                        promocaorequerida myTicket = db.promocaorequerida.Create();
                        DateTime dtCadastro = DateTime.Now;
                        myTicket.datacad_proreq = dtCadastro;
                        myTicket.promocao_proreq = parans.promocaoId;
                        myTicket.userCloudId_proreq = parans.clienteId;
                        myTicket.codVoucher_proreq = "";
                        //Por isso Vale24h ^_^
                        myTicket.validade_proreq = prom.limitada_pro ? dtCadastro.AddHours(24) : prom.fim_pro;
                        db.promocaorequerida.Add(myTicket);
                        db.SaveChanges();
                        DateTime aux = myTicket.validade_proreq;
                        myTicket.codVoucher_proreq = myTicket.validade_proreq.ToString("yyyyMMddHHmmss") + '.' + myTicket.promocao_proreq + '.' + myTicket.codigo_proreq;
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

        [HttpPost]
        public StatusRequisicao liberaTicket(parans_LiberaTicket parans)
        {
            var resposta = new StatusRequisicao();
            try
            {
                var ticket = db.promocaorequerida.Where(t => t.codigo_proreq == parans.idTicket).FirstOrDefault();
                var numPro = ticket.promocao_proreq;
                db.promocaorequerida.Remove(ticket);
                db.SaveChanges();
                resposta.sucesso = true;
                var promController = new promocaoController();
                var promParans = new promocaoController.parans_InfoPromocao();
                promParans.promocaoId = numPro;
                resposta.dados = promController.getInfoPromocao(promParans);
                return resposta;
            }
            catch (Exception e)
            {
                resposta.sucesso = false;
                resposta.mensagem = e.Message;
                return resposta;
            }
        }

    }
}