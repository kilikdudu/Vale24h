var args = arguments[0] || {};

$.lblVoucher.setText("Código do ticket: " + args.voucher);
$.lblValidade.setText("Validade do ticket: " + args.validade);
$.lblAdquirido.setText("Adquirido em: " + args.adquirido);
