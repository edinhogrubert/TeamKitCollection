# TKC-REQ-0012 — Matriz QA/Segurança independente

**order_id:** `TKC-REQ-0012`  
**task_id:** `TKC-0012`  
**sender:** AGT-001 (liderança e preparação documental C01)  
**recipient:** AGT-002 — designação funcional, sessão ainda não confirmou RECEBIDO  
**request_type:** parecer/planejamento L0/L1 exclusivamente  
**status:** `DISPONIVEL_PARA_ENTREGA`; sem despacho automático  
**authorization:** HUMAN-001 solicitou publicar os três despachos somente para análise L0/L1; origem `MEDIADO` no Git. Sem autorização de código, Docker, VM, arquivos de produto ou execução.  
**base_commit:** `ce587c639fd598a31cce0b816d311f9611cb1551` — revalidar `main` ao receber  
**claim_preparation:** `TKC-0012-C01` publicado e confirmado antes da ordem, exclusivamente documental AGT-001  
**task_record:** `IA/tarefas/TKC-0012.md`  
**return_reference:** `TKC-PAR-0012`, por COM-002.2, via conversa mediada. Publicação direta requer autorização de escrita de comunicação e reivindicação específica do receptor.

## Missão
Desenhar critérios e casos de teste para ciclo GET /health 200 -> 503 -> 200, persistência do PostgreSQL, idempotência do menu, tratamento de sinais, segredo em logs, ausência de 5432 no host e regressão. Separar testes simulados dos que só podem ocorrer na VM. Revisar criticamente riscos da implementação sem alegar que testou ambiente não acessível. Não auditar alterações futuras que o próprio agente venha a executar.

## Fontes prioritárias (leitura)
IA/despachos/retornos/TKC-PAR-0009.md; IA/despachos/retornos/TKC-RET-0009.md; scripts/infra/backend-lab.sh; scripts/infra/teamkit-lab.sh; tests/unit/test_health_unit.py; tests/integration/test_health_compose.py; docs/testes.md; IA/tarefas/TKC-0010.md

## Critérios e entregável
TKC-PAR-0012: matriz de testes com pré-condição/entrada/resultado esperado/evidência, prioridades bloqueantes e limitações de execução.

Classificar fatos como `VERIFICADO`, `MEDIADO`, `RELATADO` ou `NÃO_EXECUTADO`. Confrontar `main` atual, COM-001/COM-002, e distinguir hipóteses de falhas reproduzidas. Incluir recomendações pequenas e os arquivos de uma eventual correção, mas não implementá-la. Indicar dependências que precisem ser coordenadas antes de dois agentes modificarem arquivos sobrepostos.

## Limites
Não modificar código, testes, scripts, configuração Compose, documentos de produto, normas ou infraestrutura. Não instalar dependências nem usar Docker, VM, redes, PostgreSQL ou volume; nenhum custo adicional. Não publicar no Git sem autorização de escrita específica. Não invocar outra IA automaticamente.

## Transporte e encerramento
HUMAN-001 leva apenas `TKC-REQ-0012` para a sessão destinatária. A publicação desta ordem não prova recebimento. Sem acesso Git de escrita autorizado, devolver parecer integral na conversa e encerrar `TKC-PAR-0012 PRONTA — SEM ESCRITA GIT. LEVE ESTA RESPOSTA A AGT-001`. Se autorizado em etapa própria, registrar nova posse COM-001 antes de publicar `IA/despachos/retornos/TKC-PAR-0012.md` e informar o commit.
