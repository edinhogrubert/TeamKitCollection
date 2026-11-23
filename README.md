


# TeamKitCollection

**Plataforma de Coleções de Camisetas Esportivas e Laboratório de Engenharia de Software Assistida por Inteligência Artificial**

**Status:** Planejamento e definição arquitetural  
**Natureza:** Projeto experimental, educacional, colaborativo e de código aberto  
**Restrição financeira:** R$ 0,00  
**Repositório:** `TeamKitCollection`  
**Versão do produto:** Ainda não definida

---

## 1. Apresentação

O **TeamKitCollection** é um projeto de desenvolvimento de software que utiliza um aplicativo de gerenciamento de coleções de camisetas esportivas como base para um experimento mais amplo de engenharia de software.

O aplicativo permitirá que usuários cadastrem, organizem, pesquisem e compartilhem informações sobre suas coleções de camisetas de clubes, seleções e outras modalidades esportivas.

Entretanto, o principal objetivo do projeto vai além da construção dessa aplicação.

O TeamKitCollection será utilizado para investigar, desenvolver, testar e documentar uma metodologia de trabalho em que uma pessoa, apoiada por diferentes ferramentas de inteligência artificial, consiga executar o ciclo completo de engenharia de um sistema.

A experiência abrangerá a concepção, o levantamento de requisitos, a arquitetura, o desenvolvimento, os testes, a implantação, a administração da infraestrutura, a segurança, a observabilidade, a recuperação de desastres e o suporte aos usuários.

O projeto também investigará como diferentes IAs podem trabalhar de forma coordenada, assumir funções profissionais específicas e transferir responsabilidades entre si sem depender do histórico de uma conversa ou de determinado fornecedor de inteligência artificial.

## 2. Pergunta central do experimento

> Até que ponto uma única pessoa, apoiada por inteligência artificial, consegue conceber, desenvolver, implantar, operar, recuperar, evoluir e prestar suporte a um sistema corporativo real, sem orçamento financeiro?

O TeamKitCollection pretende produzir evidências práticas que permitam responder a essa pergunta.

Não se assume antecipadamente que a IA substitui todos os profissionais de tecnologia.

O objetivo é investigar quais atividades podem ser realizadas, em quais condições, quais limitações existem e quais práticas são necessárias para preservar qualidade, segurança, confiabilidade e continuidade operacional.

## 3. Objetivos do projeto

### 3.1 Objetivo funcional

Construir uma aplicação web utilizável para gerenciamento de coleções de camisetas esportivas.

O produto deverá começar simples, oferecendo funcionalidades fundamentais de um sistema corporativo, e evoluir progressivamente.

### 3.2 Objetivo técnico

Construir e operar um ambiente que permita experimentar:

- Arquitetura de software e infraestrutura.
- Aplicações distribuídas e containerização.
- Redes, gateways, proxies e balanceamento de carga.
- Bancos de dados relacionais.
- Separação entre operações de leitura e escrita.
- Replicação, consistência e persistência.
- Autenticação e autorização.
- Segurança de aplicações e infraestrutura.
- Testes funcionais, de integração, carga e resiliência.
- Integração e entrega contínuas.
- Backup, restauração e recuperação de desastres.
- Monitoramento, logs, métricas e rastreamento.
- Migração de infraestrutura on-premises para nuvem.
- Diagnóstico de incidentes e atendimento aos usuários.

### 3.3 Objetivo metodológico

Desenvolver uma metodologia reutilizável de engenharia de software assistida por múltiplas IAs.

A metodologia deverá permitir:

1. Distribuir responsabilidades entre agentes especializados.
2. Estabelecer regras, autoridades e limites de atuação.
3. Preservar o conhecimento dentro do repositório.
4. Transferir tarefas entre IAs de fornecedores diferentes.
5. Substituir conversas longas sem perder o estado do trabalho.
6. Reduzir retrabalho e consumo desnecessário de contexto.
7. Identificar contradições, incertezas e possíveis alucinações.
8. Exigir evidências técnicas antes de declarar entregas concluídas.
9. Permitir auditoria independente.
10. Produzir um método aplicável a outros projetos de software.

## 4. Princípios fundamentais

### Independência entre o método de IA e a engenharia do produto

O TeamKitCollection possui duas estruturas documentais independentes e complementares:

