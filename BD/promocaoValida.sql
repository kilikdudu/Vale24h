SELECT 
    *
FROM
    promocao
        INNER JOIN
    imagem ON imagem.codigo_img = promocao.Imagem_codigo_pro
        INNER JOIN
    cliente ON promocao.cliente_pro = cliente.codigo_cli
WHERE
    promocao.datafim_pro > NOW()
        AND NOT EXISTS( SELECT 
            1
        FROM
            promocaorequerida proreq
        WHERE
            proreq.Promocao_codigo_proreq = promocao.codigo_pro
                AND proreq.userCloudId_proreq = '557d99321b40070b89038887')
        AND promocao.descricao_pro LIKE '%nEc, cUrsus a%'