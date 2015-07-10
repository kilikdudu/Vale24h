var args = arguments[0] || {};

$.lblVoucher.setText("Código do ticket: " + args.voucher);
var dataValidade = Alloy.Globals.format.generateCustomData(args.validade);
$.lblValidade.setText("Validade do ticket: " + dataValidade.Dia + "/" + dataValidade.Mes + "/" + dataValidade.Ano + " até as " + dataValidade.Hora + ":" + dataValidade.Minuto + ":" + dataValidade.Segundo);
$.lblAdquirido.setText("Adquirido em: " + Alloy.Globals.format.toDiaMesAno(args.adquirido));