**`IA/` — Metodologia de Engenharia Assistida por IA**

Contém regras, responsabilidades, protocolos de comunicação, continuidade, auditoria e governança dos agentes de inteligência artificial.

Seu conteúdo deve ser reutilizável em outros projetos, independentemente do produto, da linguagem de programação ou do fornecedor de IA.

**`docs/` — Engenharia Tradicional do Produto**

Contém a documentação necessária para que uma equipe humana consiga compreender, reconstruir, implantar, operar, manter e evoluir o TeamKitCollection sem depender das IAs ou de seus históricos de conversas.

Inclui requisitos, regras de negócio, arquitetura, modelos de dados, contratos de integração, testes, infraestrutura e operação.

**Princípio de independência:**

A documentação do produto não poderá depender da metodologia de IA para ser compreendida.

A metodologia de IA não poderá incorporar regras de negócio específicas do produto como normas universais.

Essa separação será validada por testes de portabilidade humana e continuidade entre agentes de IA.

# TeamKitCollection
Ainda vou definir a descrição

### 4.1 Custo financeiro zero

Toda a solução deverá ser projetada para funcionar sem despesas financeiras obrigatórias.

Serão priorizados:

- Software livre e de código aberto.
- Ferramentas gratuitas.
- Recursos computacionais já disponíveis.
- Serviços cloud com franquias permanentemente gratuitas.
- Certificados TLS gratuitos.
- Repositórios e ferramentas de CI/CD gratuitos, respeitando suas cotas.

Serviços pagos, avaliações temporárias que se convertam em cobrança e dependências com custo não comprovado não poderão ser introduzidos automaticamente.

A utilização de recursos gratuitos deverá ser periodicamente reavaliada, pois condições e limites dos provedores podem mudar.

O custo de equipamentos, energia, conectividade e tempo humano será reconhecido no experimento, mesmo quando não representar novo desembolso financeiro.

### 4.2 Independência de fornecedores de IA

O método não poderá depender exclusivamente de ChatGPT, Claude, Gemini, Copilot, Codex ou qualquer outra plataforma.

Uma tarefa iniciada com uma IA deverá poder ser retomada por outra, desde que a ferramenta substituta tenha acesso aos arquivos e recursos necessários.

A continuidade deverá ser baseada em documentos, código versionado, contratos e evidências, nunca exclusivamente na memória de uma conversa.

### 4.3 Evidência antes de conclusão

Nenhum agente deverá declarar que implementou, testou, publicou ou corrigiu algo sem evidências proporcionais à afirmação.

Serão diferenciados os estados:

- **VERIFICADO:** confirmado por evidência técnica adequada.
- **DOCUMENTADO:** registrado em documentação oficial.
- **RELATADO:** informado, mas ainda não validado independentemente.
- **INFERIDO:** conclusão lógica ainda não comprovada diretamente.
- **PROPOSTO:** planejado, mas não implementado.
- **DESCONHECIDO:** informações insuficientes.
- **CONTRADITÓRIO:** conflito entre fontes ou evidências.

Essas classificações não substituem testes. Elas servem para comunicar corretamente o nível de confiança das informações.

### 4.4 Responsabilidade definida

Cada agente receberá um papel e uma missão com escopo explícito.

O papel determina responsabilidades, mas não concede automaticamente permissões de acesso ou execução.

Alterações sensíveis, exclusões, mudanças de segurança, operações em produção e decisões financeiras dependerão de autorização verificável.

### 4.5 Documentação como memória persistente

O repositório deverá preservar:

- Objetivos e requisitos.
- Arquitetura e decisões.
- Estado das tarefas.
- Evidências de implementação.
- Testes executados.
- Incidentes e soluções.
- Procedimentos operacionais.
- Informações necessárias para continuidade.

A documentação não deverá depender de uma conversa específica para ser compreendida.

### 4.6 Complexidade progressiva

O aplicativo deverá começar funcionalmente simples.

A complexidade será acrescentada de maneira controlada para permitir testes objetivos.

Cada nova camada de infraestrutura deverá possuir propósito, hipóteses, critérios de aceitação e procedimentos de recuperação.

### 4.7 Segurança desde a concepção

Serão consideradas desde o início a proteção de credenciais, a privacidade dos usuários, o controle de acesso, a validação de entradas, a segurança das comunicações e a recuperação de dados.

