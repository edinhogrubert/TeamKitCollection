# Plano de Evolução do Método de Engenharia com IA

**Projeto de validação:** TeamKitCollection  
**Versão:** 0.1.0  
**Estado:** PLANEJADO  
**Controle operacional:** [PROJETO.md](PROJETO.md)

## Finalidade
Criar um método de engenharia de software com múltiplas IAs que permita delegar papéis, preservar evidências e transferir tarefas entre modelos e conversas sem depender do histórico do chat.

## Separação fundamental
- `IA/`: como agentes trabalham — governança, contratos, papéis, tarefas, handoff, auditoria e validação.
- `docs/`: como o produto é construído e operado — documentação técnica compreensível por uma equipe humana sem necessidade de consultar `IA/`.
- Código, scripts, testes e infraestrutura: artefatos executáveis do produto, documentados por `docs/` e governados pelo processo em `IA/`.

O método deve poder ser reutilizado sem carregar regras de negócio do TeamKitCollection. O produto deve poder ser compreendido, reconstruído e operado por humanos sem depender de conversas com IAs.

## Marcos de evolução

| Marco | Objetivo | Evidência de aceitação |
|---|---|---|
| M0 | Fundação documental e organização | Estrutura, README, AGENTS, plano e controle verificados no Git |
| M1 | Constituição e segurança | Autorização, responsabilidade, limites e interrupções especificados e testados |
| M2 | Confiabilidade e anti-alucinação | Agentes distinguem evidências, hipóteses e contradições em cenários de teste |
| M3 | Comunicação, tarefas e handoff | Uma IA retoma tarefa iniciada por outra com base no estado persistido |
| M4 | Papéis profissionais | Contratos independentes de fornecedores de IA, com entradas e saídas claras |
| M5 | Coordenação multiagente | Conflitos de alterações e dependências tratados sem sobrescrita silenciosa |
| M6 | Verificação automatizada | Ferramentas detectam contratos inválidos e evidências ausentes |
| M7 | Operação e suporte | Incidente real ou simulado rastreado de relato até resolução e validação |
| M8 | Portabilidade | Método aplicado a outro projeto, sem regras específicas do aplicativo |
| M9 | Avaliação | Métricas de continuidade, retrabalho, qualidade e custo registradas |

## Regras de condução
1. O plano estabelece direção, não comprova implementação.
2. O estado atual, a próxima atividade e o histórico resumido ficam em `IA/PROJETO.md`.
3. O estado detalhado de cada trabalho fica em `IA/tarefas/`, quando o protocolo estiver definido.
4. Novas regras devem ter fonte principal única; outros documentos apenas a referenciam.
5. Um agente só declara conclusão quando houver evidências proporcionais ao risco.
6. O método cresce conforme os experimentos demonstram necessidade, evitando burocracia ornamental.
7. Regras do produto pertencem a `docs/`, não aos contratos universais da metodologia.
8. Toda mudança do método deve considerar compatibilidade, risco, custo de contexto e possibilidade de reversão.

## Próximo marco
Concluir M0 com o alinhamento do `AGENTS.md` e depois iniciar **M1: `IA/regras/constituicao.md`**.

> Este arquivo é planejamento metodológico. Não é o roadmap técnico da aplicação, que ficará em `docs/ROADMAP.md`.
