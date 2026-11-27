# TKC-REQ-0013 — Consolidação de arquitetura e dependências

**order_id:** `TKC-REQ-0013`  
**task_id:** `TKC-0013`  
**sender:** AGT-001 (liderança e preparação documental C01)  
**recipient:** AGT-001 — designação funcional, sessão ainda não confirmou RECEBIDO  
**request_type:** parecer/planejamento L0/L1 exclusivamente  
**status:** `DISPONIVEL_PARA_ENTREGA`; sem despacho automático  
**authorization:** HUMAN-001 solicitou publicar os três despachos somente para análise L0/L1; origem `MEDIADO` no Git. Sem autorização de código, Docker, VM, arquivos de produto ou execução.  
**base_commit:** `ce587c639fd598a31cce0b816d311f9611cb1551` — revalidar `main` ao receber  
**claim_preparation:** `TKC-0013-C01` publicado e confirmado antes da ordem, exclusivamente documental AGT-001  
**task_record:** `IA/tarefas/TKC-0013.md`  
**return_reference:** `TKC-PAR-0013`, por COM-002.2, via conversa mediada. Publicação direta requer autorização de escrita de comunicação e reivindicação específica do receptor.

## Missão
Reconciliar fronteiras entre Backend (AGT-004), DevOps (AGT-003) e QA (AGT-002), produzir visão de dependências e critérios de integração do primeiro corte. Verificar interfaces e conflitos de caminhos e organizar uma sequência de autorização sem alterar contratos normativos ou código. Atividade de análise do líder em sessão ativa, sem executar nem atribuir automaticamente trabalhos aos demais.

## Fontes prioritárias (leitura)
AGENTS.md; IA/PROJETO.md (somente leitura); IA/tarefas/TKC-0005.md; IA/tarefas/TKC-0009.md; IA/tarefas/TKC-0010.md; IA/tarefas/TKC-0011.md; IA/tarefas/TKC-0012.md; docs/arquitetura.md; docs/contratos-api.md; docs/infraestrutura.md

## Critérios e entregável
TKC-PAR-0013: mapa de interfaces, dependências técnicas, conflitos/risco e sequência de revisões e decisões sem atribuir aceite antecipado.

Classificar fatos como `VERIFICADO`, `MEDIADO`, `RELATADO` ou `NÃO_EXECUTADO`. Confrontar `main` atual, COM-001/COM-002, e distinguir hipóteses de falhas reproduzidas. Incluir recomendações pequenas e os arquivos de uma eventual correção, mas não implementá-la. Indicar dependências que precisem ser coordenadas antes de dois agentes modificarem arquivos sobrepostos.

## Limites
Não modificar código, testes, scripts, configuração Compose, documentos de produto, normas ou infraestrutura. Não instalar dependências nem usar Docker, VM, redes, PostgreSQL ou volume; nenhum custo adicional. Não publicar no Git sem autorização de escrita específica. Não invocar outra IA automaticamente.

## Transporte e encerramento
HUMAN-001 leva apenas `TKC-REQ-0013` para a sessão destinatária. A publicação desta ordem não prova recebimento. Sem acesso Git de escrita autorizado, devolver parecer integral na conversa e encerrar `TKC-PAR-0013 PRONTA — SEM ESCRITA GIT. LEVE ESTA RESPOSTA A AGT-001`. Se autorizado em etapa própria, registrar nova posse COM-001 antes de publicar `IA/despachos/retornos/TKC-PAR-0013.md` e informar o commit.