Nenhuma credencial, chave privada, senha ou segredo de produção deverá ser incorporado ao código versionado.

---

## 5. O produto: coleções de camisetas esportivas

### 5.1 Proposta

O TeamKitCollection permitirá que usuários organizem suas coleções de camisetas esportivas por equipe, modalidade, temporada e outras características.

O produto será utilizado para demonstrar funcionalidades comuns a sistemas reais, incluindo cadastro, autenticação, persistência, upload de imagens, pesquisas, edição, relatórios e administração.

### 5.2 Funcionalidades iniciais previstas

**Gestão de usuários**

- Cadastro de conta.
- Autenticação.
- Encerramento de sessão.
- Recuperação de acesso.
- Edição de perfil.
- Controle de permissões.

**Gestão de coleções**

- Criação de coleções.
- Cadastro de camisetas.
- Associação de camisetas às coleções.
- Edição e exclusão de registros.
- Inclusão de imagens.
- Pesquisa, filtros e ordenação.
- Organização por clube, seleção, modalidade e temporada.

**Informações das camisetas**

Campos inicialmente previstos:

- Nome da equipe.
- Modalidade esportiva.
- País.
- Temporada ou ano.
- Fabricante.
- Modelo.
- Tipo de uniforme.
- Número e nome de jogador, quando aplicável.
- Descrição.
- Imagens.
- Data de aquisição, quando informada.

O modelo definitivo de dados será estabelecido durante a análise de requisitos.

**Área administrativa**

- Gerenciamento de usuários.
- Controle de permissões.
- Consulta a registros operacionais.
- Acompanhamento de problemas da aplicação.

**Funcionalidades futuras sujeitas a avaliação**

- Coleções públicas e privadas.
- Lista de camisetas desejadas.
- Estatísticas de coleções.
- Compartilhamento por links.
- Comparação de coleções.
- Exportação e importação de dados.
- Recursos sociais entre colecionadores.

Nenhuma funcionalidade descrita nesta seção deve ser considerada implementada apenas por constar neste documento.

### 5.3 Limites do produto inicial

O MVP não dependerá de comércio eletrônico, pagamentos, serviços pagos de imagens ou integrações comerciais complexas.

Imagens, marcas e identificações de clubes deverão respeitar direitos autorais, direitos de marca e as condições de uso aplicáveis.

---

## 6. Laboratório de infraestrutura

### 6.1 Primeira fase: ambiente local

O primeiro ambiente previsto será executado em uma máquina virtual local, representando uma infraestrutura on-premises.

**Recursos planejados:**

| Recurso | Capacidade |
|---|---|
| Máquinas virtuais | 1 |
| Processadores virtuais | 4 vCPUs |
| Memória RAM | 6 GB |
| Plataforma de containers | Docker |
| Orquestração inicial | Docker Compose |
| Sistema operacional | Linux, distribuição a definir |

A arquitetura inicial de aplicação terá quatro containers principais.

| Container | Responsabilidade |
|---|---|
| Gateway | Entrada de conexões, proxy reverso e distribuição de requisições |
| Aplicação Sul | Instância regional da aplicação |
| Aplicação Norte/Nordeste | Instância regional da aplicação |
| Aplicação Sudeste | Instância regional da aplicação |

O Gateway será o único serviço de aplicação diretamente publicado para acesso externo.

As instâncias regionais serão acessadas por rede interna.

A restrição de saída para a internet será configurada e testada separadamente, por meio de regras de rede e mecanismos adequados.

### 6.2 Arquitetura lógica inicial

```text
                    INTERNET
                       |
                       |
              +-----------------+
              |     GATEWAY     |
              | HTTPS / PROXY   |
              | LOAD BALANCER   |
              +-----------------+
                       |
                REDE INTERNA
                       |
          +------------+------------+
          |            |            |
     +---------+  +---------+  +---------+
     |   SUL   |  |  NORTE  |  | SUDESTE |
     |   APP   |  | NORDESTE|  |   APP   |
     +---------+  |   APP   |  +---------+
          |       +---------+       |
          |            |            |
          +------------+------------+
                       |
              CAMADA DE DADOS
                       |
             +-------------------+
             | BANCO DE ESCRITA  |
             +-------------------+
                       |
                REPLICACAO
                       |
             +-------------------+
             | BANCO DE LEITURA  |
             +-------------------+
                       |
                BACKUP / RESTORE
```

