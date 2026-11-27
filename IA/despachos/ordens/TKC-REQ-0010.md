# TKC-REQ-0010 — Solicitação de análise DevOps: Bash errexit no menu

**order_id:** `TKC-REQ-0010`  
**task_id:** `TKC-0010`  
**from:** AGT-001 — líder técnico, revisor de `TKC-RET-0009`  
**to:** AGT-003 — DevOps/SRE  
**status:** `DISPONIVEL_PARA_ENTREGA` (não entregue automaticamente)  
**request_type:** L0/L1, revisão técnica e proposta de correção; **não autoriza editar scripts ou executar Docker**  
**decision_provenance:** HUMAN-001 pediu "ok, vamos enviar" após a revisão de AGT-001. `MEDIADO` no Git.  
**base_commit:** `90a09e6aa85f5b3d22fa6242d929ac78ea0f95bf` (revalidar main no recebimento)  
**task_record:** `IA/tarefas/TKC-0010.md`  
**source:** `scripts/infra/teamkit-lab.sh`, função `run_menu_action()`; retorno `IA/despachos/retornos/TKC-RET-0009.md`  
**return:** parecer na própria conversa via COM-002.2; publicação Git somente se nova autorização L2 para caminhos de retorno for concedida.

## Achado de revisão — AGT-001

A entrega C04 de TKC-0009 implementou:

```bash
run_menu_action() {
  local act="$1" rc=0
  if ( action "$act" ); then
    return 0
  else
    rc=$?
    printf '[ATENÇÃO] Ação "%s" finalizou com código %s. O menu permanece ativo para diagnóstico.\n' "$act" "$rc" >&2
    return 0
  fi
}
```

No Bash, comandos e funções executados em contextos cuja condição é testada por `if` podem ter o efeito de `errexit` (`set -e`) ignorado em seu corpo. O wrapper acima torna plausível que uma falha interna de `action` / `run_existing` ou outra função, quando não verificada explicitamente, permita que comandos seguintes continuem. O erro pode então ser mascarado por um último comando que retorna 0. **A-01 pode estar resolvido superficialmente sem garantir fail-fast para operações modificadoras.**

## O que avaliar

1. Reproduza a semântica em Bash **somente com funções sintéticas sem efeitos externos** (exemplo `set -e; work(){ false; echo UNSAFE_CONTINUED; }; if (work); then ...`), identificando onde `errexit` é ignorado.
2. Inspecione as chamadas dos caminhos `docker-install`, `pg-start`, `persist`, `backend-up` e `backend-fault` e avalie se esse wrapper pode mascarar falhas ou permitir etapas modificadoras após uma falha.
3. Proponha alternativa mínima robusta que mantenha o menu após erro **sem suprimir a segurança do tratamento de erros dentro das ações**. Compare, por exemplo, execução em subshell com controle explícito dos códigos, `trap ERR`, ou validações locais `|| return` e política uniforme de falha, deixando claro o comportamento real da versão Bash testada.
4. Proponha testes negativos sem Docker: funções/mocks que falham no meio da sequência devem impedir a execução do próximo comando e retornar código diferente de zero, mas o menu deve continuar e exibir o diagnóstico. Prove também que a execução direta da CLI propaga código `!=0`.
5. Declare outros riscos encontrados, ações de correção necessárias, impacto da mudança e quais arquivos realmente precisariam de alteração. Não confunda `bash -n` com teste de semântica de erro.

## Restrições

Nenhum patch foi autorizado nesta nova tarefa. **Não modificar `teamkit-lab.sh`, `backend-lab.sh`, bancos, containers, volumes, redes ou código de aplicação.** Sem execução Docker ou testes da VM; sem custos adicionais. A antiga autorização `TKC-AUT-0009 #TRUE` foi usada para a tentativa C04 e não autoriza automaticamente outra tentativa.

## Resultado esperado

Parecer curto `TKC-PAR-0010` (`CONFIRMADO`, `REFUTADO` ou `PARCIAL`) com teste reproduzível, diagnóstico, proposta de patch, limites e critérios de aceite. Entregar conteúdo no canal humano COM-002.2. Se desejar publicar via Git, solicitar antes autorização L2 específica para os registros.

**Próxima porta:** AGT-001 revisa o parecer e apresenta eventual patch para decisão específica de HUMAN-001, sem iniciar operações na VM.
