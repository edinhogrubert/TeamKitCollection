# M1 — Critérios de aceite e fronteiras de evidência

**Identificador:** M1-ACEITE-001  
**Versão:** 0.1.0  
**Estado:** PROPOSTA DOCUMENTAL PUBLICADA — ainda não aprovada como encerramento do marco  
**Projeto:** TeamKitCollection  
**Motivação:** achados A01, A02 e A03 do parecer `IA/validacao/M1_AUDITORIA_CODEX.md`  
**Aplicação:** avaliação futura de M1, sem retroatividade para elevar resultados históricos

## 1. Três entregas distintas

| Entrega | O que pode ser declarado | O que NÃO pode ser inferido |
|---|---|---|
| M1-DOC — contratos documentados | Arquivos GOV/SEC e referências existem, foram lidos e inspecionados | Eficácia da governança, resistência real a instruções ou bloqueio técnico |
| M1-TXT — ensaios textuais auditáveis | Prompts e respostas preservados, avaliáveis por rubrica explícita e revisão distinta | Execução segura ou possibilidade de autorizar deploy |
| M1-OPS — controles operacionais validados | Comportamentos e controles efetivamente exercitados em ambiente autorizado, com logs, isolamento e recuperação | Garantia universal de segurança em ambientes não testados |

**Não é permitido transformar M1-DOC ou M1-TXT em M1-OPS por interpretação.** Na data deste registro, M1-OPS está **NÃO DEMONSTRADO**.

## 2. Critérios verificáveis de M1-DOC

M1-DOC somente pode ser **APROVADO** quando **todos** forem satisfeitos:

- [ ] D1. `AGENTS.md`, `IA/regras/constituicao.md`, `IA/regras/seguranca.md`, `IA/PROJETO.md` e `IA/PLANO_EVOLUCAO.md` existentes, acessíveis, com revisão Git anotada.
- [ ] D2. Contratos GOV-001..005 e SEC-001..010 identificáveis, sem conflito normativo material não resolvido.
- [ ] D3. Roteamento e estado **vigente** separados explicitamente dos registros históricos; inexistência de duas instruções atuais de próximo passo em conflito.
- [ ] D4. Marcos M3/M5 harmonizados entre `PLANO_EVOLUCAO.md` e `PROJETO.md` ou divergência formalmente decidida.
- [ ] D5. Fonte e grau de verificabilidade das decisões humanas identificados; declaração `MEDIADO` quando o registro original não puder ser conferido.
- [ ] D6. Relatórios de ensaio distinguem `DOCUMENTADO`, `RELATADO`, `VERIFICADO`, `NÃO EXECUTADO` e `NÃO REPRODUZÍVEL` sem inflar resultados.
- [ ] D7. `CTX-001` possui manifesto suficiente para localizar repositório, branch, fonte e captura; qualquer ausência de commit é explícita.
- [ ] D8. Revisão por agente/sessão distinta com leitura primária e avaliação registrada para os critérios D1–D7.
- [ ] D9. Decisão humana de aceite identifica escopo `M1-DOC`, versão/revisão e ressalvas; falta de decisão é `PENDENTE`.

O simples fato de este checklist existir **não** satisfaz seus itens.

## 3. Critérios verificáveis de M1-TXT

M1-TXT somente pode ser **APROVADO** quando:

- [ ] T1. Existe inventário para GOV-T01..T07 e SEC-T01..T10, sem omissão de cenário.
- [ ] T2. Cada ensaio considerado PASS tem **prompt integral**, **resposta integral**, origem/sessão identificável em nível compatível com privacidade, momento e referência imutável ou artefato versionado. Se faltar conteúdo, classificar `RELATO NÃO REPRODUZÍVEL`, nunca PASS auditado.
- [ ] T3. Rubrica de aceite publicada **antes das novas execuções**; para ensaios históricos, identificar explicitamente que a rubrica é retrospectiva e não alegar pré-registro.
- [ ] T4. Distinguir testes de recusa de cenários de alteração legitimamente autorizada; não usar um como prova do outro.
- [ ] T5. Registrar testes orientados, retestes e repetições sobrepostas; não tratar 17 IDs como 17 experimentos independentes.
- [ ] T6. Um revisor distinto confere entrada, resposta, rubrica e conclusão com as fontes **primárias**, documentando divergências.
- [ ] T7. Decisão humana autoriza a classificação de encerramento `M1-TXT`, indicando lacunas e limites.

Quando registros integrais do histórico não estiverem disponíveis, repetir cenários de maneira controlada, preservando o resultado histórico sem substituí-lo.

## 4. Critérios de M1-OPS (fora do escopo atual)

Antes de alegar M1-OPS é necessário projetar testes em ambiente descartável, com autorização específica para ações L2/L3, controles de acesso observáveis, logs e rollback. Exemplos: recusa comprovada de operação sem autorização; aprovação válida restrita a escopo; impossibilidade técnica de elevar papel por documento; recuperação de mudança e verificação. **Nenhuma execução é autorizada por este documento.**

## 5. Protocolo de verificação

1. Identificar commit/branch e arquivos de entrada.
2. Conferir os itens contra fontes, sem declarar `VERIFICADO` para relato de outra IA.
3. Registrar `PASS`, `FALHA`, `PENDENTE` ou `NÃO REPRODUZÍVEL`, citando artefato.
4. Preservar divergências e pareceres, inclusive decisões anteriores negativas.
5. Colher autorização de aceite apenas para a entrega especificada (M1-DOC, M1-TXT ou M1-OPS).

## 6. Estado inicial após auditoria

- **M1-DOC:** NÃO APROVADO, achados A03, A06, A07 e divergências de orientação ainda em tratamento.
- **M1-TXT:** NÃO APROVADO para certificação auditável; 17 respostas historicamente reportadas, sem preservação primária integral em Git.
- **M1-OPS:** NÃO DEMONSTRADO.
- **M1-REVISAO:** EM_ANDAMENTO. O Codex emitiu parecer `REPROVAR` no commit `805258836370c6a6bd378eafd7f6bac8b2c75340`.

O objetivo é tornar uma decisão de fechamento refutável e reprodutível. Os resultados prévios continuam no relatório histórico, mas não são automaticamente homologados.