O diagrama representa a arquitetura-alvo de laboratório, não a infraestrutura já implantada.

As instâncias regionais inicialmente executarão a mesma aplicação, com o objetivo de exercitar distribuição de carga e recuperação.

A separação geográfica real ocorrerá em uma etapa posterior.

### 6.3 Persistência

A solução deverá permitir experimentar:

- Banco primário para operações de escrita.
- Réplica para operações de leitura.
- Replicação e atraso de propagação.
- Consistência dos dados.
- Operações transacionais.
- Índices e otimização de consultas.
- Migrations.
- Backup lógico e físico, quando aplicável.
- Restauração completa.
- Recuperação de uma base isolada.
- Falhas do banco primário.
- Procedimentos de promoção de réplica, quando implementados.

**PostgreSQL** é o banco inicialmente proposto.

O banco de leitura não deverá ser tratado como substituto de backup.

Serão definidos objetivos mensuráveis de recuperação, incluindo RPO (perda máxima de dados tolerada) e RTO (tempo-alvo de recuperação).

### 6.4 Limitações conhecidas da primeira fase

Todos os containers estarão inicialmente na mesma VM.

Consequentemente, a infraestrutura local terá um domínio comum de falha.

A interrupção da VM poderá indisponibilizar todos os serviços simultaneamente.

A existência de três instâncias da aplicação não representa, por si só, alta disponibilidade contra falhas da máquina hospedeira.

O Gateway também será inicialmente um ponto único de falha.

Essas limitações são intencionais e deverão ser documentadas e utilizadas nos testes.

---

## 7. Migração on-premises para a nuvem

Após a validação do ambiente local, o laboratório deverá evoluir para uma infraestrutura distribuída na Oracle Cloud, condicionada à disponibilidade de recursos gratuitos.

### 7.1 Topologia pretendida

| Localização | Quantidade pretendida |
|---|---|
| Chile | 2 VMs |
| Estados Unidos | 2 VMs |
| Total | 4 VMs |

Essa quantidade representa o objetivo experimental, não uma garantia de disponibilidade gratuita.

Antes de provisionar recursos, deverão ser verificadas as cotas por conta e região, os tipos de instância elegíveis, armazenamento, transferência de dados e possíveis exigências de pagamento.

Caso a topologia não seja viável com custo financeiro zero, o projeto deverá documentar a limitação e buscar uma alternativa gratuita.

### 7.2 Experimentos de migração

A migração deverá abranger:

1. Inventário do ambiente original.
2. Reprodução da infraestrutura por configuração versionada.
3. Implantação dos serviços.
4. Configuração de redes e segurança.
5. Transferência dos dados.
6. Validação de integridade.
7. Testes funcionais.
8. Testes de desempenho.
9. Configuração de roteamento.
10. Migração controlada do tráfego.
11. Observabilidade pós-migração.
12. Plano de reversão.

O objetivo é demonstrar que uma aplicação construída localmente pode ser transferida para outro ambiente sem depender de procedimentos manuais não documentados.

### 7.3 Testes de distribuição geográfica

Serão avaliados, conforme viabilidade técnica:

- Comunicação entre VMs de regiões diferentes.
- Latência de rede.
- Replicação entre regiões.
- Comportamento durante perda de conectividade.
- Balanceamento de tráfego.
- Failover.
- Recuperação após indisponibilidade regional.
- Custos e limites de transferência.
- Consistência após reconexão.

A topologia final e a estratégia de recuperação serão definidas a partir de medições, e não de premissas não verificadas.

---

## 8. Estratégia de testes e resiliência

O TeamKitCollection será construído para permitir falhas controladas.

### 8.1 Testes funcionais

Verificarão o funcionamento das operações de usuários e coleções.

### 8.2 Testes de integração

Verificarão a comunicação entre frontend, backend, banco de dados, Gateway e serviços auxiliares.

### 8.3 Testes de carga

Avaliarão:

- Usuários simultâneos.
- Volume de requisições.
- Latência.
- Taxa de erros.
- Utilização de CPU.
- Utilização de memória.
- Comportamento dos containers.
- Limites operacionais da VM.
- Capacidade de recuperação após sobrecarga.

### 8.4 Testes de falhas

