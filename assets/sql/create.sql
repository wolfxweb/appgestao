CREATE TABLE dados_basiscos(id INTEGER PRIMARY KEY, qtd TEXT, faturamento TEXT , gastos TEXT default '0', custo_fixo TEXT, custo_varivel TEXT,margen TEXT, mes TEXT ,   gastos_insumos TEXT);
CREATE TABLE importancia_meses(id INTEGER PRIMARY KEY, jan NUMERIC,fev NUMERIC,mar NUMERIC,abr NUMERIC, mai NUMERIC, jun NUMERIC, jul NUMERIC, ago NUMERIC, setb NUMERIC,out NUMERIC, nov NUMERIC, dez NUMERIC, total NUMERIC);
CREATE TABLE calculadora_historico(id INTEGER PRIMARY KEY, produto TEXT,data TEXT,preco_atual TEXT,preco_sugerido Text, margem_desejada TEXT, margem_atual TEXT);
INSERT INTO importancia_meses (jan,fev,mar,abr,mai,jun,jul,ago,setb,out,nov,dez,total) VALUES ( '5',  '5',  '5',  '5',  '10',  '10',  '10',  '10',  '10',  '10',  '10',  '10',  '100');
