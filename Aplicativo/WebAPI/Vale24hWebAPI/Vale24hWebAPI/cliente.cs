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
    
    public partial class cliente
    {
        public cliente()
        {
            this.imagem = new HashSet<imagem>();
            this.promocao = new HashSet<promocao>();
        }
    
        public long codigo_cli { get; set; }
        public string nome_cli { get; set; }
        public Nullable<long> useralt_cli { get; set; }
        public long usercad_cli { get; set; }
        public System.DateTime datacad_cli { get; set; }
        public Nullable<System.DateTime> dataalt_cli { get; set; }
        public string cloudId_cli { get; set; }
        public string imagem_cli { get; set; }
        public int codigoUAU_cli { get; set; }
    
        public virtual usuario usuario { get; set; }
        public virtual usuario usuario1 { get; set; }
        public virtual ICollection<imagem> imagem { get; set; }
        public virtual ICollection<promocao> promocao { get; set; }
    }
}