Serão simuladas situações como:

- Interrupção de uma instância da aplicação.
- Reinício inesperado de containers.
- Indisponibilidade do Gateway.
- Queda do banco de leitura.
- Queda do banco de escrita.
- Falha de comunicação entre serviços.
- Falha de rede entre regiões.
- Esgotamento controlado de recursos.
- Atualização defeituosa.
- Perda completa da VM.

### 8.5 Backup e recuperação

Os testes deverão verificar a capacidade de restaurar:

- Dados de usuário.
- Dados das coleções.
- Imagens e arquivos persistidos.
- Banco de dados.
- Configurações da aplicação.
- Serviços individuais.
- Conjunto de containers.
- Ambiente completo em outra VM.

Backups deverão ser testados periodicamente.

A existência de um arquivo de backup não será considerada prova suficiente de recuperação.

### 8.6 Observabilidade

O laboratório deverá evoluir para registrar:

- Logs estruturados.
- Identificadores de correlação.
- Métricas de aplicação e infraestrutura.
- Eventos de autenticação.
- Falhas de integração.
- Histórico de deploy.
- Alertas.
- Incidentes.
- Tempos de detecção e recuperação.

Dados sensíveis, senhas, tokens e segredos não deverão ser armazenados nos logs.

---

## 9. Método de engenharia assistida por múltiplas IAs

O TeamKitCollection será também o laboratório de criação de um método de trabalho que possa ser reutilizado em diferentes tipos de software.

### 9.1 Ponto único de entrada

O arquivo `AGENTS.md`, localizado na raiz do repositório, será o ponto inicial de orientação dos agentes.

Sua finalidade será indicar:

- Como identificar a tarefa atual.
- Como identificar o papel atribuído.
- Quais documentos consultar.
- Qual é a hierarquia de regras e decisões.
- Quais verificações devem ser executadas.
- Como registrar resultados.
- Quando interromper o trabalho.
- Como realizar uma transferência de responsabilidade.

O arquivo deverá ser compacto e atuar como um índice operacional, evitando a repetição de todo o conteúdo do projeto.

O código e os arquivos de configuração continuarão organizados nas pastas adequadas à linguagem e às ferramentas utilizadas.

### 9.2 Documentação especializada

Os documentos da metodologia serão organizados logicamente, separando:

- Constituição e governança.
- Regras universais.
- Papéis e responsabilidades.
- Visão do produto.
- Requisitos.
- Arquitetura.
- Decisões.
- Planejamento.
- Tarefas.
- Evidências.
- Testes.
- Segurança.
- Operação.
- Incidentes.
- Recuperação.
- Handoff.

A estrutura definitiva será estabelecida durante a primeira fase metodológica.

### 9.3 Agentes especializados

O método deverá permitir atribuir funções como:

| Papel | Responsabilidade |
|---|---|
| Coordenador | Planejamento, dependências e integração |
| Product Owner | Requisitos de negócio e prioridades |
| Analista de Requisitos | Especificação e critérios de aceitação |
| Arquiteto | Estrutura técnica e decisões |
| Desenvolvedor Frontend | Interface e experiência do usuário |
| Desenvolvedor Backend | APIs e regras de negócio |
| DBA | Modelagem, desempenho e recuperação |
| Engenheiro de Dados | Fluxos, qualidade e persistência |
| DevOps | Automação e implantação |
| Analista de Infraestrutura | Sistemas e recursos computacionais |
| Analista de Redes | Comunicação, DNS e roteamento |
| Engenheiro de Segurança | Riscos, controles e auditoria |
| QA | Verificação e testes |
| SRE | Confiabilidade, monitoramento e recuperação |
| Analista de Suporte | Diagnóstico e atendimento |
| Auditor Independente | Contestação técnica e evidências |

O método deverá permitir acrescentar, dividir ou combinar papéis conforme a complexidade da tarefa.

Uma função não estará vinculada permanentemente a determinada IA.

### 9.4 Continuidade independente de conversas

O estado do trabalho deverá ser registrado fora do chat.

Uma tarefa deverá possuir, quando aplicável:

- Identificador estável.
- Objetivo.
- Responsável funcional.
- Escopo.
- Estado atual.
- Branch e commit de referência.
- Arquivos afetados.
- Dependências.
- Trabalho executado.
- Evidências.
- Testes realizados.
- Problemas encontrados.
- Pendências.
- Próxima ação.
- Critérios de conclusão.

