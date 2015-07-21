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

        public class parans_usaTicket
        {
            public string voucher { get; set; }
            public bool foraRegra { get; set; }
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
            var ticketRow = db.promocaorequerida.Where(p => p.Promocao_codigo_proreq  == parans.promocaoId && p.userCloudId_proreq == parans.clienteId).FirstOrDefault();
            if (ticketRow != null)
            {
                ticket.status = ticketRow.status_proreq;
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
            var rowsTickets = db.promocaorequerida.Where(p => p.userCloudId_proreq == parans.clienteId).OrderBy(p => p.datacad_proreq).Skip(parans.cursor).Take(parans.limite).ToList();
            foreach (promocaorequerida row in rowsTickets)
            {
                if (row.validade_proreq < DateTime.Now)
                {
                    expiraVoucher(row.codigo_proreq);
                }
                var infoParans = new parans_TicketInfo();
                infoParans.clienteId = parans.clienteId;
                infoParans.promocaoId = row.Promocao_codigo_proreq ;
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
                if(prom.limitada_pro && temTicketLimitado(parans.clienteId))
                {
                    resposta.sucesso = false;
                    resposta.mensagem = "Não é permitido ter dois tickets de promoções limitadas ao mesmo tempo.";
                    return resposta;
                }
                using (var dbTrans = db.Database.BeginTransaction())
                {
                    try{
                        promocaorequerida myTicket = db.promocaorequerida.Create();
                        DateTime dtCadastro = DateTime.Now;
                        myTicket.datacad_proreq = dtCadastro;
                        myTicket.Promocao_codigo_proreq  = parans.promocaoId;
                        myTicket.userCloudId_proreq = parans.clienteId;
                        myTicket.codVoucher_proreq = "";
                        //Por isso Vale24h ^_^
                        myTicket.validade_proreq = prom.limitada_pro ? dtCadastro.AddHours(24) : prom.datafim_pro ;
                        db.promocaorequerida.Add(myTicket);
                        db.SaveChanges();
                        DateTime aux = myTicket.validade_proreq;
                        myTicket.codVoucher_proreq = myTicket.validade_proreq.ToString("yyyyMMddHHmmss") + '.' + myTicket.Promocao_codigo_proreq  + '.' + myTicket.codigo_proreq;
                        db.SaveChanges();
                        dbTrans.Commit();
                        resposta.sucesso = true;
                        TicketInfo retInfo = new TicketInfo();
                        retInfo.status = myTicket.status_proreq;
                        retInfo.dataAquisicao = myTicket.datacad_proreq;
                        retInfo.id = myTicket.codigo_proreq;
                        retInfo.validade = myTicket.validade_proreq;
                        retInfo.voucher = myTicket.codVoucher_proreq;
                        retInfo.promocao = new InfoPromocao();
                        retInfo.promocao.idPromocao = parans.promocaoId;
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
                var ticket = db.promocaorequerida.Include(tic => tic.promocao).Where(t => t.codigo_proreq == parans.idTicket).FirstOrDefault();
                var numPro = ticket.Promocao_codigo_proreq;
                if (ticket.promocao.limitada_pro)
                {
                    ticket.status_proreq = 3;
                }
                else
                {
                    db.promocaorequerida.Remove(ticket);
                }
                db.SaveChanges();
                resposta.sucesso = true;
                TicketInfo retInfo = new TicketInfo();
                retInfo.id = parans.idTicket;
                var promController = new promocaoController();
                var promParans = new promocaoController.parans_InfoPromocao();
                promParans.promocaoId = numPro;
                retInfo.promocao = promController.getInfoPromocao(promParans);
                resposta.dados = retInfo;
                return resposta;
            }
            catch (Exception e)
            {
                resposta.sucesso = false;
                resposta.mensagem = e.Message;
                return resposta;
            }
        }

        [HttpPost]
        public StatusRequisicao usaTicket(parans_usaTicket parans)
        {
            var resposta = new StatusRequisicao();
            try
            {
                var ticket = db.promocaorequerida.Where(t => t.codVoucher_proreq  == parans.voucher).FirstOrDefault();
                if (parans.foraRegra )
                {
                    ticket.status_proreq = 1;
                    db.SaveChanges();
                    resposta.sucesso = true;
                    resposta.mensagem = "Ticket utilizado fora da regra.";
                    return resposta;
                }
                else if(ticket.validade_proreq < DateTime.Now )
                {
                    ticket.status_proreq = 2;
                    db.SaveChanges();
                    resposta.sucesso = false;
                    resposta.mensagem = "Ticket vencido.";
                    return resposta;
                }

                ticket.status_proreq = 1;
                resposta.sucesso = true;
                resposta.mensagem = "Ticket utilizado.";
                return resposta;
                
            }
            catch (Exception e)
            {
                resposta.sucesso = false;
                resposta.mensagem = e.Message;
                return resposta;
            }
        }

        private bool temTicketLimitado(string clienteId)
        {
            var meusTickets = db.promocaorequerida.Include(t => t.promocao).Where(t => t.userCloudId_proreq == clienteId).ToList();
            foreach(promocaorequerida  meuTicket in meusTickets)
            {
                if (meuTicket.promocao.limitada_pro && (meuTicket.validade_proreq >= DateTime.Now) && (meuTicket.status_proreq == 0))
                {
                    return true;
                }
            }
            return false;
        }

        private void expiraVoucher(long codVoucher)
        {
            try
            {
                var ticket = db.promocaorequerida.Where(t => t.codigo_proreq == codVoucher).FirstOrDefault();
                var numPro = ticket.Promocao_codigo_proreq;
                ticket.status_proreq = 2;
                db.SaveChanges(); 
            }
            catch(Exception e)
            {
                throw;
            }
        }
    }
}