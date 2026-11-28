# TKC-AUT-0016 — Patch unitário mínimo de indisponibilidade do backend

task_id: TKC-0016
order_id: TKC-0016-O08
short_ref / request_type: TKC-AUT-0016 / AUT L2
revision: 1
recipient / executor: AGT-004 — Backend
reviewer: AGT-002 — QA/Security (distinto)
sender / intellectual_author / recorded_by: AGT-001 III (ChatGPT / GPT-6.2 AUTODECLARADO)
authorization_state: PENDENTE — decisão humana específica ainda necessária
status: PUBLICADO após confirmação Git; recebimento não confirmado
decision_ref: TKC-AUT-0016 @SHA #TRUE
authorization_provenance / approval_channel: HUMAN-001 em sessão autorizada, MEDIADO no Git
repository / branch: edinhogrubert/TeamKitCollection / main
base_commit: c4eb464573f871a0df6ffa1ddf4695d94a7b1cfe
task_record: IA/tarefas/TKC-0016.md
product_scope_paths: tests/unit/test_health_unit.py (somente patch definido abaixo)
documentation_write_authorization: PENDENTE; incorporada à decisão humana desta ordem, somente caminhos abaixo
documentation_scope_paths: IA/tarefas/TKC-0016.md; IA/tarefas/indice.md (linha própria); IA/despachos/logs/TKC-EXE-0016.md; IA/despachos/retornos/TKC-RET-0016.md
log_path: IA/despachos/logs/TKC-EXE-0016.md
return_path: IA/despachos/retornos/TKC-RET-0016.md
feasibility_report_ref: TKC-PAR-0016 @706cda0 (AGT-004 C01), linha de base humana @4f5770815c9f4dbc996aeee1fef4e2252c7fb605
capability_evidence: escrita remota histórica AGT-004 C01/C03 (706cda0, 152afb1), revalidar sessão e claim; testes na VM HUMAN-001, baseline 3/3 CAP R05 MEDIADO; capacidade autônoma de teste dos agentes não comprovada nem requerida nesta fase
dependencies / claim_conflicts: C14 entregue sem posse ativa; conferir HEAD/diff desde base, blob de teste a165e47889ddcc99c026a2562914336f9077738a, nenhuma sobreposição e regras vigentes antes de reivindicar; se divergência material, parar
risk: L2 patch unitário isolado, sem mudança de runtime, banco ou infraestrutura
cost_limit: R$ 0,00 absoluto; nada pago ou potencialmente faturável; dúvida implica parada
forbidden_actions: executar testes/comandos na VM, Docker, instalar dependências, pull/build, criar recursos, alterar scripts, aplicação, configuração, credenciais, infraestrutura, outros testes/normas/arquivos; sem branch nova, force push, reset, rebase ou reintegrar 0236363
stop_condition: autorização, capacidade Git, posse, escopo ou integridade incertos; conflito ou risco de cobrança; retornar referência e motivo curto

## Objeto e critérios de aceite

Modificar exclusivamente tests/unit/test_health_unit.py para parametrizar o teste existente de indisponibilidade com Exception e OSError, mantendo mensagem sintética, resposta HTTP 503, igualdade exata do JSON {"status":"unhealthy","database":"down","error":"DB_UNAVAILABLE"}, ausência da mensagem interna no texto e mock src.backend.main.check_database chamado exatamente uma vez por caso. Preservar sucesso HTTP 200 e recuperação 200/503/200 e respectivos imports/definições; adicionar somente import pytest e alterações estritamente necessárias ao teste. Esperado: quatro casos aprovados no total. Sem banco real, rede de teste ou mudança de código de aplicação.

## Implementação e validação separadas

AGT-004: confirmar leitura/escrita Git na sessão, decisão e escopo, publicar e confirmar nova reivindicação antes de editar o teste. Fazer inspeção estática do diff, preservar história, publicar checkpoints e entrega nos caminhos exatos; conferir diff desde HEAD efetivo da reivindicação e confirmar publicação. Registrar commit do teste, blob, revisão e contagem esperada, testes NÃO_EXECUTADOS nesta fase. Não declarar aprovação funcional. Encerrar posse e retornar TKC-RET-0016 + SHA; estado EM_REVISAO. A ordem autoriza somente implementação e registros após decisão válida, não execução na VM. Revalidar deslocamentos documentais da coordenação sem herdar posse ou autorização; bloqueio se alteração material.

AGT-003: posteriormente preparar por autorização própria o script versionado de validação do novo commit, reaproveitando a solução R05 e seus controles, fixando SHA/blob e quatro casos; R05 original está fixada na baseline de três casos e não valida o patch. Nenhum novo diagnóstico ambiental necessário. AGT-002 revisa independentemente patch e script, critérios de parada e integridade. HUMAN-001, único operador da VM, executa via curl fixado após aprovação técnica e decisão humana específica. Comando pytest previsto: python -m pytest -q -p no:cacheprovider --color=no --tb=no tests/unit/test_health_unit.py. Evidência esperada: quatro aprovados, retorno pytest/Docker zero, estado limpo; aviso registrar se houver. Registrar resultado MEDIADO, não atribuir execução aos agentes. Aceite final separado; M3-02 PENDENTE.

Não criar arquivos fora do escopo nem iniciar etapa de outro agente por iniciativa própria. Métricas não disponíveis: NÃO MEDIDO. A publicação da ordem não autoriza patch; aguardar decisão HUMAN-001.