Um agente substituto deverá conseguir reconstruir o contexto necessário a partir desses registros e das fontes técnicas correspondentes.

A intenção é minimizar a releitura integral do projeto e impedir que a perda de uma conversa represente perda do conhecimento acumulado.

### 9.5 Protocolo de handoff

Toda transferência de responsabilidade deverá registrar, proporcionalmente ao risco:

1. Identidade da tarefa e do projeto.
2. Autorizações e limites.
3. Estado confirmado.
4. Trabalho executado.
5. Evidências.
6. Pendências.
7. Riscos e contradições.
8. Próximo passo.

O agente receptor deverá verificar se o estado registrado corresponde ao repositório e ao ambiente disponíveis.

A transferência não poderá transformar relatos em fatos verificados automaticamente.

### 9.6 Independência e contestação

O método deverá impedir que uma IA atue apenas para concordar com a anterior.

Decisões técnicas relevantes poderão exigir análise independente.

O auditor deverá verificar evidências primárias, examinar riscos concretos e distinguir defeitos comprovados de hipóteses.

A aprovação de uma implementação não poderá depender exclusivamente da autodeclaração do agente que a produziu.

### 9.7 Verificações automatizadas

Sempre que possível, o cumprimento das regras deverá ser verificado por ferramentas determinísticas, tais como:

- Testes automatizados.
- Lint.
- Verificação de tipos.
- Validação de contratos.
- CI/CD.
- Verificação de arquivos obrigatórios.
- Conferência do Git.
- Análise de dependências.
- Testes de segurança.
- Verificação de artefatos e evidências.

Os controles deverão ser proporcionais ao risco e à complexidade da mudança.

---

### 9.8 Estado atual da metodologia e comunicação humano-mediada

A fase experimental já documentou os protocolos de tarefas [COM-001](IA/regras/comunicacao.md) e de despacho por referência [COM-002](IA/despachos/README.md), além do [índice de tarefas](IA/tarefas/indice.md). A documentação vigente deve ser consultada diretamente no Git; a existência do protocolo não comprova a implementação operacional completa.

**Fluxo previsto:** o coordenador, mediante solicitação humana, publica um pedido `TKC-REQ-XXXX`; o humano transporta a referência à IA responsável, que avalia viabilidade em L0/L1 e registra `TKC-PAR-XXXX`. Após análise crítica, uma proposta `TKC-AUT-XXXX` permanece pendente de decisão humana verificável. A referência isolada não autoriza. `#TRUE` e `#FALSE` são marcadores de decisão a validar, não senhas ou autenticação. Se a execução for autorizada e a posse estiver regular, registrar andamento em `TKC-EXE-XXXX` e resultado em `TKC-RET-XXXX`, seguido de revisão independente quando exigida.

**Limite essencial:** AGT-001 não aciona outras IAs, sessões, bots ou automações por iniciativa própria; o humano encaminha somente os identificadores. O GitHub é repositório compartilhado, não entrega automática ou lock de concorrência. Serviços que prometam envio automático, exclusão mútua ou monitoramento exigem implementação/teste e autorização específicos.

**Consolidação evolutiva:** o método pode experimentar dezenas de documentos e depois substituí-los por poucos arquivos menores, mais claros e com única fonte de verdade, desde que preservem critérios de segurança, autoridade, continuidade, evidências e histórico recuperável. A redução de linhas, sozinha, não prova melhoria.

## 10. Ciclo de vida do desenvolvimento

O projeto deverá exercitar as seguintes etapas:

| Etapa | Resultado esperado |
|---|---|
| Concepção | Problema e objetivos definidos |
| Análise | Requisitos e casos de uso |
| Arquitetura | Componentes e decisões |
| Planejamento | Tarefas e dependências |
| Desenvolvimento | Código implementado |
| Banco de dados | Modelos e persistência |
| Qualidade | Testes e evidências |
| Segurança | Controles e validações |
| Infraestrutura | Ambiente reproduzível |
| Implantação | Sistema publicado |
| Observabilidade | Monitoramento operacional |
| Suporte | Atendimento aos usuários |
| Manutenção | Correções e atualizações |
| Continuidade | Backup, restore e recuperação |
| Evolução | Novas versões e melhorias |

