# PROJETO — Controle de Evolução

**Projeto:** TeamKitCollection  
**Identificação:** M1-01  
**Estado:** PENDENTE  
**Próxima etapa:** M1-01 — Redigir e validar `IA/regras/constituicao.md`

---

## Controle das etapas

| Identificação | Etapa | Estado |
|---|---|---|
| M0-01 | Definir a visão geral do projeto | CONCLUÍDO |
| M0-02 | Elaborar `README.md` | CONCLUÍDO |
| M0-03 | Elaborar `AGENTS.md` | CONCLUÍDO |
| M0-04 | Definir a separação entre `IA/` e `docs/` | CONCLUÍDO |
| M0-05 | Elaborar `IA/PLANO_EVOLUCAO.md` | CONCLUÍDO |
| M0-06 | Criar `IA/PROJETO.md` | CONCLUÍDO |
| M0-07 | Atualizar `AGENTS.md` com a estrutura definitiva | CONCLUÍDO |
| M1-01 | Redigir e validar `IA/regras/constituicao.md` (arquivo vazio existente) | PENDENTE |
| M1-02 | Criar `IA/regras/seguranca.md` | PENDENTE |
| M2-01 | Criar `IA/regras/confiabilidade.md` | PENDENTE |
| M3-01 | Criar `IA/regras/comunicacao.md` | PENDENTE |
| M4-01 | Criar os contratos em `IA/papeis/` | PENDENTE |
| M5-01 | Implementar o protocolo de tarefas e handoff | PENDENTE |
| M6-01 | Criar verificações automatizadas | PENDENTE |
| M7-01 | Validar o método durante desenvolvimento e operação | PENDENTE |
| M8-01 | Testar a portabilidade entre projetos | PENDENTE |
| M9-01 | Avaliar os resultados e aperfeiçoar o método | PENDENTE |

## Estados permitidos

- `PENDENTE` — Ainda não iniciado.
- `EM_ANDAMENTO` — Em execução.
- `CONCLUÍDO` — Finalizado com evidências.
- `BLOQUEADO` — Impedimento identificado.
- `CANCELADO` — Não será executado.

## Regra de atualização

Ao finalizar uma atividade, o agente deverá:

1. Atualizar seu estado.
2. Registrar a evidência de conclusão ou a referência correspondente.
3. Atualizar a identificação e a próxima etapa no início deste arquivo.
4. Manter o histórico das etapas anteriores.

Uma etapa somente poderá ser marcada como `CONCLUÍDO` quando sua entrega estiver verificada no repositório.

---

**Última verificação do estado no Git:** 2026-11-22 — `README.md`, `AGENTS.md`, `IA/PLANO_EVOLUCAO.md` e `IA/PROJETO.md` existem em `main`. Arquivo `IA/regras/constituicao.md` tem apenas 1 byte (sem contrato implementado). `docs/` e código da aplicação ainda não existem. O script de VM foi preservado em `scripts/infra/create-vm-virtualbox.sh`, sem execução nem testes.

**Atenção:** o script existente de VM contém exclusão automática de VM com nome coincidente e tratamento potencialmente incorreto de imagem `.img`; requer revisão e aprovação específica antes de ser executado.

**Evidências:** verificar o histórico de commits da `main` e os caminhos acima; documentação concluída significa arquivo presente, não validação de funcionalidade.
