//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Vale24hWebAPI
{
    using System;
    using System.Collections.Generic;
    
    public partial class categoria
    {
        public categoria()
        {
            this.promocao = new HashSet<promocao>();
        }
    
        public long codigo_cat { get; set; }
        public string descricao_cat { get; set; }
        public bool ativo_cat { get; set; }
        public System.DateTime datacad_cat { get; set; }
        public Nullable<System.DateTime> dataalt_cat { get; set; }
        public long usercad_cat { get; set; }
        public Nullable<long> useralt_cat { get; set; }
    
        public virtual usuario usuario { get; set; }
        public virtual usuario usuario1 { get; set; }
        public virtual ICollection<promocao> promocao { get; set; }
    }
}