O método deverá preservar a rastreabilidade entre requisitos, implementação, testes e entregas.

## 11. Suporte ao usuário como critério de sucesso

A conclusão do projeto não ocorrerá simplesmente quando a aplicação estiver publicada.

O sistema deverá permitir que um usuário real utilize o produto e relate problemas.

Exemplo:

> "Não consegui fazer login. Por que será?"

A partir desse relato, o processo de suporte deverá conseguir:

1. Registrar a ocorrência.
2. Identificar o ambiente afetado.
3. Consultar as evidências disponíveis.
4. Investigar o comportamento.
5. Reproduzir a falha, quando possível.
6. Identificar sua causa.
7. Definir a correção.
8. Testar a solução.
9. Implantar a mudança autorizada.
10. Confirmar o resultado.
11. Documentar o incidente.
12. Encerrar o atendimento.

O projeto deverá avaliar se o mesmo método de trabalho utilizado no desenvolvimento também consegue sustentar o suporte e a manutenção.

---

## 12. Medição dos resultados

O sucesso do experimento deverá ser avaliado por indicadores verificáveis.

### 12.1 Indicadores de engenharia

- Cobertura e resultados dos testes.
- Defeitos encontrados.
- Tempo de implantação.
- Disponibilidade observada.
- Latência.
- Capacidade sob carga.
- Tempo de detecção de incidentes.
- Tempo de recuperação.
- Perda de dados observada em falhas.
- Integridade após restauração.

### 12.2 Indicadores do método de IA

- Tempo necessário para iniciar uma tarefa.
- Contexto necessário para retomar o trabalho.
- Quantidade de intervenções humanas.
- Retrabalho identificado.
- Tarefas concluídas com evidências.
- Erros factuais identificados.
- Contradições detectadas.
- Sucesso na transferência entre IAs diferentes.
- Problemas introduzidos durante handoffs.
- Capacidade de reprodução independente.

### 12.3 Indicadores financeiros

- Custo financeiro direto.
- Consumo das franquias gratuitas.
- Recursos computacionais utilizados.
- Dependências de serviços externos.
- Riscos de cobrança.
- Limites que impedem crescimento.

O projeto deverá registrar também limitações e resultados negativos.

Uma hipótese não confirmada representa informação válida para o experimento, e não uma razão para ocultar resultados.

---

## 13. Roadmap inicial

### Fase 0 — Fundação

**Objetivo:** estabelecer o repositório e o método mínimo de trabalho.

Entregas previstas:

- README inicial.
- `AGENTS.md`.
- Hierarquia de regras.
- Estrutura lógica de documentação.
- Papéis e responsabilidades.
- Protocolo de tarefas.
- Handoff.
- Critérios de evidência.
- Procedimentos de auditoria.

### Fase 1 — Aplicação mínima

**Objetivo:** construir um produto funcional com uma instância de aplicação.

Entregas previstas:

- Interface inicial.
- Autenticação.
- CRUD de camisetas.
- Gestão de coleções.
- Persistência.
- Testes básicos.

### Fase 2 — Containerização

**Objetivo:** executar a aplicação em containers.

Entregas previstas:

- Imagens Docker.
- Docker Compose.
- Configuração de serviços.
- Redes internas.
- Persistência.
- Testes de inicialização e reinício.

### Fase 3 — Distribuição local

**Objetivo:** implantar o Gateway e as três instâncias regionais.

Entregas previstas:

- Proxy reverso.
- Balanceamento.
- Isolamento de serviços.
- Health checks.
- Testes de comunicação.
- Testes de falha e redistribuição.

### Fase 4 — Banco de dados e recuperação

**Objetivo:** introduzir persistência e recuperação mais avançadas.

Entregas previstas:

- Banco primário.
- Réplica de leitura.
- Testes de replicação.
- Backup.
- Restore.
- Testes de consistência.
- Simulação de falhas.

### Fase 5 — Observabilidade e resiliência

**Objetivo:** investigar o comportamento do sistema durante situações adversas.

Entregas previstas:

- Logs.
- Métricas.
- Monitoramento.
- Testes de carga.
- Testes de indisponibilidade.
- Procedimentos operacionais.
- Critérios de recuperação.

### Fase 6 — Migração para nuvem

