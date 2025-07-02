# Projeto-9-Infer-ncia-Causal-com-RDD

# README - Análise RDD para Avaliar Efeito de Desconto na Taxa de Renovação

📌 Contexto:
Uma empresa de vendas de peças e seguros automotivos deseja entender se conceder um desconto automático para clientes com score de engajamento igual ou superior a 80 aumenta a probabilidade de renovação do contrato/serviço.

💼 Problema de Negócio:
A concessão de um desconto, oferecido apenas a clientes com score de engajamento acima de um certo thereshold (80), impacta positivamente a taxa de renovação?


🎯 Objetivo da análise:
Avaliar se existe um salto (discontinuidade) na taxa de renovação no ponto de corte do score (80), sugerindo efeito causal do desconto sobre a renovação, utilizando a metodologia de Regressão Descontínua (RDD). 

🧠 Justificativa metodológica:
A empresa não randomizou quem recebeu o desconto, mas usou uma regra objetiva de elegibilidade (score ≥ 80). Isso permite aplicar a Regressão Discontínua para estimar o efeito local do tratamento, comparando indivíduos imediatamente acima e abaixo do ponto de corte, na tentativa de simular um RCT com grupos tratados e mão tratados.


---

## Etapas da Análise

### 1. Definição do cutoff e simulação dos dados
- Foi fixado um ponto de corte no score de engajamento em 80.
- Foram simuladas 1000 observações com um tratamento binário (recebeu desconto se score >= 80).
- A variável resposta `renovou` é gerada probabilisticamente como uma função do tratamento e do score, simulando uma taxa base e um efeito do tratamento.

### 2. Exploração visual
- Os dados foram agrupados em bins para visualização.
- Criamos um gráfico das médias da taxa de renovação por bin, separando os grupos tratado e não tratado.
- Observou-se uma possível descontinuidade na taxa de renovação ao redor do cutoff 80, sugerindo um efeito do desconto.

  ![99ca1f8e-76b6-4abd-8810-f50ed4a752cd](https://github.com/user-attachments/assets/d8e17da3-dc6d-4426-8cb2-c20417dbdf90)


### 3. Estimação do efeito via `RDestimate`
- Utilizamos o pacote `rdd` para estimar o efeito local do tratamento.
- Os resultados indicaram um aumento médio da taxa de renovação entre 19% a 31%, dependendo da largura da bandwidth selecionada.
- No entanto, os valores-p para os testes estatísticos ficaram acima de 0.10, indicando que não podemos rejeitar a hipótese nula com alta confiança estatística (5%).

### 4. Estimação com `rdrobust` (método mais robusto)
- Foi realizada uma estimação com ajuste local polinomial e correção para heterocedasticidade.
- O coeficiente estimado foi de aproximadamente 18.6% de aumento na taxa de renovação.
- O p-valor associado (0.22) reforça a ausência de significância estatística ao nível convencional (5%).

### 5. Visualização detalhada com `rdplot`
- O gráfico confirma visualmente o salto na variável de interesse no cutoff.
- O padrão visual é consistente com a hipótese de um efeito positivo do tratamento (considerando a significância econômica ao invés da significância estatística).

  ![54d3e92a-2706-4ed2-95ea-6eee46b4caef](https://github.com/user-attachments/assets/db0d8eac-b665-4669-b838-e9774c129499)


  

### 6. Teste de manipulação (McCrary)
- O teste de densidade em torno do cutoff não indicou manipulação do score.
- Isso reforça a validade do desenho de RDD, pois não há evidência de que os indivíduos tenham manipulado seu score para receber o tratamento.

### 7. Teste placebo
- Foi feito um teste com cutoff fictício em 85, onde não deveria haver efeito.
- Constatou-se que não há descontinuidade significativa no ponto placebo, reforçando a validade do desenho original.

### 8. Robustez com diferentes bandwidths
- Ajustes foram feitos com larguras de banda menores.
- Os efeitos estimados continuaram positivos, porém sem significância estatística forte.

### 9. Balanceamento de covariáveis (ex: idade)
- Verificamos se outras covariáveis, como idade, apresentam descontinuidade no cutoff.
- Não houve diferença significativa na idade entre os grupos de cada lado do cutoff, indicando equilíbrio e reforçando a validade do desenho RDD.

---

## Insights e Interpretação dos Resultados

- **Efeito estimado:** O desconto aplicado no cutoff de 80 parece aumentar a taxa de renovação em torno de 18-30%, um efeito relevante do ponto de vista econômico.
- **Significância estatística:** Os testes indicam que este efeito não é estatisticamente significativo ao nível de 5%, com p-valores geralmente acima de 0.10. Isso sugere que, com os dados do estudo, não há evidência forte para afirmar que o desconto tem impacto na renovação dos serviços.
- **Significância econômica:** Apesar da falta de significância estatística, o tamanho do efeito é grande o suficiente para ser interessante em um contexto prático, e pode justificar a continuidade da política ou a coleta de mais dados para reproduzir o estudo com RDD com maior poder estatístico.
- **Validade do desenho:** Os testes de manipulação e placebo indicam que o desenho RDD é adequado e confiável para este tipo de avaliação causal.

---

## Conclusão

A análise exemplifica a aplicação da metodologia RDD para avaliar o impacto de um tratamento em um ponto de corte. Embora os resultados não mostrem significância estatística robusta, o efeito econômico estimado é relevante e o desenho é válido. Em estudos reais, recomenda-se aumentar a amostra ou complementar com outras abordagens para garantir conclusões mais firmes.

---

## Pacotes Utilizados

- `rdd` e `rddtools` para análise de RDD clássica
- `rdrobust` para estimativas robustas e inferência
- `rddensity` para teste de manipulação
- `ggplot2` e `dplyr` para visualização e manipulação dos dados

---

## Código de Referência

[O código completo da simulação, estimação, visualizações e testes está disponível no script deste projeto.]

---

## FIM


---

