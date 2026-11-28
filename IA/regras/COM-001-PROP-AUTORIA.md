# Proposta COM-001 — Autoria, registro e publicação

**estado:** `PROPOSTA` — não incorporada à COM-001
**base:** `4b482ae`
**escopo:** rastreabilidade documental; não altera produto, infraestrutura, VM, histórico Git ou M3-02

## Regra proposta

Todo artefato produzido com participação de IA deve distinguir, quando conhecidos:

```yaml
agent_id: <identificador do agente>
ai_model: <modelo e versão, se declarados>
intellectual_author: <IA ou humano que produziu o conteúdo>
recorded_by: <agente ou humano que transcreveu/gravou>
role: <papel funcional>
published_by: <humano que autorizou/publicou>
git_commit_author: <identidade técnica exibida pelo Git>
source_commit_sha: <commit objeto da análise ou alteração>
record_commit_sha: <commit que contém o registro, quando aplicável>
```

## Regras de interpretação

1. `intellectual_author` não deve ser inferido do autor técnico do Git.
2. `recorded_by` identifica quem efetuou a gravação documental, sem receber autoria intelectual por isso.
3. `published_by` identifica a autorização/publicação humana; não implica autoria do conteúdo.
4. `git_commit_author` é evidência de identidade técnica do commit, não prova de modelo de IA.
5. Modelo, autoria ou publicador não comprovados devem ser marcados como `DESCONHECIDO` ou `DECLARADO_POR_HUMAN-001`, nunca presumidos.
6. Correções posteriores acrescentam novo registro; não reescrevem o histórico Git nem alteram retroativamente o estado de M3-02.

## Aplicação ao caso auditado

As atribuições de Grok 4.5 para o conteúdo anterior decorrem de declaração de `HUMAN-001`. Codex/AGT-002 efetuou o registro documental e HUMAN-001 publicou os commits. Essa atribuição deve permanecer identificada como declarada, não como inferência automática.

## Aprovação necessária

Esta proposta deve ser revisada e incorporada à `IA/regras/comunicacao.md` somente após autorização específica de HUMAN-001 e eventual validação de AGT-001.
