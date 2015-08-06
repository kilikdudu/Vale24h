using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Description;
using Vale24hWebAPI;
using Vale24hWebAPI.Models;

namespace Vale24hWebAPI.Controllers
{
    public class categoriasController : ApiController
    {
        private vale24hEntities db = new vale24hEntities();

        public class parans_InfoCliente
        {
            public string clienteId { get; set; }
        }

        [HttpPost]
        public List<InfoCategoriaUsuario> getCategoriasUsuario(parans_InfoCliente parans)
        {
            var ret = new List<InfoCategoriaUsuario>();

            List<categoria> categorias = db.categoria.Where(c => c.ativo_cat == true).ToList();
            foreach(categoria cat in categorias)
            {
                var infoCat = new InfoCategoriaUsuario();
                infoCat.marcada = db.usuariocategoria.Where(u => u.userCloudId_usucat == parans.clienteId && u.Categoria_codigo_cat == cat.codigo_cat).Count() > 0 ? true : false;
                infoCat.descricao = cat.descricao_cat;
                infoCat.id = cat.codigo_cat;
                ret.Add(infoCat);
            }

            return ret;
        }
    }
}