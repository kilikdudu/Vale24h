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
            var rowsTickets = db.promocaorequerida.Where(p => p.userCloudId_proreq == parans.clienteId).OrderByDescending(p => p.datacad_proreq).Skip(parans.cursor).Take(parans.limite).ToList();
            foreach (promocaorequerida row in rowsTickets)
            {
                if (row.validade_proreq < DateTime.Now && row.status_proreq == 0)
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
            resposta = validaPegaToken(parans.clienteId, parans.promocaoId);
            if (!resposta.sucesso)
            {
                return resposta;
            }
            var prom = db.promocao.Where(p => p.codigo_pro == parans.promocaoId).FirstOrDefault();
            using (var dbTrans = db.Database.BeginTransaction())
            {
                try{
                    promocaorequerida myTicket = db.promocaorequerida.Create();
                    DateTime dtCadastro = DateTime.Now;
                    myTicket.datacad_proreq = dtCadastro;
                    myTicket.Promocao_codigo_proreq  = parans.promocaoId;
                    myTicket.userCloudId_proreq = parans.clienteId;
                    myTicket.codVoucher_proreq = "";
                    myTicket.datastatus_proreq = DateTime.Now;
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
        public StatusRequisicao renovaTicket(parans_TicketInfo parans)
        {
            var ret = new StatusRequisicao();
            ret = validaPegaToken(parans.clienteId, parans.promocaoId);
            if (!ret.sucesso)
            {
                return ret;
            }

            using (var dbTrans = db.Database.BeginTransaction())
            {
                try
                {
                    var ticket = db.promocaorequerida.Where(tic => tic.Promocao_codigo_proreq == parans.promocaoId && tic.userCloudId_proreq == parans.clienteId && tic.status_proreq == 3).FirstOrDefault();
                    if (ticket != null)
                    {
                        ticket.status_proreq = 0;
                        ticket.validade_proreq = DateTime.Now.AddHours(24);
                        ticket.datastatus_proreq = DateTime.Now;
                        db.SaveChanges();
                        dbTrans.Commit();

                        //Retorno o ticket com a promoção.
                        parans_TicketInfo paransInfo = new parans_TicketInfo();
                        paransInfo.clienteId = ticket.userCloudId_proreq;
                        paransInfo.promocaoId = ticket.Promocao_codigo_proreq;
                        TicketInfo retInfo = new TicketInfo();
                        retInfo = getInfoTicket(paransInfo);

                        ret.dados = retInfo;
                        ret.sucesso = true;
                        return ret;
                    }
                    else
                    {
                        ret.sucesso = false;
                        ret.mensagem = "Ticket não localizado.";
                        dbTrans.Rollback();
                        return ret;
                    }
                }
                catch(Exception e)
                {
                    dbTrans.Rollback();
                    ret.sucesso = false;
                    ret.mensagem = e.Message;
                }
            }
            return ret;
        }

        [HttpPost]
        public StatusRequisicao liberaTicket(parans_LiberaTicket parans)
        {
            var resposta = new StatusRequisicao();
            long bkpId = -1;
            try
            {
                var ticket = db.promocaorequerida.Include(tic => tic.promocao).Where(t => t.codigo_proreq == parans.idTicket).FirstOrDefault();
                var numPro = ticket.Promocao_codigo_proreq;
                if (ticket.promocao.limitada_pro)
                {
                    ticket.status_proreq = 3;
                    ticket.datastatus_proreq = DateTime.Now;
                }
                else
                {
                    bkpId = ticket.codigo_proreq;
                    db.promocaorequerida.Remove(ticket);
                }
                db.SaveChanges();
                resposta.sucesso = true;
                parans_TicketInfo paransInfo = new parans_TicketInfo();
                paransInfo.clienteId = ticket.userCloudId_proreq;
                paransInfo.promocaoId = ticket.Promocao_codigo_proreq;
                TicketInfo retInfo = new TicketInfo();
                retInfo = getInfoTicket(paransInfo);
                if (bkpId > -1)
                {
                    retInfo.id = bkpId;
                }
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

        private bool temTicketLimitado(string clienteId, ref string ticketRetorno)
        {
            var meusTickets = db.promocaorequerida.Include(t => t.promocao).Where(t => t.userCloudId_proreq == clienteId).ToList();
            foreach(promocaorequerida  meuTicket in meusTickets)
            {
                if (meuTicket.promocao.limitada_pro && (meuTicket.validade_proreq >= DateTime.Now) && (meuTicket.status_proreq == 0))
                {
                    ticketRetorno = meuTicket.codVoucher_proreq;
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
                ticket.datastatus_proreq = DateTime.Now;
                db.SaveChanges(); 
            }
            catch(Exception)
            {
                throw;
            }
        }
        private StatusRequisicao validaPegaToken(string clienteId, long promocaoId)
        {
            var resposta = new StatusRequisicao();
            resposta.sucesso = true;
            string ticketAlocado = null;
            var prom = db.promocao.Where(pro => pro.codigo_pro == promocaoId).FirstOrDefault();
            var proControl = new promocaoController();
            if ((proControl.getQuantidadeTicketsPromocao(prom.codigo_pro) > prom.totalTickets_pro) && prom.limitada_pro == true)
            {
                resposta.sucesso = false;
                resposta.mensagem = "Desculpe, outra pessoa pegou o ticket primeiro.";
                return resposta;
            }
            if (prom.limitada_pro && temTicketLimitado(clienteId, ref ticketAlocado))
            {
                resposta.sucesso = false;
                resposta.mensagem = "Não é permitido ter dois tickets de promoções limitadas ao mesmo tempo. Ticket atual: " + ticketAlocado;
                return resposta;
            }
            var ticket = db.promocaorequerida.Where(tic => tic.Promocao_codigo_proreq == promocaoId && tic.userCloudId_proreq == clienteId && tic.status_proreq == 3).FirstOrDefault();
            if (ticket != null)
            {
                if (DateTime.Now.Subtract(ticket.datastatus_proreq.Value).TotalHours < 24)
                {
                    var ts = ticket.datastatus_proreq.Value.AddHours(24).Subtract(DateTime.Now);
                    resposta.mensagem = "Você precisa esperar 24 horas para pegar novamente este ticket. Faltam " + ts.Hours + " horas, " + ts.Minutes + " minutos e " + ts.Seconds + " segundos.";
                    resposta.sucesso = false;
                    return resposta;
                }
            }
            return resposta;
        }
    }
}