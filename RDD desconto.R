# Instale os pacotes (se ainda não tiver)
install.packages(c("rdd", "rdrobust", "rddensity", "ggplot2"))

# Carregue os pacotes
library(rdd)
library(rddtools)
library(rdrobust)
library(rddensity)
library(ggplot2)
library(dplyr)

# ----------------------------------------------------
# ETAPA 1 - DEFINIÇÃO DO CUTOFF E SIMULAÇÃO DOS DADOS
# ----------------------------------------------------

set.seed(123)

n <- 1000
cutoff <- 80

score <- runif(n, 50, 100)
tratamento <- ifelse(score >= cutoff, 1, 0)

prob_renovacao <- 0.2 + 0.25 * tratamento + 0.01 * (score - cutoff)
renovou <- rbinom(n, 1, plogis(prob_renovacao))

dados <- data.frame(score, tratamento, renovou)

# -----------------------------
# ETAPA 2 - EXPLORAÇÃO VISUAL
# -----------------------------

# Número de bins
n_bins <- 20

# Criar bins manuais
dados_binned <- dados %>%
  mutate(bin = cut(score, breaks = n_bins)) %>%
  group_by(bin) %>%
  summarise(score_mean = mean(score),
            renovou_mean = mean(renovou),
            tratamento = mean(tratamento))


# Gráfico com pontos médios e regressões separadas
ggplot(dados_binned, aes(x = score_mean, y = renovou_mean)) +
  geom_point(aes(color = as.factor(tratamento)), size = 2) +
  geom_smooth(method = "lm", se = FALSE,
              aes(color = as.factor(tratamento), group = as.factor(tratamento))) +
  geom_vline(xintercept = cutoff, linetype = "dashed") +
  labs(title = "RDD com Médias por Bins",
       x = "Score de Engajamento (média por bin)",
       y = "Taxa de Renovação (média por bin)",
       color = "Tratamento")

# Garantir bins mais estreitos ou alinhados com o cutoff
cut(score, breaks = seq(50, 100, by = 2))  # exemplo: de 2 em 2


# -----------------------------
# ETAPA 3 - ESTIMAR COM RDestimate
# -----------------------------
modelo_rd <- RDestimate(renovou ~ score, data = dados, cutpoint = cutoff)
summary(modelo_rd)

# -----------------------------
# ETAPA 4 - ESTIMAR COM rdrobust (mais robusto)
# -----------------------------
modelo_robusto <- rdrobust(y = dados$renovou, x = dados$score, c = cutoff)
summary(modelo_robusto)

# -----------------------------
# ETAPA 5 - VISUALIZAÇÃO COM rdplot
# -----------------------------
rdplot(y = dados$renovou, x = dados$score, c = cutoff,
       x.label = "Score de Engajamento", y.label = "Taxa de Renovação",
       title = "RDD: Efeito do Desconto na Renovação")

# -----------------------------
# ETAPA 6 - TESTE DE MANIPULAÇÃO (McCrary)
# -----------------------------
densidade <- rddensity(dados$score, c = cutoff)
summary(densidade)

# -----------------------------
# ETAPA 7 - PLACEBO TEST
# -----------------------------
placebo <- RDestimate(renovou ~ score, data = dados, cutpoint = 85)
summary(placebo)

# -----------------------------
# ETAPA 8 - ROBUSTEZ: BANDWIDTHS DIFERENTES
# ----------------------------

resultado <- rdrobust(y = dados$renovou, x = dados$score, c = cutoff, h = 3)

# Estimativa do efeito
coef <- resultado$Estimate[1]

# Erro padrão
se <- resultado$Std.error[1]

# Valor-p
pvalor <- resultado$pv[1]

coef
se
pvalor

# -----------------------------
# ETAPA 9 - BALANCEAMENTO DE COVARIÁVEL (IDADE)
# -----------------------------
dados$idade <- round(runif(n, 18, 60))

# Criar objeto RDD para variável idade
dados_rdd_idade <- rdd_data(y = dados$idade, x = dados$score, cutpoint = cutoff)

# Estimar modelo RDD linear para idade
modelo_idade <- rdd_reg_lm(rdd_object = dados_rdd_idade)

# Mostrar resumo do modelo
summary(modelo_idade)
