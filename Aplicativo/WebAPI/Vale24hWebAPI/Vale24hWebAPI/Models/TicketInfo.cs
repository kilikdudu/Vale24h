﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Vale24hWebAPI.Models
{
    public class TicketInfo
    {
        public string voucher { get; set; }
        public DateTime validade { get; set; }
        public DateTime dataAquisicao { get; set; }
        public int status { get; set; }
        public long id { get; set; }
        public InfoPromocao promocao { get; set; }

    }
}