**Objetivo:** migrar a aplicação para infraestrutura cloud gratuita.

Entregas previstas:

- Validação dos limites gratuitos.
- Provisionamento autorizado.
- Configuração de redes.
- Implantação dos serviços.
- Migração dos dados.
- Testes distribuídos.
- Cutover e rollback.

### Fase 7 — Operação e suporte

**Objetivo:** colocar o produto em uso e validar seu ciclo operacional.

Entregas previstas:

- Acesso de usuários reais.
- Registro de incidentes.
- Atendimento.
- Diagnóstico.
- Correção.
- Atualizações.
- Monitoramento contínuo.

### Fase 8 — Avaliação e consolidação

**Objetivo:** analisar os resultados do desafio.

Entregas previstas:

- Relatório técnico.
- Indicadores observados.
- Limitações.
- Falhas e aprendizados.
- Avaliação dos agentes.
- Revisão da metodologia.
- Documentação reutilizável.

As fases representam o planejamento inicial e poderão ser revistas mediante decisões documentadas.

---

## 14. Critérios gerais de conclusão

O TeamKitCollection será considerado concluído como experimento inicial quando houver evidências suficientes de que:

- O aplicativo funciona para usuários reais.
- O código e a infraestrutura podem ser reproduzidos.
- Os testes essenciais foram executados.
- Os dados persistem corretamente.
- Backups podem ser restaurados.
- Falhas podem ser detectadas e investigadas.
- Os procedimentos de recuperação foram exercitados.
- A migração de ambiente foi demonstrada.
- Um incidente de usuário foi tratado até seu encerramento.
- Uma tarefa foi transferida com sucesso entre IAs distintas.
- A documentação permite compreender e continuar o projeto.
- Os custos permaneceram dentro das restrições definidas.
- Os resultados positivos e negativos foram registrados.

Esses critérios serão posteriormente detalhados em requisitos e testes de aceitação mensuráveis.

## 15. Estado atual do projeto

**Visão do produto:** PLANEJAMENTO. **Metodologia:** contratos documentais em evolução; protocolos COM-001/COM-002 especificados, ainda sem validação operacional ponta a ponta. **Estado vigente dos marcos:** consultar [IA/PROJETO.md](IA/PROJETO.md).

Como registro histórico da concepção inicial deste README:

- O nome e a proposta do projeto estão definidos.
- O aplicativo de coleções esportivas foi selecionado.
- A arquitetura experimental local foi proposta.
- A intenção de migração para Oracle Cloud foi estabelecida.
- A metodologia multiagente está em fase de definição.
- O roadmap inicial foi elaborado.

A revisão atual tampouco afirma que o aplicativo, containers, bancos ou VMs de produção do projeto estejam implantados. Contratos de IA publicados não provam automação, testes ponta a ponta nem operação.

O estado técnico efetivo deverá ser registrado em documentação própria e confirmado por código, Git, testes e evidências do ambiente correspondente.

---

## 16. Visão de longo prazo

O TeamKitCollection não pretende desenvolver uma metodologia exclusiva para coleções esportivas.

O aplicativo funciona como um cenário controlado para estudar problemas comuns a diversos sistemas, como:

- Sistemas comerciais.
- Gestão de frotas.
- Sistemas escolares.
- Plataformas administrativas.
- Portais de atendimento.
- Sistemas corporativos internos.
- Aplicações distribuídas.
- Serviços digitais públicos.

A metodologia resultante deverá ser independente do domínio de negócio, das linguagens, da infraestrutura e dos fornecedores de inteligência artificial.

O aprendizado obtido deverá permitir o desenvolvimento de projetos progressivamente mais complexos, preservando os mesmos princípios de rastreabilidade, continuidade e responsabilidade.

---

## 17. Princípio orientador

> **A IA é temporária. A função é substituível. A tarefa é persistente. O conhecimento pertence ao projeto. A autoridade depende de permissões verificáveis. A conclusão depende de evidências.**

O objetivo não é apenas demonstrar que a inteligência artificial consegue produzir código.

É investigar se um processo de engenharia apoiado por inteligências artificiais consegue entregar, manter, recuperar e evoluir um sistema real, independentemente de qual agente esteja trabalhando.

---

**TeamKitCollection — Um aplicativo simples. Um laboratório completo de engenharia de software. Um método independente de inteligência artificial.**
